
part of webui;

class DefaultDetailView extends View {
  String _name;

  String get name => _name;

  DefaultDetailView(String name, [String bindId = '#content']) : super(bindId, '${name}Detail') {
    _name = name;
  }
  
  void bind(ObjectStore store) {
    UiForm form = document.querySelector('#${_name}Form');
    if (form == null) {
      throw '#${_name}Form not found';
    }
    form.bind(store, this);

    ButtonElement save = document.querySelector('#save');
    if (save != null) {
      save.onClick.listen((event) {
        event.preventDefault();
        executeHandler('save', true);
      });
    }
    else {
      print("Default save button not found");
    }

    ButtonElement cancel = document.querySelector('#cancel');
    if (cancel != null) {
      cancel.onClick.listen((event) {
        event.preventDefault();
        executeHandler('cancel', false);
      });
    }
    else {
      print("Default cancel button not found");
    }
  }
}