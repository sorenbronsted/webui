part of webui;

class UiText extends UiElement implements Observer {

	UiText(HtmlElement elem, [String cls]) : super(elem, cls);

	@override
	void update() {
		htmlElement.children.clear();
		htmlElement.appendText(Format.display(type, store.getProperty(cls, property, uid).toString(), format));
	}
}