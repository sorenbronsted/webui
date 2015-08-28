
part of webui;

class UiButtonBinding extends UiBinding {
  ButtonElement _button;
  bool _validationRequired;

  UiButtonBinding(ButtonElement this._button, bool this._validationRequired) {
    if (_button == null) {
      throw "IllegalArgument: button must not be null";
    }
  }

  void bind(View view) {
    _button.onClick.listen((event) {
      event.preventDefault();
      ButtonElement elem = event.target;
      view.executeHandler(elem.name, _validationRequired);
    });
  }

  Object read() => null;
  void write(Object o) {}
}