
part of webui;

class UiFormBinding extends UiBinding {
  Map _data = {};
  FormElement _form;
  Map<String, UiBinding> _bindings;
  String _selector;

  UiFormBinding(String this._selector) {
    _data.clear();
    _bindings = {};
  }

  void bind(View view) {
    _form = querySelector(_selector);
    if (_form == null) {
      throw new SelectException("Form not found (selector $_selector)");
    }
    _form.onSubmit.listen((event) {
      event.preventDefault();
      view.executeHandler("save", true);
    });

    if (_bindings.isEmpty) {
      _form.querySelectorAll('input, textarea').forEach((elem) {
        if (elem.name == null) {
          throw "Name attribute must not be null";
        }
        var input = new UiInputBinding.byElement(elem);
        _bindings[elem.name] = input;
      });
      _form.querySelectorAll('select').forEach((elem) {
        if (elem.name == null) {
          throw "Name attribute must not be null";
        }
        var select = new UiSelectBinding.byElement(elem);
        _bindings[elem.name] = select;
      });
    }
    _bindings.values.forEach((UiBinding binding) => binding.bind(view));
  }

  UiBinding operator [](String name) => _bindings[name];

  Map read() {
    _bindings.forEach((name, elem) => _data[name] = elem.read());
    return new Map.from(_data);
  }

  void write(Map data) {
    if (data['class'] == null) {
      throw "Must have key: class";
    }
    var clz = data['class'];
    data.forEach((k, v) => this._data['${clz}-${k}'] = v);
    _data.forEach((name, value) {
      var binding = _bindings[name];
      if (binding != null) {
        binding.write(value);
      }
    });
  }
}

