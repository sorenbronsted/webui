part of webui;

class UiInput extends InputElement with UiInputState implements ObjectStoreListener, UiInputType {
  static const String uiTagName = 'x-input';
  String _uiType;
  String _format;
  View _view;

  UiInput.created() : super.created() {
    _uiType = attributes['x-type'];
    _format = attributes['format'];
    resetUiState();
  }

  String get uiType => _uiType;

  void bind(ObjectStore store, View view) {
    _view = view;
    if (type == 'file') {
      onChange.listen((event) {
        event.preventDefault();
        store.set(name, files);
        store.isDirty = true;
      });
    }
    else {
      onBlur.listen((Event e) {
        if (isDirty) {
          _doValidate();
          if (isValid) {
            store.changeMapProperty(name, Format.internal(_uiType, value, _format));
            isDirty = false;
          }
        }
      });

      onFocus.listen((event) {
        UiInputValidator.reset(this);
        isValid = true;
      });

      onKeyUp.listen((event) => isDirty = true);
    }
    store.addListener(name, this);
  }

  void valueChanged(String name, String changedValue) {
    resetUiState();
    value = Format.display(_uiType, changedValue, _format);
    UiInputValidator.reset(this);
  }

  bool _doValidate() {
    return UiInputValidator.validate(this);
  }
}
