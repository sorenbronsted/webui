part of webui;

abstract class UiInputState extends UiElement {
  bool _isValid;
  bool _isDirty;

  bool get isValid => _isValid;
  set isValid(bool state) => _isValid = state;

  bool get isDirty => _isDirty;
  set isDirty(bool state) => _isDirty = state;

  UiInputState(HtmlElement element, [String cls]) : super(element, cls);

  void resetUiState() {
    _isValid = true;
    _isDirty = false;
  }

  validate() => _isValid = _doValidate();

  _doValidate();
}