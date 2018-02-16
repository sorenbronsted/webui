part of webui;

abstract class InputBase extends ElementWrapper {
  bool _isValid;
  bool _isDirty;

  bool get isValid => _isValid;

  set isValid(bool state) => _isValid = state;

  bool get isDirty => _isDirty;
  set isDirty(bool state) => _isDirty = state;

  InputBase(View view, HtmlElement element, [String cls]) : super(view, element, cls);

  void resetUiState() {
    _isValid = true;
    _isDirty = false;
  }

  validate() => _isValid = InputValidator.validate(this);

  @override
  void showError(Object error) {
    if (error == null) {
      return;
    }
    InputValidator._css.clear(_htmlElement);
    InputValidator._css.error(_htmlElement, error);
  }
}