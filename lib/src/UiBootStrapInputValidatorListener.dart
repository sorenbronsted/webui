
part of webui;

class UiBootStrapInputValidatorListener implements UiInputValidatorListener {
  static String _cssError = "has-error";
  static String _cssValid = "has-success";

  @override
  void clear(HtmlElement input) {
    var fg = getFormGroup(input);
    fg.classes.remove(_cssError);
    fg.classes.remove(_cssValid);
  }

  @override
  void error(HtmlElement input, String msg) {
    var fg = getFormGroup(input);
    fg.classes.add(_cssError);
    input.title = msg;
  }

  @override
  void valid(HtmlElement input) {
    var fg = getFormGroup(input);
    fg.classes.add(_cssValid);
  }

  HtmlElement getFormGroup(HtmlElement start) {
    if (start.classes.contains("form-group")) {
      return start;
    }
    return getFormGroup(start.parent);
  }
}

