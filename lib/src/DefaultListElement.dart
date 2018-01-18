
part of webui;

class DefaultListElement extends ViewElement implements UiTableListener {

  UiTable get table => _elements.where((UiElement elem) => elem is UiTable).first;
  set rows(Iterable<Map> rows) => table.rows = rows;
  String get dataClass => table.cls;

  DefaultListElement(String name, [String bindId = '#content']) : super(bindId, '${name}List');

  void bind(ViewElement view) {
    super.bind(view);
    if (_elements.where((UiElement elem) => (elem is UiTable)).length > 1) {
      throw "This view only support one table element";
    }

    try {
      bindButton(ViewElementEvent.Create, false);
    }
    catch(e) {
      log.info(e);
    }
  }

  @override
  onTableCellLink(TableCellElement cell, AnchorElement link, String cls, String property, Map row) {}

  @override
  onTableCellValue(TableCellElement cell, String cls, String property, Map row) {}

  @override
  onTableRow(TableRowElement tableRow, Map row) {}
}
