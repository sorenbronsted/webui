part of webui;

class UiTh extends UiElement {

  String get link => htmlElement.attributes['data-link'];

  String get linkClass => htmlElement.attributes['data-link-class'];

  UiTh(TableCellElement th, [String cls]) : super(th, cls);

  void addCell(ViewElement view, UiTableListener listener, TableRowElement tableRow, Map row, UiTableCss css) {
    TableCellElement cell = new TableCellElement();

    // inherit column hidden property
    cell.hidden = htmlElement.hidden;

    if (link != null) {
      _addLink(view, row, listener, cell, css);
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

  void _addLink(ViewElement view, Map row, UiTableListener listener, TableCellElement cell, UiTableCss css) {
    String uid = row['uid'];
    AnchorElement a = new AnchorElement();
    String name = ViewElementEvent.Link;
    switch(link) {
      case 'edit':
        a.href = "/#detail/${cls}/${uid}";
        if (property == 'uid') {
          css.onEditLinkLabels(a);
        }
        else {
          a.text = row[property];
        }
        break;
      case 'delete':
        a.href = "/#detail/${cls}/${uid}";
        if (property == 'uid') {
          css.onDeleteLinkLabels(a);
        }
        else {
          a.text = row[property];
        }
        name = ViewElementEvent.Delete;
        break;
      case 'children':
        a.href = "/#list/${linkClass}?${cls}=${uid}";
        a.text = Format.display(type, row[property], format);
        break;
    }
    a.onClick.listen((event) {
      view.handleEvent(name, false, event);
    });
    listener?.onTableCellLink(cell, a, cls, property, row);
    cell.append(a);
  }

  @override
  void showError(Map fieldsWithError) {
    // Do nothing
  }
}