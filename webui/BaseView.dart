
library webui;

import 'dart:async';
import 'dart:html';
import 'InputValidator.dart';
import 'Rest.dart';
import 'EventBus.dart';
import 'Formatter.dart';
import 'Address.dart';

part 'UiHelper.dart';
part 'BaseListView.dart';
part 'BaseListCtrl.dart';
part 'BaseDetailView.dart';
part 'BaseDetailCtrl.dart';

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
  
  onChange(String selector, String handlerId) {
    querySelector(selector).onChange.listen((event) {
      String data;
      event.preventDefault();
      Handler handle = _handlers[handlerId];
      handle(data);
      //executeHandler(handlerId, true);
    });
  }
  
  onClick(String selector, bool validRequired) {
    querySelectorAll(selector).forEach((elem){
      elem.onClick.listen((event) {
        event.preventDefault();
        InputElement element = event.target;
        executeHandler(element.name, validRequired);
      });
    });
  }

  onLinkClick(String selector) {
    querySelector(selector).querySelectorAll("a").forEach((elem) {
      elem.onClick.listen((event) {
        event.preventDefault();
        AnchorElement anchor =  event.target;
        var name = '';
        String classes = anchor.attributes['class'];
        if (classes.contains('edit')) {
          name = 'edit';
        }
        if (classes.contains('delete')) {
          name = 'delete';
        }
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
