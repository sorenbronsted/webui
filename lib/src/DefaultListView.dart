
part of webui;

class DefaultListView extends View implements UiTableListener {
  String _name;
  
  DefaultListView(String name, [String bindId = '#content']) : super(bindId, '${name}List') {
    _name = name;
  }

  String get name => _name;

  void bind(ObjectStore store) {
    UiTable table = document.querySelector('#${_name}Table');
    store.addListener('${_name}Table', table);
    table.listener = this;

    ButtonElement create = document.querySelector('#create');
    if (create != null) {
      create.onClick.listen((event) {
        event.preventDefault();
        executeHandler('create', false);
      });
    }
    else {
      print("Default create button not found");
    }
  }

  @override
  onTableCellLink(TableCellElement cell, AnchorElement link, String cls, String property, Map row) {}

  @override
  onTableCellValue(TableCellElement cell, String cls, String property, Map row) {}

  @override
  onTableRow(TableRowElement tableRow, Map row) {}
}
