
part of webui;

class UiButtonBinding extends UiBinding {
  String _selector;
  ButtonElement _button;
  bool _validationRequired;

  UiButtonBinding(String this._selector, bool this._validationRequired) {
    if (_selector == null) {
      throw "IllegalArgument: button must not be null";
    }
  }

  void bind(View view) {
    _button = querySelector(_selector);
    if (_button == null) {
      throw "Button not found (selector $_selector)";
    }
    _button.onClick.listen((event) {
      event.preventDefault();
      ButtonElement elem = event.target;
      view.executeHandler(elem.name, _validationRequired);
    });
  }

  Object read() => null;
  void write(Object o) {}
}