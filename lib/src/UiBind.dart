part of webui;

class UiBind {
  String _cls;
  String _property;
  String _uid;

  String get cls => _cls;
  String get property => _property;
  String get uid => _uid;

  set cls(String cls) => _cls = cls;
  set property(String property) => _property = property;
  set uid(String uid) => _uid = uid;

  void setBind(String name) {
    if (name  == null) {
      return;
    }
    var parts = name.split('.');
    if (parts.length < 1 || parts.length > 3) {
      throw "Attribute bind wrong format, must be class, class.property or class.property.uid";
    }
    _cls = parts[0];
    if (parts.length >= 2) {
      _property = parts[1];
    }
    if (parts.length == 3) {
      _uid = parts[2];
    }
  }
}