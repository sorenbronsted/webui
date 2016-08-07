part of webui;

class UiTh extends TableCellElement {
  static const String uiTagName = 'x-th';
  String _type;
  String _link;
  String _bindClass;
  String _bindProperty;
  String _format;

  UiTh.created() : super.created() {
    _type = attributes['type'];
    _link = attributes['link'];
    _format = attributes['format'];

    var parts = attributes['name'].split('.');
    if (parts.length != 2 && _link != null) {
      throw "Wrong format for name for type link. Must be class.property";
    }
    if (parts.length == 2) {
      _bindClass = parts[0];
      _bindProperty = parts[1];
    }
    else {
      _bindProperty = attributes['name'];
    }
  }


  void addCell(View view, UiTableListener listener, TableRowElement tableRow, Map row) {
    TableCellElement cell = new TableCellElement();

    // inherit column hidden property
    cell.hidden = hidden;

    if (_link != null) {
      _addLink(row, view, listener, cell);
    }
    else {
      var value = (_bindClass != null ? row[_bindClass][_bindProperty] : row[_bindProperty]);
      value = Format.display(_type, value, _format);
      cell.appendHtml(value);
      listener?.onTableCellValue(cell, _bindClass, _bindProperty, row);
    }
    tableRow.append(cell);
  }

  void _addLink(Map row, View view, UiTableListener listener, TableCellElement cell) {
    Map labels = {'edit' : 'E', 'delete' : 'X', 'children' : 'se'};
    var href = null;
    var uid = row[_bindClass]['uid'];
    var value = row[_bindClass][_bindProperty];
    var text = _bindProperty == 'uid' ? labels[_link] : value;
    switch(_link) {
      case 'edit':
        href = "/#detail/${_bindClass}/${uid}";
        break;
      case 'delete':
        href = "/#${_bindClass}/${uid}";
        text = _bindProperty == 'uid' ? labels[_link] : value;
        break;
      case 'children':
        href = "/#list/${_bindProperty}?${_bindClass}=${uid}";
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
    listener?.onTableCellLink(href, a, _bindClass, _bindProperty, row);
    cell.append(a);
  }
}