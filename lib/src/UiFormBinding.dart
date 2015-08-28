
part of webui;

class UiFormBinding extends UiBinding {
  Map _data = {};
  FormElement _form;
  Map<String, UiBinding> _bindings;

  UiFormBinding(FormElement this._form) {
    if (_form == null) {
      throw "IllegalArgument: form must not be null";
    }
    _data.clear();
    _bindings = {};
  }

  void bind(View view) {
    _form.querySelectorAll('input[type="text"], input[type="checkbox"], textarea').forEach((elem) {
      if (elem.name == null) {
        throw "Name attribute must not be null";
      }
      var input = new UiInputBinding(elem);
      input.bind(view);
      _bindings[elem.name] = input;
    });
    _form.querySelectorAll('select').forEach((elem) {
      if (elem.name == null) {
        throw "Name attribute must not be null";
      }
      var select = new UiSelectBinding(elem);
      select.bind(view);
      _bindings[elem.name] = select;
    });
    _form.onSubmit.listen((event) {
      event.preventDefault();
      view.executeHandler("save", true);
    });
  }

  UiBinding operator [](String name) => _bindings[name];

  Map read() {
    _bindings.forEach((name, elem) => _data[name] = elem.read());
    return _data;
  }

  void write(Map data) {
    this._data = data;
    _data.forEach((name, value) {
      var binding = _bindings[name];
      if (binding != null) {
        binding.write(value);
      }
    });
  }
}

