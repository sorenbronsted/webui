part of webui;

class UiTextArea extends UiInputState {

  UiTextArea(TextAreaElement input, [String inheritCls]) : super(input, inheritCls) {
    htmlElement.onBlur.listen((Event e) {
      if (isDirty) {
        _doValidate();
        if (isValid) {
          _store.setProperty(this, cls, property, Format.internal(type, (htmlElement as TextAreaElement).value, ""), uid);
          isDirty = false;
        }
      }
    });

    htmlElement.onFocus.listen((event) {
      UiInputValidator.reset(this);
      isValid = true;
    });

    htmlElement.onKeyUp.listen((event) => isDirty = true);
    resetUiState();
  }

  @override
  void update() {
    resetUiState();
    (htmlElement as TextAreaElement).value = Format.display(type, store.getProperty(cls, property), "");
    UiInputValidator.reset(this);
  }

  bool _doValidate() {
    return UiInputValidator.validate(this);
  }
}
