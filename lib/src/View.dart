
part of webui;

typedef void Handler(String data);

abstract class View {
  Map<String, Handler> _handlers;
  String _bindId;
  String _viewName;
  static DivElement _currentView; // current active view

  bool get isValid;

  View(String this._bindId, String this._viewName) {
    _handlers = {};

    LinkElement htmlFragment = document.querySelector('#${_viewName}Import');
    if (htmlFragment == null) {
      throw "#${_viewName}Import not found";
    }
    var view = htmlFragment.import.querySelector('#${_viewName}');
    if (view == null) {
      throw "#${_viewName} not found";
    }
    view.hidden = true;
    document.querySelector(_bindId).append(view);
  }

  void show() {
    if (_currentView != null) {
      _currentView.hidden = true;
    }
    _currentView = document.querySelector('#${_viewName}');
    _currentView.hidden = false;
  }

  void bind(ObjectStore store);

  addHandler(String key, Handler handler) {
    _handlers[key] = handler;      
  }

  executeHandler(String key, bool validRequired, [String data]) {
    if (validRequired && !isValid) {
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
