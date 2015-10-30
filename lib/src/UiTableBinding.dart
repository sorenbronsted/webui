
part of webui;

abstract class UiTableListener {
  onTableRow(TableRowElement tableRow, Map row);
  onTableCellValue(TableCellElement cell, String value);
  onTableCellLink(TableCellElement cell, AnchorElement link);
}

class UiTableBinding extends UiBinding {
  List _rows;
  TableElement _table;
  String _selector;
  String _linkPrefix;
  View _view;
  UiTableListener _listener;

  UiTableBinding(String this._selector, this._linkPrefix, this._listener) {
    [_selector, _linkPrefix].forEach((elem) {
      if (elem == null) {
        throw "IllegalArgument: argument must not null";
      }
    });
  }

  void bind(View view) {
    _table = querySelector(_selector);
    if (_table == null) {
      throw new SelectException("Table not found (selector: $_selector)");
    }
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
    rows.forEach((Map row) {
      var tableRow = new TableRowElement();
      _listener.onTableRow(tableRow, row);
      columns.forEach((TableCellElement column) {
        var tableCell = _makeCell(column, row);
        tableRow.append(tableCell);
      });
      fragment.append(tableRow);
    });
    return fragment;
  }

  TableCellElement _makeCell(TableCellElement column, Map row) {
    var tableCell = new TableCellElement();
    tableCell.hidden = column.hidden;

    var href = "";
    if (_linkPrefix != null) {
      href = "/#${_linkPrefix}/${row['uid']}";
    }

    Map labels = {'edit' : 'E', 'delete' : 'X', 'children' : 'se'};
    var interSect = column.classes.intersection(new Set.from(labels.keys));
    if (interSect.length == 0) {
      var value = Format.display(column.classes, "${row[column.id]}");
      _listener.onTableCellValue(tableCell, value);
      tableCell.appendHtml(value);
    }
    else {
      var elem = interSect.first;
      if (elem == 'children') {
        href += "/${column.id}";
      }

      AnchorElement a = new AnchorElement();
      a.classes.add(elem);
      a.href = href;
      a.text = '${(row[column.id] == null ? labels[elem] : row[column.id])}';
      a.onClick.listen((event) {
        event.preventDefault();
        _view.executeHandler(elem, false, a.href);
      });
      _listener.onTableCellLink(tableCell, a);
      tableCell.append(a);
    }
    return tableCell;
  }

  DocumentFragment _noRows(List columns) {
    var tableCell = new TableCellElement();
    tableCell.colSpan = columns.length;
    var value = 'Ingen data fundet';
    _listener.onTableCellValue(tableCell, value);
    tableCell.appendText(value);
    var result = new DocumentFragment();
    result.append(new TableRowElement().append(tableCell));
    return result;
  }
}
