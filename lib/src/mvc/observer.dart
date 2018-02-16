part of webui;

class Observer {
	Logger log;

	Observer() {
		log = new Logger(runtimeType.toString());
	}
}

typedef EventHandler(Type sender, Object value);

class Subject {
	Logger log;
	Map<String, List<EventHandler>> _observers = {};

	Subject() {
		log = new Logger(runtimeType.toString());
	}

	void addEventHandler(String name, EventHandler observer) {
		if (!_observers.containsKey(name)) {
			_observers[name] = [];
		}
		if (_observers[name].contains(observer)) {
			return;
		}
		_observers[name].add(observer);
	}

	void removeEventHandler(String name, EventHandler observer) {
		if (!_observers.containsKey(observer)) {
			return;
		}
		_observers[name].remove(observer);
	}

	void fire(String name, [Object body]) {
		log.fine('fire: ${name}');
		List listeners = _observers[name];
		if (listeners != null) {
			listeners.forEach((EventHandler observer) => observer(runtimeType, body));
		}
	}
}
