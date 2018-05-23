part of webui;

class Text extends ElementWrapper {

	Text(View view, HtmlElement elem, [String cls]) : super(view, elem, cls);

	void populate(Type sender, Object value) {
		if (_cls != sender.toString()) {
			return;
		}

		if (value is! DataClass) {
			return;
		}
		DataClass values = value;

		_htmlElement.children.clear();
		_htmlElement.appendText(Format.display(_type, values.get(_property), _format));
	}
}