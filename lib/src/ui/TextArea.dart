part of webui;

class TextArea extends InputBase {

  TextArea(View view, TextAreaElement input, String cls) : super(view, input, cls) {
    _htmlElement.onChange.listen((Event e) {
      isDirty = true;
      isValid = validate();
      view.validateAndfire(view.eventPropertyChanged, true, elementValue);
    });

    _htmlElement.onFocus.listen((event) {
      InputValidator.reset(this);
      isValid = true;
    });

    _htmlElement.onKeyUp.listen((event) => isDirty = true);
    resetUiState();
  }

  Object get value => Format.internal(type, (_htmlElement as TextAreaElement).value);

  set value(Object value) {
    resetUiState();
    (_htmlElement as TextAreaElement).value = Format.display(type, value, "");
    InputValidator.reset(this);
  }
}
