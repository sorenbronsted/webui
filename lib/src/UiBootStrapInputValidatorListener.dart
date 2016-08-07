
part of webui;

class UiBootStrapInputValidatorListener implements UiInputValidatorListener {
  static String _cssError = "has-error";
  static String _cssValid = "has-success";

  @override
  void clear(UiInputType input) {
    var fg = _getFormGroup(input as HtmlElement);
    if (fg != null) {
      fg.classes.remove(_cssError);
      fg.classes.remove(_cssValid);
    }
  }

  @override
  void error(UiInputType input, String msg) {
    var fg = _getFormGroup(input as HtmlElement);
    if (fg != null) {
      fg.classes.add(_cssError);
    }
    input.title = msg;
  }

  @override
  void valid(UiInputType input) {
    var fg = _getFormGroup(input as HtmlElement);
    if (fg != null) {
      fg.classes.add(_cssValid);
    }
  }

  HtmlElement _getFormGroup(HtmlElement start) {
    if (start == null) {
      return null;
    }
    if (start.classes.contains("form-group")) {
      return start;
    }
    return _getFormGroup(start.parent);
  }
}

