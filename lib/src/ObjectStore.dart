
part of webui;

abstract class ObjectStoreListener {
  void valueChanged(String name, Object value);
}

class ObjectStore {
  Map _values;
  Map<String, ObjectStoreListener> _listeners;

  ObjectStore([Map values]) {
    _values = values ?? {};
    _listeners = {};
  }

  void setMapProperty(String name, Object value) {
    if (!name.contains('.')) {
      throw "name must be on form name.property";
    }
    var parts = name.split('.');
    if (parts.length != 2) {
      throw "name must be on form name.property";
    }
    Map map = _values[parts[0]];
    if (map != null) {
      map[parts[1]] = value;
    }
  }

  void setMap(String name, Map values) {
    set(name, values);
    // Notify listeners which listens on values in map
    _listeners.forEach((String listenerName, ObjectStoreListener listener) {
      if (listenerName.contains('.')) {
        var parts = listenerName.split('.');
        if (parts.length == 2 && name == parts[0]) {
          listener.valueChanged(listenerName, _values[name][parts[1]]);
        }
      }
    });
  }

  void set(String name, Object value) {
    _values[name] = value;
    _notifyListener(name);
  }

  Object getMapProperty(String name) {
    if (!name.contains('.')) {
      throw "name must be on form name.property";
    }
    var parts = name.split('.');
    if (parts.length != 2) {
      throw "name must be on form name.property";
    }
    Map map = _values[parts[0]];
    if (map != null) {
      return map[parts[1]];
    }
    return null;
  }

  Map getMap(String name) {
    return get(name);
  }

  Object get(String name) {
    return _values[name];
  }

  void addListener(String name, ObjectStoreListener listener) {
    _listeners[name] = listener;
  }

  void _notifyListener(String name) {
    var value = _values[name];
    _listeners[name]?.valueChanged(name, value);
  }
}