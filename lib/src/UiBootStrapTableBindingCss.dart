
part of webui;

class UiBootStrapTableBindingCss implements UiTableBindingCss {
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
    if (direction == UiTableBinding.asc) {
      span.classes.add("glyphicon-triangle-top");
    }
    else if (direction == UiTableBinding.dsc) {
      span.classes.add("glyphicon-triangle-bottom");
    }
  }

  @override
  void clearSortColumn(TableCellElement orderBy) {
    orderBy.children.removeLast();
  }
}
