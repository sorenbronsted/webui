
part of webui;

class UiInputBinding extends UiBinding {
  InputElement _input;
  String _selector;

  UiInputBinding(String this._selector);

  UiInputBinding.byElement(InputElement this._input) {
    _selector = '[name="${_input.name}"]';
  }

  void bind(View view) {
    _input = querySelector(this._selector);
    if (_input == null) {
      throw "Element not found (selector $_selector";
    }
    if (!(this._input is InputElement || this._input is TextAreaElement)) {
      throw "Only works on input and textarea elements";
    }
    _input.onFocus.listen((event) {
      UiInputValidator.reset(_input);
      view.isValid = true;
    });

    _input.onBlur.listen((event) {
      UiInputValidator.validate(_input);
      view.isValid = _input.classes.contains('valid');
    });

    _input.onKeyUp.listen((event) => view.isDirty = true);
  }

  String read() {
    return Format.internal(_input.classes, _input.value);
  }

  void write(String value) {
    _input.value = Format.display(_input.classes, value);
  }
}
