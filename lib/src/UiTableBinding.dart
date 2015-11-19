
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
  View _view;
  UiTableListener _listener;

  UiTableBinding(String this._selector, this._listener) {
    [_selector].forEach((elem) {
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
    rows.forEach((data) {
      // Rows can consist of a single Map or a list of Maps
      List maps = [];
      if (data is Map) {
        maps.add(data);
      }
      if (data is List) {
        maps = data;
      }

      // Make the table row
      var tableRow = new TableRowElement();
      maps.forEach((Map row) {
        if (row['class'] == null) {
          throw "Must have key: class";
        }
        _listener.onTableRow(tableRow, row);
        columns.forEach((TableCellElement column) {
          if (_clazz(column.id) != row['class']) {
            return;
          }
          var tableCell = _makeCell(column, row);
          tableRow.append(tableCell);
        });
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
      var value = Format.display(column.classes, "${row[_property(column.id)]}");
      tableCell.appendHtml(value);
      _listener.onTableCellValue(tableCell, column.id, row);
    }
    else {
      var action = interSect.first;
      var href = '';
      var text = '';
      switch(action) {
        case 'edit':
          href = "/#detail/${_clazz(column.id)}/${row['uid']}";
          text = _property(column.id) == 'uid' ? labels[action] : row[_property(column.id)];
          break;
        case 'delete':
          href = "/#${_clazz(column.id)}/${row['uid']}";
          text = _property(column.id) == 'uid' ? labels[action] : row[_property(column.id)];
          break;
        case 'children':
          href = "/#list/${_property(column.id)}?${_clazz(column.id)}=${row['uid']}";
          text = labels[action];
          break;
      }

      AnchorElement a = new AnchorElement();
      a.classes.add(action);
      a.href = href;
      a.text = '${text}';
      a.onClick.listen((event) {
        event.preventDefault();
        _view.executeHandler(action, false, a.href);
      });
      _listener.onTableCellLink(tableCell, a,column.id, row);
      tableCell.append(a);
    }
    return tableCell;
  }

  String _clazz(String id) {
    try {
      return id.split('-')[0];
    } on RangeError {
      return id;
    }
  }

  String _property(String id) {
    try {
      return id.split('-')[1];
    } on RangeError {
      return id;
    }
  }

  DocumentFragment _noRows(List columns) {
    var tableCell = new TableCellElement();
    tableCell.colSpan = columns.length;
    tableCell.appendText('Ingen data fundet');
    tableCell.classes.add('center');
    _listener.onTableCellValue(tableCell, null, {});
    var result = new DocumentFragment();
    result.append(new TableRowElement().append(tableCell));
    return result;
  }
}
