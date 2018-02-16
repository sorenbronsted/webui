part of webui;

class Button extends ElementWrapper {

	Button(View view, ButtonElement button, [String cls]) : super(view, button, cls) {
		if (button.name == null || button.name.isEmpty) {
			throw "Button must have name";
		}
		_htmlElement.attributes['data-property'] = button.name;
		button.onClick.listen((Event event) {
			event.preventDefault();
			view.validateAndfire(_view.eventClick, true, elementValue);
		});
	}

  set value(Object object) 	{
		if (object is Map) {
			uid = object['uid'];
		}
	}
}