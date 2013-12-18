
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
  EventBus bus = new EventBus();
  Address.instance.eventBus = bus;

  var controllers = new List();
  controllers.add(new PersonListCtrl(bus));
  controllers.add(new PersonDetailCtrl(bus));
  
  Address.instance.goto("Person");
}
