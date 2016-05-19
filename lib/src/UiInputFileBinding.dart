
part of webui;

class UiInputFileBinding extends UiBinding {
  String _selector;
  InputElement _input;

  UiInputFileBinding(String this._selector) {
    if (_selector == null) {
      throw "IllegalArgument: button must not be null";
    }
  }

  void bind(View view) {
    _input = querySelector(_selector);
    if (_input == null) {
      throw new SelectorException("Button not found (selector $_selector)");
    }
    _input.onChange.listen((event) {
      event.preventDefault();
      view.executeHandler(_input.id, false);
    });
  }

  Object read() => _input.files;
  void write(Object o) {}
}