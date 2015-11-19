
part of webui;

class UiFormModel {
  static const String defaultClass = '_empty_';
  Map<String, Map> _data = {defaultClass : {}};

  Map get data => _data;

  bool get hasClasses => !(_data.keys.length == 1 && _data.keys.first == defaultClass);

  void clear() {
    _data.keys.forEach((String key) => _data[key].clear());
  }

  void add(String name) {
    _data[name] = {};
  }

  void set(String name, Map data) {
    _data[name] = data;
  }

  Map get(String name) {
    return _data[name];
  }

  Map getDefault() {
    return _data[defaultClass];
  }
}

class UiFormBinding extends UiBinding {
  UiFormModel _model;
  FormElement _form;
  Map<String, UiBinding> _bindings;
  String _selector;
  Set _classes;

  UiFormBinding(String this._selector) {
    _model = new UiFormModel();
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
        if (elem.id == null) {
          throw "Id attribute must not be null";
        }
        var input = new UiInputBinding.byElement(elem);
        _bindings[elem.id] = input;
      });
      _form.querySelectorAll('select').forEach((elem) {
        if (elem.id == null) {
          throw "Id attribute must not be null";
        }
        var select = new UiSelectBinding.byElement(elem);
        _bindings[elem.id] = select;
      });
    }
    _bindings.values.forEach((UiBinding binding) => binding.bind(view));
    // Collect classes used in form
    _bindings.keys.forEach((name) {
      var parts = name.split('-');
      if (parts.isNotEmpty) {
        _model.add(parts[0]);
      }
    });
  }

  UiBinding operator [](String name) => _bindings[name];

  Map read() {
    _bindings.forEach((name, elem) {
      var parts = name.split('-');
      if (parts.isNotEmpty) {
        _model.get(parts[0])[parts[1]] = elem.read();
      }
      else {
        _model.get(UiFormModel.defaultClass)[name] = elem.read();
      }
    });
    if (_model.hasClasses) {
      return _model.data;
    }
    return _model.getDefault();
  }

  void write(Map data) {
    var clz = data['class'];
    if (clz == null) {
      clz = UiFormModel.defaultClass;
    }
    _model.set(clz, data);
    _model.get(clz).forEach((name, value) {
      var binding = null;
      if (clz != null) {
        binding = _bindings["${clz}-${name}"];
      }
      if (binding == null) {
        binding = _bindings[name];
      }
      if (binding != null) {
        binding.write(value);
      }
    });
  }
}

