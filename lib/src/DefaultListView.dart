
part of webui;

class DefaultListView extends View {
  UiTableBinding _table;
  String _name;
  
  DefaultListView([String bindId = '#content']) : super(bindId);

  String get viewName  => "${_name}List";
  set name(String name) => _name = name;

  void onLoad() {
    try {
      _table = addBinding(new UiTableBinding("#tabledata", _name));
      addBinding(new UiButtonBinding('button[name="create"]', false));
    }
    on SelectException catch(e) {
      print("Warning: ${e}");
    }
  }

  populate(List rows) {
    _table.write(rows);
  }
}
