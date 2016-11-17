
part of webui;

class UiForm extends FormElement with UiBind {
  static const String uiTagName = 'x-form';
  String _viewName;

  UiForm.created() : super.created() {
    setBind(getAttribute('bind'));
  }

  void bind(ObjectStore store, View view) {
    _viewName = view.viewName;
    super.querySelectorAll('#${_viewName} input, #${_viewName} textarea, #${_viewName} select').forEach((elem) {
      elem.bind(store, view);
    });
  }

  bool isValid () {
    var elements = super.querySelectorAll('#${_viewName} input, #${_viewName} textarea');
    elements.forEach((HtmlElement element) => (element as UiInputState).validate());
    return elements.firstWhere((HtmlElement elem) => (elem as UiInputState).isValid == false, orElse: () => null) == null;
  }
}
