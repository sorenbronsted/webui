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

  Object get value => Format.internal(_type, (_htmlElement as TextAreaElement).value);

  void populate(Type cls, Object value) {
    if (_cls != cls.toString()) {
      return;
    }

    Map values = value;
    if (!values.containsKey(_property)) {
      return;
    }
    _uid = values['uid'];

    resetUiState();
    (_htmlElement as TextAreaElement).value = Format.display(_type, values[_property], "");
    InputValidator.reset(this);
  }
}
