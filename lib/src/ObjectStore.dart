
part of webui;

abstract class ObjectStoreListener {
  void valueChanged(String name);
}

class ObjectStore {
  Map _values;
  Map<String, ObjectStoreListener> _listeners;

  ObjectStore([Map values]) {
    _values = values ?? {};
    _listeners = {};
  }

  void set(String name, Object value) {
    _values[name] = value;
    _notifyListener(name);
  }

  Object get(String name) => _values.containsKey(name) ? _values[name] : null;

  void addListener(String name, ObjectStoreListener listener) {
    _listeners[name] = listener;
  }

  void _notifyListener(String name) => _listeners[name]?.valueChanged(name);
}