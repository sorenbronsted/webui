part of webui;

abstract class UiInputElement extends UiElement {
  bool _isValid;
  bool _isDirty;

  bool get isValid => _isValid;

  set isValid(bool state) => _isValid = state;

  bool get isDirty => _isDirty;
  set isDirty(bool state) => _isDirty = state;

  String get value;
  set value(String value);

  UiInputElement(HtmlElement element, [String cls]) : super(element, cls);

  void resetUiState() {
    _isValid = true;
    _isDirty = false;
  }

  validate() => _isValid = UiInputValidator.validate(this);

  @override
  void showError(Map fieldsWithError) {
    if (fieldsWithError['class'] != cls || fieldsWithError[property] == null) {
      return;
    }
    UiInputValidator._css.clear(htmlElement);
    UiInputValidator._css.error(htmlElement, fieldsWithError[property]);
  }
}