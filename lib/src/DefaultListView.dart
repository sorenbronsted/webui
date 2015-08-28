
part of webui;

class DefaultListView extends View {
  UiButtonBinding _create;
  UiTableBinding _table;
  String _name;
  
  DefaultListView([String bindId = '#content']) : super(bindId);

  String get viewName  => "${_name}List";
  set name(String name) => _name = name;

  void onLoad() {
    var table = querySelector("#list table");
    _table = new UiTableBinding(this, table, _name);

    var button = querySelector('button[name="create"]');
    _create = new UiButtonBinding(this, button, false);
  }

  populate(List rows) {
    _table.write(rows);
  }
}
