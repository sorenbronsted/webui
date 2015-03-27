
library webuiSample;

import 'dart:async';
import '../webui/EventBus.dart';
import '../webui/Address.dart';
import '../webui/BaseView.dart';
import '../webui/Rest.dart';

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
