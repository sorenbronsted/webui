
part of webui;

class DefaultDetailView extends View {
  String _name;
  UiForm _form;

  String get name => _name;

  DefaultDetailView(String name, [String bindId = '#content']) : super(bindId, '${name}Detail') {
    _name = name;
  }
  
  void bind(ObjectStore store) {
    _form = document.querySelector('#${_name}Form');
    if (_form == null) {
      throw '#${_name}Form not found';
    }
    _form.bind(store, this);

    try {
      bindButton('save', true);
      bindButton('cancel', false);
    }
    catch(e) {
      print("Default save or cancel button not found");
    }
  }

  @override
  bool get isValid {
    return _form.isValid();
  }
}