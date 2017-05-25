library store;

import 'dart:math';
import 'package:logging/logging.dart';

abstract class Observer {
	void update();
}

class Subject {
	List<Observer> _observers = [];

	void attach(Observer observer) {
		_observers.add(observer);
	}

	void detach(Observer observer) {
		_observers.remove(observer);
	}

	void notify(Observer sender) {
		_observers.forEach((Observer o) {
			if (sender != o) {
				o.update();
			}
		});
	}
}

class Topic {
	String _cls;
	String _property;
	String _uid;

	String get cls => _cls;
	String get property => _property;
	String get uid => _uid;

	Topic(this._cls, [this._property, this._uid]);

	@override
	String toString() {
		StringBuffer result = new StringBuffer(_cls);
		if (_property != null) {
			result.write('.');
			result.write(_property);
		}
		if (_uid != null) {
			result.write('.');
			result.write(_uid);
		}
		return result.toString();
	}

}

/**
 * Objectstore manages object which the ui elements binds to.
 */
class ObjectStore {
	/* The store is organized as a map where the the first key is the class name.
   * The next level is also a a map indexed by the uid
   * The last level is a map of properties and values for the stored uid (object)
   * Another way to se it is class->uid->properties {name,value}
   */
	final Logger log = new Logger('ObjectStore');
	Map<String, Subject> _observers = {};
	Map<String, Map<String, Map>> _store;
	List<Function> _stateListeners;
	bool _isDirty;
	Random rand = new Random();

	bool get isDirty => _isDirty;

	set isDirty(bool state) {
		if (_isDirty == state) {
			return;
		}
		log.fine('isDirty changed from ${isDirty} to ${state}');
		_isDirty = state;
		_stateListeners.forEach((listener) => listener());
	}

	ObjectStore() {
		_store = {};
		_stateListeners = [];
		_isDirty = false;
	}

	Object getProperty(String cls, String property, [String uid]) {
		Map object = getObject(cls, uid);
		if (object.containsKey(property) == false) {
			return null;
		}
		return object[property];
	}

	void setProperty(Observer sender, String cls, String property, Object value, [String uid]) {
		Map object = _getObject(cls, uid);
		object[property] = value;
		isDirty = true;
		_notifyListener(sender, new Topic(cls, property, uid));
	}

	void addCollectionProperty(Observer sender, String cls, String property, Object value,	[String uid]) {
		Map object = _getObject(cls, uid);
		if (object[property] == null) {
			object[property] = [];
		}
		log.fine('addCollectionProperty: ${cls}.${property} value ${value}');
		(object[property] as List).add(value);
		isDirty = true;
		_notifyListener(sender, new Topic(cls, property, uid));
	}

	void removeCollectionProperty(Observer sender, String cls, String property, Object value, [String uid]) {
		Map object = _getObject(cls, uid);
		if (object[property] == null) {
			return;
		}
		log.fine('removeCollectionProperty: ${cls}.${property} value ${value}');
		(object[property] as List).remove(value);
		isDirty = true;
		_notifyListener(sender, new Topic(cls, property, uid));
	}

	Map getObject(String cls, [String uid]) {
		if (cls == null) {
			return {};
		}
		uid = _uid2String(uid);
		if (_store.containsKey(cls) == false ||
			(uid != null && _store[cls][uid] == null)) {
			return {};
		}
		if (uid == null) {
			uid = _store[cls].keys.first;
		}
		return _store[cls][uid];
	}

	Iterable<Map> getObjects(String cls) {
		if (_store.containsKey(cls) == true) {
			return _store[cls].values;
		}
		return [];
	}

	void add(Observer sender, Object data, [String name]) {
		String cls;
		Iterable properties;

		if (data is List) {
			List rows = data;
			if (rows.isEmpty) {
				return;
			}
			cls = (name != null ? name : (rows.first as Map).keys.first);
			log.fine('addMap: ${cls}');
			rows.forEach((Map row) {
				_addMap(row, name);
			});
			properties = ((rows.first as Map).values.first as Map).keys;
		}
		else {
			Map row = data;
			if (row.isEmpty) {
				return;
			}
			cls = (name != null ? name : row.keys.first);
			log.fine('addMap: ${cls}');
			_addMap(row, cls);
			properties = (row.values.first as Map).keys;
		}

		_notifyListener(sender, new Topic(cls));
		properties.forEach((String property) {
			_notifyListener(sender, new Topic(cls, property));
		});
		isDirty = false;
	}

	void attach(Observer observer, Topic topic) {
		var name = topic.toString();
		if (name == null || name.isEmpty) {
			throw "Observerable id must not be empty";
		}
		log.fine('attach: ${name}');
		if (_observers[name] == null) {
			_observers[name] = new Subject();
		}
		_observers[name].attach(observer);
	}

	void detach(Observer observer, Topic topic) {
		var name = topic.toString();
		if (name == null || name.isEmpty) {
			throw "Observerable id must not be empty";
		}
		log.fine('detach: ${name}');
		if (_observers[name] == null) {
			_observers[name] = new Subject();
		}
		_observers[name].detach(observer);
	}

	void addStateListener(Function listener) {
		if (_stateListeners.contains(listener)) {
			return;
		}
		log.fine('addStateListener: ${listener}');
		_stateListeners.add(listener);
	}

	void remove(Observer sender, String cls, [String uid]) {
		log.fine('remove: ${cls}.${uid}');
		if (_store.containsKey(cls) == true) {
			if (uid != null) {
				uid = _uid2String(uid);
				if (_store[cls].containsKey(uid) == false) {
					return;
				}
				_store[cls].remove(uid);
			}
			else {
				_store.remove(cls);
			}
		}
		_notifyListener(sender, new Topic(cls));
		_observers.keys.forEach((String key) {
			var parts = key.split('.');
			if (parts.length == 2 && cls == parts[0]) {
				_notifyListener(sender, new Topic(cls, parts[1]));
			}
		});
		isDirty = false;
	}

	Map _getObject(String cls, String uid) {
		if (_store[cls] == null) {
			_store[cls] = {};
			_store[cls]['0'] = {'uid':'0'};
		}
		if (uid == null) {
			uid = _store[cls].keys.first;
		}
		else {
			uid = _uid2String(uid);
		}
		return _store[cls][uid];
	}

	void _notifyListener(Observer sender, Topic topic) {
		log.fine('notifyListener: ${topic}');
		_observers[topic.toString()]?.notify(sender);
	}

	void _addMap(Map object, [String name]) {
		String cls = object.keys.first;
		Map properties = object[cls];
		if (!properties.containsKey('uid')) {
			properties['uid'] = rand.nextInt(pow(2,32));
		}
		properties['uid'] = properties['uid'].toString();

		var storeName = (name != null ? name : cls);
		if (_store[storeName] == null) {
			_store[storeName] = {};
			_store[storeName][properties['uid']] = {};
		}
		_store[storeName][properties['uid']] = properties;
	}

	String _uid2String(Object uid) => uid == null ? null : uid.toString();
}

