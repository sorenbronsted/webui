part of webui;

abstract class UiTableListener {
  onTableRow(TableRowElement tableRow, DataClass row);
  onTableCellValue(TableCellElement cell, String cls, String property, DataClass row);
  onTableCellLink(TableCellElement cell, AnchorElement link, String cls, String property, DataClass row);
}

class Table extends ContainerWrapper {
  static const none = 0;
  static const asc = 1;
  static const dsc = 2;

  static TableCss _css = new TableCss();

  UiTableListener _listener;
  TableCellElement _orderBy;
  int _direction = none;

  set listener(UiTableListener listener) => _listener = listener;

  static set css(TableCss css) => _css = css;

  Table(View view, TableElement table) : super(view, table) {
    if (table.tHead == null || table.tHead.children.length != 1) {
      throw new Exception("Must have a thead element"); //TODO make table header dynamic
    }
    if (table.tBodies.length > 1) {
      throw new Exception("Multiple bodies not supported");
    }

    table.tHead.querySelectorAll('[data-property]').forEach((Element element) {
      ElementWrapper ew = ElementFactory.make(view, element, _cls);
      _elements.add(ew);
      if (ew is Th && ew._htmlElement.classes.contains('sortable')) {
        ew._htmlElement.onClick.listen((event) {
          event.preventDefault();
          _setSortingUi(event.target);
          _doSort();
        });
      }
    });
  }

  @override
  void populate(Type type, Object value) {
    if (_cls != type.toString()) {
      return;
    }

    if (value is! Iterable) {
      return;
    }
    Iterable<DataClass> rows = value;

    var body = (_htmlElement as TableElement).tBodies.first;
    body.children.clear();

    var fragment;
    if (rows.isEmpty) {
      fragment = _noRows();
    }
    else {
      fragment = _addRows(rows);
    }
    body.append(fragment);
  }

  DocumentFragment _addRows(Iterable<DataClass> rows) {
    var fragment = new DocumentFragment();
    rows.forEach((row) {
      var tableRow = new TableRowElement();
      _listener?.onTableRow(tableRow, row);

      // Make the table row
      fragment.append(tableRow);
      _elements.forEach((ElementWrapper element) {
        TableCellElement td = (element as Th).makeCell(row, _listener, _css);
        tableRow.append(td);
      });
    });
    return fragment;
  }

  DocumentFragment _noRows() {
    var tableCell = new TableCellElement();
    tableCell.colSpan = _elements.length;
    tableCell.appendText('Ingen data fundet');
    tableCell.classes.add('center');
    var result = new DocumentFragment();
    result.append(new TableRowElement().append(tableCell));
    return result;
  }

  void _doSort() {
    var body = (_htmlElement as TableElement).tBodies.first;
    if (body == null) { // nothing to sort
      return;
    }
    var idx = (_htmlElement as TableElement).tHead.rows.first.cells.indexOf(_orderBy);
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