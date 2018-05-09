part of webui;

class Text extends ElementWrapper {

	Text(View view, HtmlElement elem, [String cls]) : super(view, elem, cls);

	void populate(Type cls, Object value) {
		if (_cls != cls.toString()) {
			return;
		}

		if (value is! Map) {
			return;
		}
		Map values = value;

		_htmlElement.children.clear();
		_htmlElement.appendText(Format.display(_type, values[_property], _format));
	}
}