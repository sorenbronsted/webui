
part of webui;

class DefaultListView extends View implements UiTableListener {
  String _name;
  final Logger log = new Logger('DefaultListView');

  DefaultListView(String name, [String bindId = '#content']) : super(bindId, '${name}List') {
    _name = name;
  }

  String get name => _name;

  void bind(DivElement dom) {
    TableElement table = dom.querySelector('table');
    if (table == null) {
      throw 'Table in view ${viewName} not found';
    }
    addBinding(new UiTable(this, table));

    try {
      bindButton('create', false);
    }
    catch(e) {
      log.info("Default create button not found");
    }
  }

  @override
  onTableCellLink(TableCellElement cell, AnchorElement link, String cls, String property, Map row) {}

  @override
  onTableCellValue(TableCellElement cell, String cls, String property, Map row) {}

  @override
  onTableRow(TableRowElement tableRow, Map row) {}

  // TODO: implement isValid
  @override
  bool get isValid => true;
}
