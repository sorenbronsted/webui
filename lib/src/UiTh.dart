part of webui;

class UiTh extends TableCellElement {
  static const String uiTagName = 'x-th';
  String _type;
  String _link;
  String _bindClass;
  String _bindProperty;
  String _decimals;
  String _sortable;

  UiTh.created() : super.created() {
    _type = attributes['type'];
    _link = attributes['link'];
    _decimals = attributes['decimals'];
    _sortable = attributes['sortable'];

    var parts = attributes['name'].split('.');
    if (parts.length != 2) {
      throw "Wrong format for name. Must be class.property";
    }
    _bindClass = parts[0];
    _bindProperty = parts[1];
    //TODO validate required attributes
  }


  void addCell(UiTableListener listener, TableRowElement tableRow, Map row) {
    TableCellElement cell = new TableCellElement();

    // inherit column hidden property
    cell.hidden = hidden;

    Map labels = {'edit' : 'E', 'delete' : 'X', 'children' : 'se'};
    if (_link != null) {
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
        (listener as View).executeHandler(_link, false, a.href);
      });
      listener.onTableCellLink(href, a, _bindClass, _bindProperty, row);
      cell.append(a);
    }
    else {
      var value = Format.display(_type, row[_bindClass][_bindProperty]);
      cell.appendHtml(value);
      listener.onTableCellValue(cell, _bindClass, _bindProperty, row);
    }
    tableRow.append(cell);
  }
}