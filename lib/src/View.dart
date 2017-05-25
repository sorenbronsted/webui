
part of webui;

typedef void Handler(String data);

abstract class View {
  final Logger log = new Logger('View');
  Map<String, Handler> _handlers;
  String _bindId;
  String _viewName;
  DivElement _dom;
  List<UiElement> _bindings;

  bool get isValid;
  String get viewName => _viewName;
  DivElement get dom => _dom;
  List<UiElement> get bindings => _bindings;

  View(String this._bindId, String this._viewName) {
    _handlers = {};
    _bindings = [];

    LinkElement htmlFragment = document.querySelector('#${_viewName}Import');
    if (htmlFragment == null) {
      throw "#${_viewName}Import not found";
    }
    _dom = htmlFragment.import.querySelector('#${_viewName}');
    if (_dom == null) {
      throw "#${_viewName} not found";
    }
    bind(_dom);
  }

  void show(ObjectStore store) {
    var div = document.querySelector(_bindId);
    if (div == null) {
      throw "${_bindId} not found";
    }
    div.children.clear();
    div.append(_dom);
    _bindings.forEach((UiElement elem) => elem.attach(store));
  }

  void hide(ObjectStore store) {
    _bindings.forEach((UiElement elem) => elem.detach(store));
  }

  void bind(DivElement dom);

  void bindButton(String name, bool validate) {
    ButtonElement button = _dom.querySelector('#${_viewName} button[name="${name}"]');
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
        elem = _dom.querySelector('input[bind="${cls}.${field}"]');
      }
      if (elem == null) {
        elem = _dom.querySelector('input[bind="${field}"]');
      }
      if (elem != null) {
        UiInputValidator._css.clear(elem);
        UiInputValidator._css.error(elem, message);
      }
    });
  }

  _addBinding(UiElement elem) => _bindings.add(elem);
}
