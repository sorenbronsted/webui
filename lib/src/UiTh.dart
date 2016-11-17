part of webui;

class UiTh extends TableCellElement with UiBind {
  static const String uiTagName = 'x-th';
  String _type;
  String _link;
  String _format;

  UiTh.created() : super.created() {
    setBind(getAttribute('bind'));
    _type = attributes['type'];
    _link = attributes['link'];
    _format = attributes['format'];
  }

  void addCell(View view, UiTableListener listener, TableRowElement tableRow, Map row) {
    TableCellElement cell = new TableCellElement();

    // inherit column hidden property
    cell.hidden = hidden;

    if (_link != null) {
      _addLink(row, view, listener, cell);
    }
    else {
      var value = null;
      if (row.keys.contains(_property)) {
        value = row[_property];
      }
      value = Format.display(_type, value, _format);
      cell.appendHtml(value);
      listener?.onTableCellValue(cell, _cls, _property, row);
    }
    tableRow.append(cell);
  }

  void _addLink(Map row, View view, UiTableListener listener, TableCellElement cell) {
    Map labels = {'edit' : 'E', 'delete' : 'X', 'children' : 'se'};
    String href = null;
    String uid = row['uid'];
    String value = Format.display(_type, row[_property], _format);
    String text = _property == 'uid' ? labels[_link] : value;
    switch(_link) {
      case 'edit':
        href = "/#detail/${_cls}/${uid}";
        break;
      case 'delete':
        href = "/#${_cls}/${uid}";
        text = _property == 'uid' ? labels[_link] : value;
        break;
      case 'children':
        href = "/#list/${_property}?${_cls}=${uid}";
        text = labels[_link];
        break;
    }
    AnchorElement a = new AnchorElement();
    a.href = href;
    a.text = '${text}';
    a.onClick.listen((event) {
      event.preventDefault();
      view.executeHandler(_link, false, a.href);
    });
    listener?.onTableCellLink(cell, a, _cls, _property, row);
    cell.append(a);
  }
}