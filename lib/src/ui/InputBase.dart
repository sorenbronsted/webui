part of webui;

abstract class InputBase extends ElementWrapper {

  bool get isValid => _view.isValid;
  set isValid(bool state) => _view.isValid = state;

  bool get isDirty => _view.isDirty;
  set isDirty(bool state) =>_view.isDirty = state;

  InputBase(View view, HtmlElement element, [String cls]) : super(view, element, cls);

  void resetUiState() {
    isValid = true;
    isDirty = false;
  }

  validate() => isValid = InputValidator.validate(this);

  @override
  void showError(Object error) {
    if (error is Map && error.containsKey(_property)) {
      InputValidator._css.clear(_htmlElement);
      InputValidator._css.error(_htmlElement, error[_property]);
    }
  }
}