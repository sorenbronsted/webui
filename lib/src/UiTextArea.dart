part of webui;

class UiTextArea extends TextAreaElement with UiInputState, UiBind implements ObjectStoreListener, UiInputType {
  static const String uiTagName = 'x-textarea';
  String _uiType;
  View _view;

  UiTextArea.created() : super.created() {
    setBind(getAttribute('bind'));
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
          store.setProperty(_cls, _property, Format.internal(_uiType, value, ""));
          isDirty = false;
        }
      }
    });

    onFocus.listen((event) {
      UiInputValidator.reset(this);
      isValid = true;
    });

    onKeyUp.listen((event) => isDirty = true);
    store.addListener(this, _cls, _property);
  }

  void valueChanged(String cls, String property) {
    resetUiState();
    value = Format.display(_uiType, _view.store.getProperty(cls, property), "");
    UiInputValidator.reset(this);
  }

  bool _doValidate() {
    return UiInputValidator.validate(this);
  }
}
