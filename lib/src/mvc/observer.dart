part of webui;

typedef EventHandler(Type sender, Object value);

class Observer {
	Logger log;
	Map<String, EventHandler> _handlers = {};

	Observer() {
		log = new Logger(runtimeType.toString());
	}

	void addEventHandler(String eventName, EventHandler handler) => _handlers[eventName] = handler;

	void removeEventHandler(String eventName) => _handlers.remove(eventName);

	void handleEvent(Type sender, String eventName, Object body) {
		log.fine('handleEvent: ${eventName}');
		if (!_handlers.containsKey(eventName)) {
			log.fine('handleEvent: no handler found for event: ${eventName}');
			return;
		}
		Function handler = _handlers[eventName];
		handler(sender, body);
	}
}

class Subject {
	Logger log;
	Set<Observer> _observers;

	Subject() {
		_observers = new HashSet();
		log = new Logger(runtimeType.toString());
	}

	void addEventListener(Observer observer) => _observers.add(observer);

	void removeEventListener(Observer observer) => _observers.remove(observer);

	void fire(String eventName, [Object body]) {
		log.fine('fire: ${eventName}');
		_observers.forEach((Observer observer) => observer.handleEvent(this.runtimeType, eventName, body));
	}
}
