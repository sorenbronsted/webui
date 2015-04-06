
part of webui;

typedef void Handler(String data);

abstract class BaseView {
  Map<String, Handler> _handlers = new Map();
  InputValidator _inputValidator; 

  BaseView() {}
  
  InputValidator get inputValidator => _inputValidator;
  
  String getViewName();
  
  setValidation(String selector) {
    _inputValidator = new InputValidator(selector, new Validators());
  }
  
  Future show() {
    Future f = Rest.instance.load('view/${getViewName()}.html');
    return f.then((html) {
      querySelector('#content').setInnerHtml(html.toString());
      onLoad();
    });
  }

  String getInputValue(String name) => (querySelector("input[name=$name]") as InputElement).value;
  String getSelectValue(String name) => (querySelector("select[name=$name]") as SelectElement).value;
  
  setInputValue(String name, String value) => (querySelector("input[name=$name]") as InputElement).value = value;
  setSelectValue(String name, String value) => (querySelector("select[name=$name]") as SelectElement).value = value;

  onLoad() {}

  addHandler(String key, Handler handler) {
    _handlers[key] = handler;      

  }

  executeHandler(String key, bool validRequired, [String data]) {
    Handler handle = _handlers[key];
    if (handle != null) {
      if (validRequired && _inputValidator != null) {
        if (_inputValidator.isValid()) {
          handle(data);
        }
      }
      else {
        handle(data);
      }
    }
  }

  confirm(String message) {
    return window.confirm(message);
  }

  onSubmit(String selector, String handlerId) {
    querySelector(selector).onSubmit.listen((event) {
      event.preventDefault();
      executeHandler(handlerId, true);
    });
  }
  
  onChange(String selector, bool validRequired) {
    querySelectorAll(selector).forEach((elem) {
      elem.onChange.listen((event) {
        event.preventDefault();
        var element = event.target;
        executeHandler(element.name, validRequired);
      });
    });
  }
  
  onClick(String selector, bool validRequired) {
    querySelectorAll(selector).forEach((elem) {
      elem.onClick.listen((event) {
        event.preventDefault();
        var element = event.target;
        executeHandler(element.name, validRequired);
      });
    });
  }

  onLinkClick(String selector) {
    querySelector(selector).querySelectorAll("a").forEach((elem) {
      elem.onClick.listen((event) {
        event.preventDefault();
        AnchorElement anchor =  event.target;
        if (anchor.classes.isEmpty) {
          throw "onLinkClick needed handler";
        }
        var name = anchor.classes.first;
        executeHandler(name, false, anchor.href);
      });
    });
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
