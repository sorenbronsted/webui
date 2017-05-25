
part of webui;

class UiForm extends UiElement {
  View _view;

  UiForm(this._view, FormElement form) : super(form){
    if (cls == null) {
      throw new Exception("Form must have a data-class attribute");
    }

    form.querySelectorAll('input, textarea, select, div.text, div.list, span.text').forEach((HtmlElement elem) {
      var binding;
      switch(elem.runtimeType) {
        case InputElement:
          binding = new UiInput(elem, cls);
          break;
        case TextAreaElement:
          binding = new UiTextArea(elem, cls);
          break;
        case SelectElement:
          binding = new UiSelect(elem, cls);
          break;
        case DivElement:
        case SpanElement:
          if (elem.classes.contains('text')) {
            binding = new UiText(elem, cls);
          }
          else if (elem.classes.contains('list')) {
            binding = new UiList(elem, cls);
          }
          break;
      }
      if (binding != null) {
        _view._addBinding(binding);
      }
    });
  }

  bool isValid () {
    return _view.bindings.firstWhere((UiInputState input) => isValid == false, orElse: () => null) == null;
  }

  @override
  void update() {
    // Do nothing
  }
}
