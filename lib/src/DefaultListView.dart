
part of webui;

class DefaultListView extends View {
  UiTableBinding _table;
  String _name;
  
  DefaultListView([String bindId = '#content']) : super(bindId);

  String get viewName  => "${_name}List";
  set name(String name) => _name = name;

  void onLoad() {
    var table = querySelector("#tabledata");
    if (table == null) {
      throw "Table with id 'tabledata' is not found in ${viewName}";
    }
    _table = addBinding(new UiTableBinding(table, _name));

    var button = querySelector('button[name="create"]');
    if (button != null) {
      addBinding(new UiButtonBinding(button, false));
    }
  }

  populate(List rows) {
    _table.write(rows);
  }
}
