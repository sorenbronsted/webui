
part of webui;

class UiInputBinding extends UiBinding {
  InputElement _input;
  String _selector;

  UiInputBinding(String this._selector);

  UiInputBinding.byElement(InputElement this._input) {
    _selector = '#${_input.id}';
  }

  void bind(View view) {
    _input = querySelector(this._selector);
    if (_input == null) {
      throw new SelectorException("Element not found (selector $_selector");
    }
    if (!(this._input is InputElement || this._input is TextAreaElement)) {
      throw "Only works on input and textarea elements";
    }
    _input.onFocus.listen((event) {
      UiInputValidator.reset(_input);
      view.isValid = true;
    });

    _input.onBlur.listen((event) {
      view.isValid = UiInputValidator.validate(_input);
    });

    _input.onKeyUp.listen((event) => view.isDirty = true);
  }

  String read() {
    if (_input.type.toLowerCase() == 'text') {
      return Format.internal(_input.classes, _input.value);
    }
    return _input.checked ? '1' : '0';
  }

  void write(String value) {
    if (_input.type.toLowerCase() == 'text') {
      _input.value = Format.display(_input.classes, value);
    }
    else {
      _input.checked = (value == '1' || value.toLowerCase() == 'true' ? true : false);
    }
  }
}
