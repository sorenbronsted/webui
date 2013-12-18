
library eventbus;

typedef void EventBusListener(String event);

class EventBus {
  Map eventListenerMap = new Map<String, List<EventBusListener> >();

  void addListener(String event, EventBusListener listener) {
    assert(event != null);
    assert(listener != null);
    
    var listeners = eventListenerMap[event];
    if (listeners == null) {
      listeners = new List<EventBusListener>();
      eventListenerMap[event] = listeners;
    }
    listeners.add(listener);
  }
  
  void removeListener(String event, listener) {
    assert(event != null);
    assert(listener != null);

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
    //print("fire $event");
    eventListenerMap.forEach((eventName, listeners) {
      if (event == eventName) {
        listeners.forEach((listener) {
          listener(event);
        });
      }
    });
  }
}
