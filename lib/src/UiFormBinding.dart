
part of webui;

class UiFormBinding extends UiBinding {
  View _view;
  FormElement _form;
  Map _data = {};
  Map _bindings = {};

  UiFormBinding(View this._view, FormElement this._form) {
    if (_form == null) {
      throw "IllegalArgument: form must not be null";
    }
    _bindings.clear();
    _data.clear();
    _form.querySelectorAll('input[type="text"], input[type="checkbox"], textarea').forEach((elem) {
      if (elem.name == null) {
        throw "Name attribute must not be null";
      }
      _bindings[elem.name] = new UiInputBinding(_view, elem);
    });
    _form.querySelectorAll('select').forEach((elem) {
      if (elem.name == null) {
        throw "Name attribute must not be null";
      }
      _bindings[elem.name] = new UiSelectBinding(_view, elem);
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

  validate() {
    _bindings.forEach((name, elem) => elem.validate());
  }
}

