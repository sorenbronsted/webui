
part of webui;

class UiInputValidatorListener {
  static String _cssError = "error";
  static String _cssValid = "valid";

  // Remove all Css validation
  void clear(UiInputType input) {
    input.classes.remove(_cssValid);
    input.classes.remove(_cssError);
    input.title = "";
  }

  // set css error validation
  void error(UiInputType input, String msg) {
    input.title = msg;
    input.classes.add(_cssError);
  }

  // set css valid validation
  void valid(UiInputType input) {
    input.classes.add(_cssValid);
  }
}
