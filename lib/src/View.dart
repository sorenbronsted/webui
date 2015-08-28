
part of webui;

typedef void Handler(String data);

abstract class View {
  Map<String, Handler> _handlers = new Map();
  String _bindId;
  bool _isDirty = false; // if true input has changed
  bool _isValid = true; // if true input is valid

  View(String this._bindId);

  bool get isDirty => _isDirty;
  set isDirty(bool val) => _isDirty = val;

  bool get isValid => _isDirty;
  set isValid(bool val) => _isValid = val;

  String get viewName;

  Future show() {
    return Rest.instance.load('view/${viewName}.html').then((html) {
      querySelector(_bindId).setInnerHtml(html.toString());
      onLoad();
    });
  }

  onLoad() {}

  addHandler(String key, Handler handler) {
    _handlers[key] = handler;      

  }

  executeHandler(String key, bool validRequired, [String data]) {
    if (validRequired && !_isValid) {
      return;
    }
    Handler handle = _handlers[key];
    if (handle != null) {
      handle(data);
    }
  }

  confirm(String message) {
    return window.confirm(message);
  }

  showErrors(Map error) {
    Map fieldsWithError = error['ValidationException'];
    if (fieldsWithError == null) {
      return;
    }
    fieldsWithError.forEach((String field, String message) {
      var elem = querySelector("input[name=$field]");
      if (elem != null) {
        elem.title = message;
        elem.classes.remove("valid");
        elem.classes.add("error");
      }
    });
  }
}
