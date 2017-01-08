
part of webui;

typedef void Handler(String data);

abstract class View {
  final Logger log = new Logger('View');
  Map<String, Handler> _handlers;
  String _bindId;
  String _viewName;
  ObjectStore _store;

  bool get isValid;

  String get viewName => _viewName;

  ObjectStore get store => _store;

  View(String this._bindId, String this._viewName) {
    _handlers = {};

    // Check if allready loaded
    var view = document.querySelector('#${_viewName}');
    if (view != null) {
      return;
    }

    LinkElement htmlFragment = document.querySelector('#${_viewName}Import');
    if (htmlFragment == null) {
      throw "#${_viewName}Import not found";
    }
    view = htmlFragment.import.querySelector('#${_viewName}');
    if (view == null) {
      throw "#${_viewName} not found";
    }
    view.hidden = true;
    document.querySelector(_bindId).append(view);
  }

  void show() => _hiddenState(false);

  void hide() => _hiddenState(true);

  void _hiddenState(bool state) {
    DivElement div = document.querySelector('#${_viewName}');
    if (div != null) {
      div.hidden = state;
    }
  }

  set store(ObjectStore store) {
    _store = store;
    bind(_store);
  }

  void bind(ObjectStore store);

  void bindButton(String name, bool validate) {
    ButtonElement button = document.querySelector('#${_viewName} button[name="${name}"]');
    if (button == null) {
      throw "Cannot find button with name {$name} in view ${_viewName}";
    }
    button.onClick.listen((event) {
      event.preventDefault();
      executeHandler(name, validate);
    });
  }


  addHandler(String key, Handler handler) {
    _handlers[key] = handler;      
  }

  executeHandler(String key, bool validRequired, [String data]) {
    log.fine('executeHandler: validRequired ${validRequired} isValid ${isValid}');
    if (validRequired == true && isValid == false) {
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
        elem = querySelector('input[bind="${cls}.${field}"]');
      }
      if (elem == null) {
        elem = querySelector('input[bind="${field}"]');
      }
      if (elem != null) {
        UiInputValidator._css.clear(elem);
        UiInputValidator._css.error(elem, message);
      }
    });
  }
}
