
part of webui;

class UiForm extends FormElement {
  static const String uiTagName = 'x-form';

  UiForm.created() : super.created();

  void bind(ObjectStore store, View view) {
    querySelectorAll('input, textarea, select').forEach((elem) {
      elem.bind(store, view);
    });
  }
}
