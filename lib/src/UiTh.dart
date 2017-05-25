part of webui;

class UiTh extends UiElement {

  String get link => htmlElement.attributes['data-link'];

  UiTh(TableCellElement th, [String cls]) : super(th, cls);

  void addCell(View view, UiTableListener listener, TableRowElement tableRow, Map row) {
    TableCellElement cell = new TableCellElement();

    // inherit column hidden property
    cell.hidden = htmlElement.hidden;

    if (link != null) {
      _addLink(row, view, listener, cell);
    }
    else {
      var value = null;
      if (row.keys.contains(property)) {
        value = row[property];
      }
      value = Format.display(type, value, format);
      cell.appendHtml(value);
      listener?.onTableCellValue(cell, cls, property, row);
    }
    tableRow.append(cell);
  }

  void _addLink(Map row, View view, UiTableListener listener, TableCellElement cell) {
    Map labels = {'edit' : 'E', 'delete' : 'X', 'children' : 'se'};
    String href = null;
    String uid = row['uid'];
    String value = Format.display(type, row[property], format);
    String text = property == 'uid' ? labels[link] : value;
    switch(link) {
      case 'edit':
        href = "/#detail/${cls}/${uid}";
        break;
      case 'delete':
        href = "/#${cls}/${uid}";
        text = property == 'uid' ? labels[link] : value;
        break;
      case 'children':
        href = "/#list/${property}?${cls}=${uid}";
        text = labels[link];
        break;
    }
    AnchorElement a = new AnchorElement();
    a.href = href;
    a.text = '${text}';
    a.onClick.listen((event) {
      event.preventDefault();
      view.executeHandler(link, false, a.href);
    });
    listener?.onTableCellLink(cell, a, cls, property, row);
    cell.append(a);
  }

  @override
  void update() {
    // TODO: implement update
  }
}