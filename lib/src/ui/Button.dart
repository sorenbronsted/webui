part of webui;

class Button extends ElementWrapper {

	Button(View view, ButtonElement button, [String cls]) : super(view, button, cls) {
		if (button.name == null || button.name.isEmpty) {
			throw "Button must have name";
		}
		bool validate = true;
		if (button.attributes.containsKey('data-validate')) {
			validate = button.attributes['data-validate'].toLowerCase() != 'false';
		}
		_property = button.name;
		button.onClick.listen((Event event) {
			event.preventDefault();
			view.validateAndfire(_property, validate, elementValue);
		});
	}

  void populate(Type sender, Object object) 	{
		if (_cls != sender.toString()) {
			return;
		}
		if (object is DataClass) {
			_uid = object.uid;
		}
	}
}