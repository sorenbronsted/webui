
part of webui;

class UiBootStrapInputValidatorListener implements UiInputValidatorListener {
  static String _cssError = "has-error";
  static String _cssValid = "has-success";

  @override
  void clear(HtmlElement input) {
    var element = input.parent;
    if (element == null) {
      element = input;
    }
    element.classes.remove(_cssError);
    element.classes.remove(_cssValid);
    input.title = '';
  }

  @override
  void error(HtmlElement input, String msg) {
    var element = input.parent;
    if (element == null) {
      element = input;
    }
    element.classes.remove(_cssValid);
    element.classes.add(_cssError);
    input.title = msg;
  }

  @override
  void valid(HtmlElement input) {
    var element = input.parent;
    if (element == null) {
      element = input;
    }
    element.classes.remove(_cssError);
    element.classes.add(_cssValid);
    input.title = '';
  }
}

