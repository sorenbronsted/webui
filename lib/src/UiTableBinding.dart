
part of webui;

class UiTableBinding extends UiBinding {
  List _rows;
  TableElement _table;
  String _linkPrefix;
  View _view;

  UiTableBinding(TableElement this._table, this._linkPrefix) {
    [_table, _linkPrefix].forEach((elem) {
      if (elem == null) {
        throw "IllegalArgument: argument must not null";
      }
    });
  }

  void bind(View view) {
    _view = view;
  }

  List read() => _rows;

  void write(List rows) {
    _rows = rows;
    var columns = _table.tHead.querySelectorAll('th');
    if (columns.length <= 0) {
      throw new Exception("Must have a thead element");
    }
    if (_table.tBodies.length > 1) {
      throw new Exception("Multiple bodies not supported");
    }
    var body = _table.tBodies.first;
    body.children.clear();

    var fragment;
    if (rows.isEmpty) {
      fragment = _noRows(columns);
    }
    else {
      fragment = _addRows(columns, rows);
    }
    body.append(fragment);
  }

  DocumentFragment _addRows(List columns, List rows) {
    var fragment = new DocumentFragment();
    var rowCount = 0;
    rows.forEach((Map row) {
      var tableRow = new TableRowElement();
      tableRow.classes.add(rowCount % 2 == 0 ? "row-even" : "row-odd");
      columns.forEach((TableCellElement column) {
        var tableCell = _makeCell(column, row);
        tableRow.append(tableCell);
      });
      fragment.append(tableRow);
      rowCount++;
    });
    return fragment;
  }

  TableCellElement _makeCell(TableCellElement column, Map row) {
    var result = new TableCellElement();
    var href = "";
    if (_linkPrefix != null) {
      href = "/#${_linkPrefix}/${row['uid']}";
    }

    Map labels = {'edit' : 'E', 'delete' : 'X', 'children' : 'se'};
    var interSect = column.classes.intersection(new Set.from(labels.keys));
    if (interSect.length == 0) {
      var value = Format.display(column.classes, "${row[column.id]}");
      result.appendHtml(value);
    }
    else {
      var elem = interSect.first;
      if (elem == 'children') {
        href += "/${column.id}";
      }

      AnchorElement a = new AnchorElement();
      a.classes.add(elem);
      a.href = href;
      a.text = (row[column.id] == null ? labels[elem] : row[column.id]);
      a.onClick.listen((event) {
        event.preventDefault();
        AnchorElement a = event.target;
        _view.executeHandler(elem, false, a.href);
      });
      result.append(a);
    }
    return result;
  }

  DocumentFragment _noRows(List columns) {
    var tableCell = new TableCellElement();
    tableCell.colSpan = columns.length;
    tableCell.appendText('Ingen data fundet');
    var result = new DocumentFragment();
    result.append(new TableRowElement().append(tableCell));
    return result;
  }
}
