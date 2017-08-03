
part of webui;

class UiTableCssBootStrap implements UiTableCss {
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
    span.classes.add("glyphicon");
    if (direction == UiTable.asc) {
      span.classes.add("glyphicon-triangle-top");
    }
    else if (direction == UiTable.dsc) {
      span.classes.add("glyphicon-triangle-bottom");
    }
  }

  @override
  void clearSortColumn(TableCellElement orderBy) {
    orderBy.children.removeLast();
  }

  @override
  void onDeleteLinkLabels(AnchorElement a) {
    var span = new SpanElement();
    span.classes.add('glyphicon');
    span.classes.add('glyphicon-remove');
    a.append(span);
  }

  @override
  void onEditLinkLabels(AnchorElement a) {
    var span = new SpanElement();
    span.classes.add('glyphicon');
    span.classes.add('glyphicon-edit');
    a.append(span);
  }
}
