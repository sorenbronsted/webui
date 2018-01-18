part of webui;

class UiText extends UiElement {

	UiText(ViewElement view, HtmlElement elem, [String cls]) : super(elem, cls);

	set value(String value) {
		htmlElement.children.clear();
		htmlElement.appendText(Format.display(type, value, format));
	}

  @override
  void showError(Map fieldsWithError) {
    // Do nothing
  }
}