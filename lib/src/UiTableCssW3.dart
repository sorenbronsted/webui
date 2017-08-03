
part of webui;

class UiTableCssW3 implements UiTableCss {
  @override
  onSortColumn(TableCellElement th, int direction) {
    var span;
    if (th.children.isEmpty) {
      span = new SpanElement();
      th.append(span);
    }
    else {
      span = th.children.last;
    }

    span.classes.clear();
    span.classes.add('material-icons');
    if (direction == UiTable.asc) {
      span.add("arrow drop down");
    }
    else if (direction == UiTable.dsc) {
      span.add("arrow drop up");
    }
  }

  @override
  void clearSortColumn(TableCellElement orderBy) {
    orderBy.children.removeLast();
  }

  @override
  void onDeleteLinkLabels(AnchorElement a) {
    var span = new SpanElement();
    span.classes.add('material-icons');
    span.appendText('delete');
    a.append(span);
  }

  @override
  void onEditLinkLabels(AnchorElement a) {
    var span = new SpanElement();
    span.classes.add('material-icons');
    span.appendText('create');
    a.append(span);
  }
}
