
library eventbus;

import 'package:logging/logging.dart';

class BusEvent {
  String _name;
  Object _value;

  String get name => _name;
  Object get value => _value;

  BusEvent(this._name, [this._value]);

  String toString() => name;
}

abstract class EventBusListener {
  void register(EventBus bus);
  void run(BusEvent event);
}

class EventBus {
  final Logger log = new Logger('EventBus');
  List<EventBusListener> listeners = [];

  static EventBus _instance;

  EventBus._internal() {
  }

  static EventBus get instance {
    if (_instance == null) {
      _instance = new EventBus._internal();
    }
    return _instance;
  }
  
  void register(EventBusListener listener) {
    listener.register(this);
  }
  
  void listenOn(EventBusListener listener) {
    assert(listener != null);
    log.fine("listenOn ${listener}");
    listeners.add(listener);
  }
  
  void listenOff(EventBusListener listener) {
    assert(listener != null);
    log.fine("listenOff ${listener}");
    listeners.remove(listener);
  }
  
  void fire(Object sender, BusEvent event) {
    assert(event != null);
    log.fine("fire $event");
    listeners.forEach((EventBusListener listener) {
      if (sender != listener) {
        listener.run(event);
      }
    });
  }
}
