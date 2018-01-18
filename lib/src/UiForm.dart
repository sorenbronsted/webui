
part of webui;

class UiForm extends UiElement {
  ViewElement _view;
  List<UiInputElement> _elements = [];

  bool get isValid {
    var firstWhere = _elements.firstWhere((UiElement input) => input is UiInputElement && input.isValid == false, orElse: () => null);
    return firstWhere == null;
  }

  bool get isDirty {
    var firstWhere = _elements.firstWhere((UiElement input) => input is UiInputElement && input.isDirty, orElse: () => null);
    return firstWhere == null;
  }

  set values(Map map) {
    if (!_view.isVisible()) {
      return;
    }
    uid = map['uid'].toString();
    _elements.forEach((elem) {
      if (map.containsKey(elem.property)) {
        elem.value = map[elem.property];
      }
      else {
        elem.value = '';
      }
    });
  }
  
  UiForm(this._view, FormElement form) : super(form) {
    if (cls == null) {
      throw new Exception("Form must have a data-class attribute");
    }

    form.querySelectorAll('[data-property]').forEach((Element elem) {
      var binding;
      switch(elem.runtimeType) {
        case InputElement:
          binding = new UiInput(_view, elem, cls);
          break;
        case TextAreaElement:
          binding = new UiTextArea(_view, elem, cls);
          break;
        case SelectElement:
          binding = new UiSelect(_view, elem, cls);
          break;
        case DivElement:
        case SpanElement:
          if (elem.attributes['data-type'] == 'text') {
            binding = new UiText(_view, elem, cls);
          }
          else if (elem.attributes['data-type'] == 'list') {
            binding = new UiList(_view, elem, cls);
          }
          break;
      }
      if (binding != null) {
        _elements.add(binding);
      }
    });
  }

  String getElementName(HtmlElement element) => element.attributes['data-property'];

  String getElementValue(HtmlElement element) {
    UiInputElement input = _elements.firstWhere((UiElement elem) => elem.property == element.attributes['data-property'], orElse: () => null);
    if (input == null) {
      throw "Element not found: ${element.attributes['data-property']}";
    }
    return input.value;
  }

  @override
  void showError(Map fieldsWithError) {
    _elements.forEach((UiInputElement elem) => elem.showError(fieldsWithError));
  }
}
