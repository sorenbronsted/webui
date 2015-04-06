
library validator;

import 'dart:html';

part 'Validators.dart';

class InputValidator {
  List<InputElement> _fields;
  Validators _validators;

  Validators get validators => _validators;
  
  InputValidator(String selector, Validators this._validators) {
    assert(selector != null);
    _fields = new List();
    querySelectorAll(selector).forEach((InputElement elem) {
      if (elem.attributes.containsKey("readonly") || elem.attributes.containsKey("disabled")) {
        return;
      }
      _fields.add(elem);
      elem.onFocus.listen((event) {
        _reset(event.target);
      });
      elem.onBlur.listen((event) {
        _validate(event.target);
      });
    });
  }

  bool isValid() {
    _fields.forEach((InputElement elem) {
      if (elem.classes.contains("error") || elem.classes.contains("valid")) {
        return;
      }
      _validate(elem);
    });
    return !_fields.any((InputElement elem) => elem.classes.contains("error"));
  }

  _validate(Element elem) {
    if (elem.classes.contains("ignore")) {
      return;
    }
    Iterator i = elem.classes.iterator;
    while (i.moveNext()) {
      String item = i.current;
      Function validate = _validators.getMethod(item);
      if (validate != null) {
        try {
          validate(elem);
        }
        catch(e) {
          elem.title = e;
          elem.classes.add("error");
          break;
        }
      }
    }
    if (!elem.classes.contains("error")) {
      elem.classes.add("valid");
    }
  }

  _reset(elem) {
    elem.classes.remove("valid");
    elem.classes.remove("error");
    elem.title = "";
  }  
}
