
part of webui;

class UiButtonBinding extends UiBinding {
  ButtonElement _button;
  View _view;

  UiButtonBinding(View _view, ButtonElement this._button, bool validRequired) {
    if (_button == null) {
      throw "IllegalArgument: button must not be null";
    }
    _button.onClick.listen((event) {
      event.preventDefault();
      ButtonElement elem = event.target;
      _view.executeHandler(elem.name, validRequired);
    });
  }
}