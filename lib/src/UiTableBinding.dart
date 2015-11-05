
part of webui;

abstract class UiTableListener {
  onTableRow(TableRowElement tableRow, Map row);
  onTableCellValue(TableCellElement cell, String column, Map row);
  onTableCellLink(TableCellElement cell, AnchorElement link, String column, Map row);
}

class UiTableBinding extends UiBinding {
  List _rows;
  TableElement _table;
  String _selector;
  String _className;
  View _view;
  UiTableListener _listener;

  UiTableBinding(String this._selector, this._className, this._listener) {
    [_selector, _className].forEach((elem) {
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

    Map labels = {'edit' : 'E', 'delete' : 'X', 'children' : 'se'};
    var interSect = column.classes.intersection(new Set.from(labels.keys));
    if (interSect.length == 0) {
      var value = Format.display(column.classes, "${row[column.id]}");
      tableCell.appendHtml(value);
      _listener.onTableCellValue(tableCell, column.id, row);
    }
    else {
      var action = interSect.first;
      var href = "";
      switch(action) {
        case 'edit':
          href = "/#detail/${_className}/${row['uid']}";
          break;
        case 'delete':
          href = "/#${_className}/${row['uid']}";
          break;
        case 'children':
          href = "/#list/${column.id}?${_className}=${row['uid']}";
          break;
      }

      AnchorElement a = new AnchorElement();
      a.classes.add(action);
      a.href = href;
      a.text = '${(row[column.id] == null ? labels[action] : row[column.id])}';
      a.onClick.listen((event) {
        event.preventDefault();
        _view.executeHandler(action, false, a.href);
      });
      _listener.onTableCellLink(tableCell, a,column.id, row);
      tableCell.append(a);
    }
    return tableCell;
  }

  DocumentFragment _noRows(List columns) {
    var tableCell = new TableCellElement();
    tableCell.colSpan = columns.length;
    tableCell.appendText('Ingen data fundet');
    _listener.onTableCellValue(tableCell, null, null);
    var result = new DocumentFragment();
    result.append(new TableRowElement().append(tableCell));
    return result;
  }
}
