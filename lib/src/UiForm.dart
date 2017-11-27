
part of webui;

class UiForm extends UiElement {
  View _view;

  UiForm(this._view, FormElement form) : super(form){
    if (cls == null) {
      throw new Exception("Form must have a data-class attribute");
    }

    form.querySelectorAll('input, textarea, select, div.text, div.list, span.text').forEach((Element elem) {
      var binding;
      if (elem.runtimeType == InputElement) {
        binding = new UiInput(elem, cls);
      }
      else if (elem.runtimeType == TextAreaElement) {
        binding = new UiTextArea(elem, cls);
      }
      else if (elem.runtimeType == SelectElement) {
        binding = new UiSelect(elem, cls);
      }
      else if (elem.runtimeType == DivElement || elem.runtimeType == SpanElement) {
        if (elem.classes.contains('text')) {
          binding = new UiText(elem, cls);
        }
        else if (elem.classes.contains('list')) {
          binding = new UiList(elem, cls);
        }
      }
      if (binding != null) {
        _view._addBinding(binding);
      }
    });
  }

  bool isValid () {
    var firstWhere = _view.bindings.firstWhere((UiElement input) => (input as UiInputState).isValid == false, orElse: () => null);
    return firstWhere == null;
  }

  @override
  void update() {
    // Do nothing
  }
}
