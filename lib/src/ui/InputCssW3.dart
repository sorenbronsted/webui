
part of webui;

class UiInputValidatorListenerW3 implements UiInputCss {
  static String _cssError = "w3-border-red";
  static String _cssValid = "w3-border-green";

  // Remove all Css validation
  void clear(HtmlElement input) {
    input.classes.remove(_cssValid);
    input.classes.remove(_cssError);
    input.title = "";
  }

  // set css error validation
  void error(HtmlElement input, String msg) {
    input.title = msg;
    input.classes.add(_cssError);
  }

  // set css valid validation
  void valid(HtmlElement input) {
    input.classes.add(_cssValid);
  }

  @override
  void hide(HtmlElement input) {
    input.hidden = true;
  }

  @override
  void show(HtmlElement input) {
    input.hidden = false;
  }
}
