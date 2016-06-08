part of webui;

class UiInput extends InputElement implements ObjectStoreListener {

  ObjectStore _model;
  View _view;
  String _type;
  bool _isDirty;

  static const String uiTagName = 'ui-input';

  set view(View view) => _view = view;

  set model(ObjectStore model) {
    model.addListener(name, this);
    _model = model;
    valueChanged(name);
  }

  UiInput.created() : super.created() {
    _type = attributes['is'];

    onBlur.listen((Event e) {
      if (_isDirty) {
        _view.isValid = UiInputValidator.validate(this);
        _view.isDirty = true;
        _model.set(name, Format.internal(_type, value));
        _isDirty = false;
      }
    });

    onFocus.listen((event) {
      UiInputValidator.reset(this);
      _view.isValid = true;
    });

    onKeyUp.listen((event) => _isDirty = true);
  }

  void valueChanged(String name) {
    value = Format.display(_type, _model.get(name));
  }
}
