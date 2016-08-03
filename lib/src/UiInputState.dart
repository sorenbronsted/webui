part of webui;

abstract class UiInputState {
  bool _isValid;
  bool _isDirty;

  bool get isValid => _isValid;
  set isValid(bool state) => _isValid = state;

  bool get isDirty => _isDirty;
  set isDirty(bool state) => _isDirty = state;

  void resetUiState() {
    _isValid = true;
    _isDirty = false;
  }

  validate() => _isValid = _doValidate();

  _doValidate();
}