part of webui;

class Th extends ElementWrapper {

  String get link => _htmlElement.attributes['data-link'];

  String get linkClass => _htmlElement.attributes['data-link-class'];

  Th(View view, TableCellElement th, [String cls]) : super(view, th, cls);

  TableCellElement makeCell(Map row, UiTableListener listener, TableCss css) {
    TableCellElement cell = new TableCellElement();

    // inherit column hidden property
    cell.hidden = _htmlElement.hidden;

    if (link != null) {
      _addLink(row, listener, cell, css);
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
    return cell;
  }

  void _addLink(Map row, UiTableListener listener, TableCellElement cell, TableCss css) {
    int uid = row['uid'];
    AnchorElement a = new AnchorElement();
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
        break;
      case 'children':
        a.href = "/#list/${linkClass}?${cls}=${uid}";
        a.text = Format.display(type, row[property], format);
        break;
    }
    a.onClick.listen((event) {
      event.preventDefault();
      _view.fire(_view.eventClick, new ElementValue(cls, link, uid, a.href));
    });
    listener?.onTableCellLink(cell, a, cls, property, row);
    cell.append(a);
  }

  @override
  set value(Object object) {
    // Do nothing
  }
}