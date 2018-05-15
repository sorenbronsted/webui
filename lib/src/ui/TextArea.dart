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

    DataClass data = value;
    if (data.get(_property) == null) {
      return;
    }
    _uid = data.uid;

    resetUiState();
    (_htmlElement as TextAreaElement).value = Format.display(_type, data.get(_property), "");
    InputValidator.reset(this);
  }
}
