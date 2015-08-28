
part of webui;

class DefaultDetailView extends View {
  UiFormBinding _form;
  UiButtonBinding _save;
  UiButtonBinding _cancel;
  String _name;

  DefaultDetailView([String bindId = '#content']) : super(bindId);
  
  set name(String name) => _name = name;
  String get viewName => "${_name}Detail";

  Map get formdata => _form.read();
  set formdata(Map data) => _form.write(data);

  UiFormBinding get form => _form;

  onLoad() {
    var save = querySelector('button[name="save"]');
    save.onClick.listen((event) => _form.validate());
    _save = new UiButtonBinding(this, save, true);

    var cancel = querySelector('button[name="cancel"]');
    _cancel = new UiButtonBinding(this, cancel, false);

    var form = querySelector('form[name="formdata"]');
    _form = new UiFormBinding(this, form);
  }
}