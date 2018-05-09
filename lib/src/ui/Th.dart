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
      if (row.keys.contains(_property)) {
        value = row[_property];
      }
      value = Format.display(_type, value, _format);
      cell.appendHtml(value);
      listener?.onTableCellValue(cell, _cls, _property, row);
    }
    return cell;
  }

  void _addLink(Map row, UiTableListener listener, TableCellElement cell, TableCss css) {
    int uid = row['uid'];
    AnchorElement a = new AnchorElement();
    switch(link) {
      case 'edit':
        a.href = "/#detail/${_cls}/${uid}";
        if (_property == 'uid') {
          css.onEditLinkLabels(a);
        }
        else {
          a.text = Format.display(_type, row[_property], _format);
        }
        break;
      case 'delete':
        a.href = "/#detail/${_cls}/${uid}";
        if (_property == 'uid') {
          css.onDeleteLinkLabels(a);
        }
        else {
          a.text = Format.display(_type, row[_property], _format);
        }
        break;
      case 'children':
        a.href = "/#list/${linkClass}?${_cls}=${uid}";
        a.text = Format.display(_type, row[_property], _format);
        break;
    }
    a.onClick.listen((event) {
      event.preventDefault();
      _view.fire(link, new ElementValue(_cls, _property, uid, a.href));
    });
    listener?.onTableCellLink(cell, a, _cls, _property, row);
    cell.append(a);
  }

  @override
  void populate(Type type, Object object) {
    // Do nothing
  }
}