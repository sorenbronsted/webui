
library webuiSample;

import 'dart:async';
import 'package:webui/webui.dart';
import 'dart:html';

part 'PersonListView.dart';
part 'PersonListCtrl.dart';
part 'PersonDetailView.dart';
part 'PersonDetailCtrl.dart';

class BootStrapInputValidatorCss implements UiInputValidatorCss {
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

void main() {
  var bus = EventBus.instance;
  bus.register(new PersonListCtrl());
  bus.register(new PersonDetailCtrl());

  UiInputValidator.css = new BootStrapInputValidatorCss();

  Address.instance.goto("list/Person");
}
