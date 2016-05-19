
part of webui;

typedef void Handler(String data);

abstract class View {
  Map<String, Handler> _handlers;
  List<UiBinding> _bindings;
  String _bindId;
  bool _isDirty; // if true input has changed
  bool _isValid; // if true input is valid

  bool get isDirty => _isDirty;
  set isDirty(bool val) => _isDirty = val;

  bool get isValid => _isDirty;
  set isValid(bool val) => _isValid = val;

  String get viewName;

  View(String this._bindId) {
    _isDirty = false;
    _isValid = true;
    _handlers = {};
    _bindings = [];
  }

  Future show() {
    //TODO view should only load ones
    _bindings.clear();
    return Rest.instance.load('view/${viewName}.html').then((html) {
      querySelector(_bindId).setInnerHtml(html.toString());
      registerBindings();
      _bindings.forEach((UiBinding binding) {
        try {
          binding.bind(this);
        }
        on SelectorException catch(e) {
          print("Warning: ${e}");
        }
      });
    });
  }

  void registerBindings() {}

  UiBinding addBinding(UiBinding binding) {
    _bindings.add(binding);
    return binding;
  }

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
    var cls = fieldsWithError['class'];
    fieldsWithError.forEach((String field, String message) {
      var elem = null;
      if (cls != null) {
        elem = querySelector("#${cls}-${field}");
      }
      if (elem == null) {
        elem = querySelector("#${field}");
      }
      if (elem != null) {
        UiInputValidator._css.clear(elem);
        UiInputValidator._css.error(elem, message);
      }
    });
  }
}
