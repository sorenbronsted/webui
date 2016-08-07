part of webui;

class UiTextArea extends TextAreaElement with UiInputState implements ObjectStoreListener, UiInputType {
  static const String uiTagName = 'x-textarea';
  String _uiType;
  View _view;

  UiTextArea.created() : super.created() {
    _uiType = attributes['x-type'];
    resetUiState();
  }

  String get uiType => _uiType;

  void bind(ObjectStore store, View view) {
    _view = view;
    onBlur.listen((Event e) {
      if (isDirty) {
        _doValidate();
        if (isValid) {
          store.changeMapProperty(name, Format.internal(_uiType, value, ""));
          isDirty = false;
        }
      }
    });

    onFocus.listen((event) {
      UiInputValidator.reset(this);
      isValid = true;
    });

    onKeyUp.listen((event) => isDirty = true);
    store.addListener(name, this);
  }

  void valueChanged(String name, String changedValue) {
    resetUiState();
    value = Format.display(_uiType, changedValue, "");
    UiInputValidator.reset(this);
  }

  bool _doValidate() {
    return UiInputValidator.validate(this);
  }
}
