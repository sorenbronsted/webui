
part of webui;

class TableCssW3 implements TableCss {
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
    if (direction == Table.asc) {
      span.add("arrow drop down");
    }
    else if (direction == Table.dsc) {
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
