
library eventbus;

import 'package:logging/logging.dart';

typedef void EventBusAction(String event);

class EventBusListener {
  void register(EventBus eventBus) {}
}

class EventBus {
  final Logger log = new Logger('EventBus');
  Map eventListenerMap = new Map<String, List<EventBusAction> >();

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
  
  void listenOn(String event, EventBusAction listener) {
    assert(event != null);
    assert(listener != null);
    log.fine("listenOn ${event}");

    var listeners = eventListenerMap[event];
    if (listeners == null) {
      listeners = new List<EventBusAction>();
      eventListenerMap[event] = listeners;
    }
    listeners.add(listener);
  }
  
  void listenOff(String event, EventBusAction listener) {
    assert(event != null);
    assert(listener != null);
    log.fine("listenOff ${event}");

    var listeners = eventListenerMap[event];
    if (listeners != null) {
      var idx = listeners.indexOf(listener);
      if (idx >= 0) {
        listeners.removeAt(idx);
      }
    }
  }
  
  void fire(String event) {
    assert(event != null);
    log.fine("fire $event");
    eventListenerMap.forEach((eventName, listeners) {
      if (event == eventName) {
        listeners.forEach((listener) {
          listener(event);
        });
      }
    });
  }
}
