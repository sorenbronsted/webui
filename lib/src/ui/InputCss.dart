
part of webui;

class InputCss {
  static String _cssError = "error";
  static String _cssValid = "valid";

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

  // hide element
  void hide(HtmlElement input) {
    input.hidden = true;
  }

  // hide element
  void show(HtmlElement input) {
    input.hidden = false;
  }
}
