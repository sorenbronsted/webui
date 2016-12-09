part of webui;

abstract class UiTableListener {
  onTableRow(TableRowElement tableRow, Map row);
  onTableCellValue(TableCellElement cell, String cls, String property, Map row);
  onTableCellLink(TableCellElement cell, AnchorElement link, String cls, String property, Map row);
}

abstract class UiTableCss {
  onSortColumn(TableCellElement th, int direction);
  void clearSortColumn(TableCellElement orderBy);
}

class UiDefaultTableCss implements UiTableCss {
  @override
  onSortColumn(TableCellElement th, int direction) {
    // Do nothing
  }

  @override
  void clearSortColumn(TableCellElement orderBy) {
    // Do nothing
  }
}

class UiTable extends TableElement with UiBind implements ObjectStoreListener {
  static const String uiTagName = 'x-table';
  static const none = 0;
  static const asc = 1;
  static const dsc = 2;

  static UiTableCss _css = new UiDefaultTableCss();

  UiTableListener _listener;
  TableCellElement _orderBy;
  int _direction = none;
  View _view;

  set listener(UiTableListener listener) => _listener = listener;

  static set css(UiTableCss css) => _css = css;

  UiTable.created() : super.created() {
    setBind(getAttribute('bind'));
  }

  void bind(ObjectStore store, View view) {
    _view = view;
    store.addListener(this, _cls);
    querySelectorAll('#${id} th.sortable').onClick.listen((event) {
      event.preventDefault();
      _setSortingUi(event.target);
      _doSort();
    });
  }

  void valueChanged(String cls, String property) {
    if (tHead == null || tHead.children.length != 1) {
      throw new Exception("Must have a thead element");
    }
    if (tBodies.length > 1) {
      throw new Exception("Multiple bodies not supported");
    }
    var body = tBodies.first;
    body.children.clear();

    var objects = _view.store.getObjects(cls);
    var fragment;
    if (objects.isEmpty) {
      fragment = _noRows();
    }
    else {
      fragment = _addRows(objects);
    }
    body.append(fragment);
  }

  DocumentFragment _addRows(List<Map> rows) {
    var fragment = new DocumentFragment();
    rows.forEach((row) {
      var tableRow = new TableRowElement();
      _listener?.onTableRow(tableRow, row);

      // Make the table row
      fragment.append(tableRow);
      var columns = querySelectorAll('#${id} th');
      columns.forEach((UiTh column) => column.addCell(_view, _listener, tableRow, row));
    });
    return fragment;
  }

  DocumentFragment _noRows() {
    var tableCell = new TableCellElement();
    var columns = tHead.querySelectorAll('th');
    tableCell.colSpan = columns.length;
    tableCell.appendText('Ingen data fundet');
    tableCell.classes.add('center');
    var result = new DocumentFragment();
    result.append(new TableRowElement().append(tableCell));
    return result;
  }

  void _doSort() {
    if (tBodies.length > 1) {
      throw "Multiple bodies not supported";
    }
    var body = tBodies.first;
    if (body == null) { // nothing to sort
      return;
    }
    var idx = tHead.rows.first.cells.indexOf(_orderBy);
    var tmp = new List.from(body.children);
    tmp.sort((TableRowElement a, TableRowElement b) {
      String aVal = Format.internal(_orderBy.attributes['type'], a.cells.elementAt(idx).text, _orderBy.attributes['format']);
      String bVal = Format.internal(_orderBy.attributes['type'], b.cells.elementAt(idx).text, _orderBy.attributes['format']);
      var result = 0;
      switch (_direction) {
        case asc:
          result = aVal.compareTo(bVal);
          break;
        case dsc:
          result = bVal.compareTo(aVal);
          break;
      }
      return result;
    });
    body.children = tmp;
  }

  void _setSortingUi(TableCellElement target) {
    if (_orderBy != null && _orderBy.attributes['bind'] == target.attributes['bind']) {
      _direction++;
      if (_direction > 2) {
        _direction = none;
      }
    }
    else {
      if (_orderBy != null) {
        _css.clearSortColumn(_orderBy);
      }
      _orderBy = target;
      _direction = asc;
    }
    _css.onSortColumn(_orderBy, _direction);
  }

}