part of webui;

class Text extends ElementWrapper {

	Text(View view, HtmlElement elem, [String cls]) : super(view, elem, cls);

	set value(Object value) {
		_htmlElement.children.clear();
		_htmlElement.appendText(Format.display(type, value, format));
	}
}