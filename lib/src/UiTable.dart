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

class UiTable extends UiElement {
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

  UiTable(this._view, table) : super(table) {
    if (cls == null) {
      throw new Exception("Table must a data-class attribute");
    }

    if ((htmlElement as TableElement).tHead == null || (htmlElement as TableElement).tHead.children.length != 1) {
      throw new Exception("Must have a thead element"); //TODO make table header dynamic
    }
    if ((htmlElement as TableElement).tBodies.length > 1) {
      throw new Exception("Multiple bodies not supported");
    }

    (htmlElement as TableElement).tHead.children.first.children.forEach((TableCellElement th) {
      _view._addBinding(new UiTh(th, cls));
      if (th.classes.contains('sortable')) {
        th.onClick.listen((event) {
          event.preventDefault();
          _setSortingUi(event.target);
          _doSort();
        });
      }
    });
  }

  @override
  void update() {
    var body = (htmlElement as TableElement).tBodies.first;
    body.children.clear();

    Iterable<Map> objects = store.getObjects(cls);
    var fragment;
    if (objects.isEmpty) {
      fragment = _noRows();
    }
    else {
      fragment = _addRows(objects);
    }
    body.append(fragment);
  }

  DocumentFragment _addRows(Iterable<Map> rows) {
    var fragment = new DocumentFragment();
    rows.forEach((row) {
      var tableRow = new TableRowElement();
      _listener?.onTableRow(tableRow, row);

      // Make the table row
      fragment.append(tableRow);
      _view.bindings.forEach((UiElement elem) {
        if (elem is UiTh) {
          elem.addCell(_view, _listener, tableRow, row);
        }
      });
    });
    return fragment;
  }

  DocumentFragment _noRows() {
    var tableCell = new TableCellElement();
    tableCell.colSpan = _view.bindings.length;
    tableCell.appendText('Ingen data fundet');
    tableCell.classes.add('center');
    var result = new DocumentFragment();
    result.append(new TableRowElement().append(tableCell));
    return result;
  }

  void _doSort() {
    var body = (htmlElement as TableElement).tBodies.first;
    if (body == null) { // nothing to sort
      return;
    }
    var idx = (htmlElement as TableElement).tHead.rows.first.cells.indexOf(_orderBy);
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
    if (_orderBy != null && _orderBy.attributes['data-property'] == target.attributes['data-property']) {
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