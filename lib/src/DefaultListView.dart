
part of webui;

class DefaultListView extends View implements UiTableListener {
  UiTableBinding _table;
  String _name;
  
  DefaultListView([String bindId = '#content']) : super(bindId);

  String get viewName  => "${_name}List";

  String get name => _name;
  set name(String name) => _name = name;

  UiTableBinding get table => _table;

  void registerBindings() {
    _table = addBinding(new UiTableBinding("#tabledata", this));
    addBinding(new UiButtonBinding('button[name="create"]', false));
  }

  populate(List rows) {
    _table.write(rows);
  }

  @override
  onTableCellLink(TableCellElement cell, AnchorElement link, String column, Map row) {}

  @override
  onTableCellValue(TableCellElement cell, String column, Map row) {}

  @override
  onTableRow(TableRowElement tableRow, Map row) {}
}
