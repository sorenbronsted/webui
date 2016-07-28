part of webui;

class UiInput extends InputElement implements ObjectStoreListener {
  static const String uiTagName = 'x-input';
  String _uiType;
  View _view;

  UiInput.created() : super.created() {
    _uiType = attributes['x-type'];
  }

  String get uiType => _uiType;

  void bind(ObjectStore store, View view) {
    _view = view;
    if (type == 'file') {
      onChange.listen((event) {
        event.preventDefault();
        store.set(name, files);
        view.isDirty = true;
      });
    }
    else {
      onBlur.listen((Event e) {
        if (view.isDirty) {
          view.isValid = UiInputValidator.validate(this);
          store.setMapProperty(name, Format.internal(_uiType, value));
        }
      });

      onFocus.listen((event) {
        UiInputValidator.reset(this);
        view.isValid = true;
      });
      onKeyUp.listen((event) => view.isDirty = true);
    }
    store.addListener(name, this);
  }

  void valueChanged(String name, String changedValue) {
    _view.isValid = true;
    _view.isDirty = false;
    value = Format.display(_uiType, changedValue);
  }
}
