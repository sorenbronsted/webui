
library webuiSample;

import 'dart:async';
import 'dart:html';
import 'package:intl/intl.dart';
import 'package:webui/webui.dart';

part 'PersonListView.dart';
part 'PersonListCtrl.dart';
part 'PersonDetailView.dart';
part 'PersonDetailCtrl.dart';
part 'TestView.dart';
part 'TestCtrl.dart';

void main() {
  String locale = 'da_DK';
  Intl.defaultLocale = locale;

  initWebUi();

  UiInputValidator.css = new UiBootStrapInputValidatorListener();
  UiTable.css = new UiBootStrapTableCss();

  var bus = EventBus.instance;
  bus.register(new PersonListCtrl());
  bus.register(new PersonDetailCtrl());
  bus.register(new TestCtrl());

  Address.instance.goto("/");
  Address.instance.goto("list/Person");
}
