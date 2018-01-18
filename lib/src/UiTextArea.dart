part of webui;

class UiTextArea extends UiInputElement {

  UiTextArea(ViewElement view, TextAreaElement input, String inheritCls) : super(input, inheritCls) {
    htmlElement.onBlur.listen((Event e) {
      if (isDirty) {
        validate();
        if (isValid) {
          //TODO _store.setProperty(this, cls, property, Format.internal(type, (htmlElement as TextAreaElement).value, ""), uid);
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

  String get value => Format.internal(type, (htmlElement as TextAreaElement).value);

  set value(String value) {
    resetUiState();
    (htmlElement as TextAreaElement).value = Format.display(type, value, "");
    UiInputValidator.reset(this);
  }
}
