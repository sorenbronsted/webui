part of webui;

class UiInput extends InputElement with UiInputState, UiBind implements ObjectStoreListener, UiInputType {
  static const String uiTagName = 'x-input';
  String _uiType;
  String _format;
  ObjectStore _store;

  set uiType(String uiType) => _uiType = uiType;
  String get uiType => _uiType;

  set format(String format) => _format = format;
  String get format => _format;

  factory UiInput([String bind, String xType, String format]) {
    UiInput input = document.createElement('input', UiInput.uiTagName);
    input.setBind(bind);
    input._uiType = xType;
    input._format = format;
    input.resetUiState();
    return input;
  }

  UiInput.created() : super.created() {
    setBind(getAttribute('bind'));
    _uiType = attributes['x-type'];
    _format = attributes['format'];
    resetUiState();
  }

  void bind(ObjectStore store, View view) {
    _store = store;
    if (type == 'file') {
      onChange.listen((event) {
        event.preventDefault();
        store.setProperty(_cls, _property, files);
      });
    }
    else if (type == 'checkbox') {
      onChange.listen((Event e) {
        if (_uiType == 'selection') {
          if (checked == true) {
            _store.addCollectionProperty(_cls, _property, value, _uid);
          }
          else {
            _store.removeCollectionProperty(_cls, _property, value, _uid);
          }
        }
        else {
          var value = (checked == true ? 1 : 0);
          _store.setProperty(_cls, _property, value, _uid);
        }
      });
    }
    else if (type == 'radio') {
      onChange.listen((Event e) {
        _store.setProperty(_cls, _property, value, _uid);
      });
    }
    else {
      onBlur.listen((Event e) {
        if (isDirty) {
          _doValidate();
          if (isValid) {
            _store.setProperty(_cls, _property, Format.internal(_uiType, value, _format), _uid);
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
    _store.addListener(this, _cls, _property);
    valueChanged(_cls, _property);
  }

  void valueChanged(String cls, String property) {
    resetUiState();
    value = Format.display(_uiType, _store.getProperty(cls, property, _uid), _format);
    UiInputValidator.reset(this);
  }

  bool _doValidate() {
    return UiInputValidator.validate(this);
  }
}
