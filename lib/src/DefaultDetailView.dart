
part of webui;

class DefaultDetailView extends View {
  UiFormBinding _form;
  String _name;

  DefaultDetailView([String bindId = '#content']) : super(bindId);
  
  set name(String name) => _name = name;
  String get viewName => "${_name}Detail";

  Map get formdata => _form.read();
  set formdata(Map data) => _form.write(data);

  UiFormBinding get form => _form;

  void registerBindings() {
    _form = addBinding(new UiFormBinding('form[name="formdata"]'));
    addBinding(new UiButtonBinding('button[name="save"]', true));
    addBinding(new UiButtonBinding('button[name="cancel"]', false));
}
}