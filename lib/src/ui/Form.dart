part of webui;

class Form extends ContainerWrapper {

  Form(View view, FormElement form) : super(view, form);

  @override
  bool get isDirty {
    var first = _elements.firstWhere((ElementWrapper input) => input.isDirty, orElse: () => null);
    _log.fine('isDirty: first: ${first}');
    return first != null;
  }

  @override
  bool get isValid {
    var first = _elements.firstWhere((ElementWrapper input) => !input.isValid, orElse: () => null);
    _log.fine('isValid: first: ${first}');
    return first == null;
  }

  set value(Object value) {
    Map map = value;
    _elements.forEach((ElementWrapper elem) {
      elem.uid = map['uid'];
      if (map.containsKey(elem.property)) {
        elem.value = map[elem.property];
      }
      else {
        elem.value = '';
      }
    });
  }

  void showError(Object error) {
    Map map = error;
    _elements.forEach((ElementWrapper elem) {
      if (elem.cls == map['class']) {
        elem.showError(map[elem.property]);
      }
    });
  }
}
