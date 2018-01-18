part of webui;

class ViewElementEvent {
  static const String Link = 'link';
  static const String Change = 'change';
  static const String Save = 'save';
  static const String Cancel = 'cancel';
  static const String Create = 'create';
  static const String Delete = 'delete';
}

abstract class ViewElement {
  final Logger log = new Logger('View');

  String _bindId;
  String _viewName;
  DivElement _dom;
  Map<String, Function> _eventHandlers = {};
  List<UiElement> _elements = [];

  bool get isDirty {
    var firstWhere = _elements.firstWhere((UiElement input) => input is UiForm && input.isDirty, orElse: () => null);
    return firstWhere == null;
  }

  bool get isValid {
    var firstWhere = _elements.firstWhere((UiElement input) => input is UiForm && input.isValid == false, orElse: () => null);
    return firstWhere == null;
  }

  String get viewName => _viewName;

  ViewElement(String this._bindId, String this._viewName) {
    LinkElement htmlFragment = document.querySelector('#${_viewName}Import');
    if (htmlFragment == null) {
      throw "#${_viewName}Import not found";
    }
    _dom = htmlFragment.import.querySelector('#${_viewName}');
    if (_dom == null) {
      throw "#${_viewName} not found";
    }
    bind(this);
  }


  void show() {
    var div = document.querySelector(_bindId);
    if (div == null) {
      throw "${_bindId} not found";
    }

    if (div.children.isNotEmpty && div.children.first == _dom) {
      return;
    }
    div.children.clear();
    div.append(_dom);
  }

  bool isVisible() {
    var div = document.querySelector(_bindId);
    if (div == null) {
      throw "${_bindId} not found";
    }
    return div.children.isNotEmpty && div.children.first == _dom;
  }

  void bind(ViewElement view) {
    _dom.querySelectorAll("form[data-class], table[data-class]").forEach((Element elem) {
      var binding = null;
      switch(elem.runtimeType) {
        case FormElement:
          binding = new UiForm(this, elem);
          break;
        case TableElement:
          binding = new UiTable(this, elem);
          break;
      }

      if (binding != null) {
        _elements.add(binding);
      }
    });
  }

  void bindButton(String name, bool isValidRequired) {
    ButtonElement button = _dom.querySelector('button[name="${name}"]');
    if (button == null) {
      throw "Button not found name ${name}";
    }
    button.onClick.listen((Event event) {
      handleEvent(name, isValidRequired, event);
    });
  }

  void addEventHandler(String event, Function handler) {
    _eventHandlers[event] = handler;
  }

  void handleEvent(String name, bool isValidRequired, Event event) {
    event.preventDefault();
    log.fine('Name ${name} Event ${event} validRequired ${isValidRequired} isValid ${isValid}');
    if (isValidRequired == true && isValid == false) {
      return;
    }
    Function handler = _eventHandlers[name];
    if (handler != null) {
      handler(name, event);
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
    _elements.forEach((UiElement element) => element.showError(fieldsWithError));
  }
}
