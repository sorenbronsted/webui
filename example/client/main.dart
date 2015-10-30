
library webuiSample;

import 'dart:async';
import 'package:webui/webui.dart';
import 'dart:html';

part 'PersonListView.dart';
part 'PersonListCtrl.dart';
part 'PersonDetailView.dart';
part 'PersonDetailCtrl.dart';

void main() {
  var bus = EventBus.instance;
  bus.register(new PersonListCtrl());
  bus.register(new PersonDetailCtrl());
  Address.instance.goto("Person");
}
