library store;

import 'package:logging/logging.dart';

abstract class ObjectStoreListener {
	void valueChanged(String cls, String property);
}

class NotFound {
	String msg;

	NotFound(this.msg);

	String toString() => msg;
}

/**
 * Objectstore manages object which the ui elements binds to.
 */
class ObjectStore {
	/* The store is organized as a map where the the first key is the class name.
   * The next level is also a a map indexed by the uid
   * The last lavel is a map of properties and values for the stored uid (object)
   * Another way to se it is class->uid->properties (name,value)
   */
	final Logger log = new Logger('ObjectStore');
	Map<String, Map<String, Map>> _store;
	Map<String, List<ObjectStoreListener>> _listeners;
	List<Function> _stateListeners;
	bool _isDirty;

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
		_listeners = {};
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

	void setProperty(String cls, String property, Object value, [String uid]) {
		Map object = _getObject(cls, uid);
		object[property] = value;
		isDirty = true;
	}

	void addCollectionProperty(String cls, String property, Object value,
		[String uid]) {
		Map object = _getObject(cls, uid);
		if (object[property] == null) {
			object[property] = [];
		}
		log.fine('addCollectionProperty: ${cls}.${property} value ${value}');
		(object[property] as List).add(value);
		isDirty = true;
	}

	void removeCollectionProperty(String cls, String property, Object value,
		[String uid]) {
		Map object = _getObject(cls, uid);
		if (object[property] == null) {
			return;
		}
		log.fine('removeCollectionProperty: ${cls}.${property} value ${value}');
		(object[property] as List).remove(value);
		isDirty = true;
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

	void setPropertyWithNofication(String cls, String property, Object value,
		[String uid]) {
		setProperty(cls, property, value, uid);
		_notifyListener(cls, property);
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

	void add(Object data, [String name]) {
		if (data is List) {
			List rows = data;
			if (rows.isEmpty) {
				return;
			}
			String cls = (name != null ? name : (rows.first as Map).keys.first);
			log.fine('addMap: ${cls}');
			rows.forEach((Map row) => _addMap(row, name));
			_notifyListener(cls);
		}
		else {
			Map row = data;
			if (row.isEmpty) {
				return;
			}
			String cls = (name != null ? name : row.keys.first);
			log.fine('addMap: ${cls}');
			_addMap(row, name);
			_notifyListener(cls);
			String uid = _store[cls].keys.first;
			_store[cls][uid].keys.forEach((String property) {
				_notifyListener(cls, property);
			});
		}
		isDirty = false;
	}

	void addListener(ObjectStoreListener listener, String cls, [String property]) {
		var name = property != null ? "${cls}.${property}" : cls;
		if (name == null || name.isEmpty) {
			return;
		}
		if (!_listeners.containsKey(name)) {
			_listeners[name] = [];
		}
		log.fine('addListener: ${name}');
		_listeners[name].add(listener);
	}

	void addStateListener(Function listener) {
		if (_stateListeners.contains(listener)) {
			return;
		}
		log.fine('addStateListener: ${listener}');
		_stateListeners.add(listener);
	}

	void remove(String cls, [String uid]) {
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
		_notifyListener(cls);
		_listeners.keys.forEach((
			String key) { //TODO This is not optimal. Need to rethink notification model
			var parts = key.split('.');
			if (parts.length == 2 && cls == parts[0]) {
				_notifyListener(cls, parts[1]);
			}
		});
		isDirty = false;
	}

	void _notifyListener(String cls, [String property]) {
		var name = property != null ? "${cls}.${property}" : cls;
		log.fine('notifyListener: ${name}');
		_listeners[name]?.forEach((elem) => elem.valueChanged(cls, property));
	}

	void _addMap(Map object, [String name]) {
		var cls = object.keys.first;
		Map properties = object[cls];
		String uid = _uid2String(properties['uid']);

		var storeName = (name != null ? name : cls);
		if (_store[storeName] == null) {
			_store[storeName] = {};
			_store[storeName][uid] = {};
		}

		_store[storeName][uid] = properties;
	}

	String _uid2String(Object uid) => uid == null ? null : uid.toString();
}

