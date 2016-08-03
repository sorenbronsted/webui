
part of webui;

class UiForm extends FormElement {
  static const String uiTagName = 'x-form';

  UiForm.created() : super.created();

  void bind(ObjectStore store, View view) {
    super.querySelectorAll('input, textarea, select').forEach((elem) {
      elem.bind(store, view);
    });
  }

  bool isValid () {
    var elements = super.querySelectorAll('input, textarea');
    elements.forEach((HtmlElement element) => (element as UiInputState).validate());
    return elements.firstWhere(
        (HtmlElement elem) => (elem as UiInputState).isValid == false, orElse: () => null) == null;
  }
}
