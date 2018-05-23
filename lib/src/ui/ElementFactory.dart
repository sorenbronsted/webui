part of webui;

class ElementFactory {

	static Map<Type, Function> _makers = {
		FormElement: _form,
		TableElement: _table,
		DivElement: _div,
		UListElement: _list,
		InputElement: _input,
		SelectElement: _select,
		SpanElement: _text,
		TextAreaElement: _textarea,
		ButtonElement: _button,
		TableCellElement: _th,
		AnchorElement: _anchor,
	};

	static ElementWrapper make(View view, HtmlElement element, [String parentCls]) {
		Function maker = _makers[element.runtimeType];
		if (maker == null) {
			throw "Factory method for type ${element.runtimeType} not found";
		}
		return maker(view, element, parentCls);
	}

	// Containers
	static ElementWrapper _form(View view, HtmlElement element, [String parentCls]) {
		return new DataPropertyContainer(view, element);
	}

	static ElementWrapper _table(View view, HtmlElement element, [String parentCls]) {
		return new Table(view, element);
	}

	static ElementWrapper _div(View view, HtmlElement element, [String parentCls]) {
		return new DataPropertyContainer(view, element);
	}

	static ElementWrapper _list(View view, HtmlElement element, [String parentCls]) {
		return new UList(view, element);
	}

	// Elements
	static ElementWrapper _input(View view, HtmlElement element, [String parentCls]) {
		return new Input(view, element, parentCls);
	}

	static ElementWrapper _button(View view, HtmlElement element, [String parentCls]) {
		return new Button(view, element, parentCls);
	}

	static ElementWrapper _select(View view, HtmlElement element, [String parentCls]) {
		return new Select(view, element, parentCls);
	}

	static ElementWrapper _text(View view, HtmlElement element, [String parentCls]) {
		return new Text(view, element, parentCls);
	}

	static ElementWrapper _textarea(View view, HtmlElement element, [String parentCls]) {
		return new TextArea(view, element, parentCls);
	}

	static ElementWrapper _th(View view, HtmlElement element, [String parentCls]) {
		return new Th(view, element, parentCls);
	}

	static ElementWrapper _anchor(View view, HtmlElement element, [String parentCls]) {
		return new Anchor(view, element, parentCls);
	}
}
