
part of webui;

class UiInputBinding extends UiBinding {
  View _view;
  InputElement _input;

  UiInputBinding(View this._view, InputElement this._input) {

    if (!(this._input is InputElement || this._input is TextAreaElement)) {
      throw "Only works on input and textarea elements";
    }

    _input.onFocus.listen((event) {
      UiInputValidator.reset(_input);
      _view.isValid = true;
    });

    _input.onBlur.listen((event) {
      validate();
    });

    _input.onKeyUp.listen((event) => _view.isDirty = true);
  }

  String read() {
    return Format.internal(_input.classes, _input.value);
  }

  void write(String value) {
    _input.value = Format.display(_input.classes, value);
  }

  void validate() {
    UiInputValidator.validate(_input);
    _view.isValid = _input.classes.contains('valid');
  }
}
