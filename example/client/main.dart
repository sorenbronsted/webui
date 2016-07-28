
library webuiSample;

import 'dart:async';
import 'package:webui/webui.dart';
import 'dart:html';

part 'PersonListView.dart';
part 'PersonListCtrl.dart';
part 'PersonDetailView.dart';
part 'PersonDetailCtrl.dart';

void main() {
  initWebUi();

  UiInputValidator.css = new UiBootStrapInputValidatorListener();
  UiTable.css = new UiBootStrapTableCss();

  var bus = EventBus.instance;
  bus.register(new PersonListCtrl());
  bus.register(new PersonDetailCtrl());

  Address.instance.goto("list/Person");
}
