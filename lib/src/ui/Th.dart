part of webui;

class Th extends ElementWrapper {

  String get link => _htmlElement.attributes['data-link'];
  String get linkClass => _htmlElement.attributes['data-link-class'];
  String get linkDisplay => _htmlElement.attributes['data-link-display'];

  Th(View view, TableCellElement th, [String cls]) : super(view, th, cls);

  TableCellElement makeCell(DataClass row, TableCss css) {
    TableCellElement cell = new TableCellElement();

    // inherit column hidden property
    cell.hidden = _htmlElement.hidden;

    if (link != null) {
      _addLink(row, cell, css);
    }
    else {
      var value = null;
      if (row.get(_property) != null) {
        value = row.get(_property);
      }
      value = Format.display(_type, value, _format);
      cell.appendHtml(value);
      if (_view is TableListener) {
        (_view as TableListener).onTableCellValue(cell, _cls, _property, row);
      }
    }
    return cell;
  }

  void _addLink(DataClass row, TableCellElement cell, TableCss css) {
    int uid = row.uid;
    AnchorElement a = new AnchorElement();
    switch(link) {
      case 'edit':
        a.href = "/#detail/${_cls}/${uid}";
        if (_property == 'uid') {
          css.onEditLinkLabels(a);
        }
        else {
          a.text = Format.display(_type, row.get(_property), _format);
        }
        a.onClick.listen((event) {
          event.preventDefault();
          _view.fire(link, new ElementValue(_cls, _property, uid, a.href));
        });
        break;
      case 'delete':
        a.href = "/#detail/${_cls}/${uid}";
        if (_property == 'uid') {
          css.onDeleteLinkLabels(a);
        }
        else {
          a.text = Format.display(_type, row.get(_property), _format);
        }
        a.onClick.listen((event) {
          event.preventDefault();
          _view.fire(link, new ElementValue(_cls, _property, uid, a.href));
        });
        break;
      case 'children':
        a.href = "/#list/${linkClass}?${_property}=${uid}";
        a.text = Format.display(_type, linkDisplay, _format);
        a.onClick.listen((event) {
          event.preventDefault();
          _view.fire(link, new ElementValue(linkClass, _property, uid, a.href));
        });
        break;
    }
    if (_view is TableListener) {
      (_view as TableListener).onTableCellLink(cell, a, _cls, _property, row);
    }
    cell.append(a);
  }

  @override
  void populate(Type sender, Object object) {
    // Do nothing
  }
}