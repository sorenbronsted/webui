
part of webui;

class DefaultDetailView extends View {
  String _name;
  UiForm _form;
  final Logger log = new Logger('DefaultDetailView');

  String get name => _name;

  DefaultDetailView(String name, [String bindId = '#content']) : super(bindId, '${name}Detail') {
    _name = name;
  }

  @override
  void bind(DivElement dom) {
    FormElement form = dom.querySelector('form[data-class]');
    if (form == null) {
      throw 'Form in ${viewName} not found';
    }
    _form = new UiForm(this, form);

    try {
      bindButton('save', true);
      bindButton('cancel', false);
    }
    catch(e) {
      log.info("Default save or cancel button not found");
    }
  }

  @override
  bool get isValid {
    return _form.isValid();
  }
}