
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

  onLoad() {
    var form = querySelector('form[name="formdata"]');
    if (form == null) {
      throw "Form not found";
    }
    _form = addBinding(new UiFormBinding(form));

    var save = querySelector('button[name="save"]');
    if (save != null) {
      addBinding(new UiButtonBinding(save, true));
    }

    var cancel = querySelector('button[name="cancel"]');
    if (cancel != null) {
      addBinding(new UiButtonBinding(cancel, false));
    }
  }
}