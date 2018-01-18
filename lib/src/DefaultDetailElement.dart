part of webui;

class DefaultDetailElement extends ViewElement {

	UiForm get form => _elements.where((UiElement elem) => elem is UiForm).first;
	void set values(Map data)  => form.values = data;

	DefaultDetailElement(String name, [String bindId = '#content']) : super(bindId, '${name}Detail');

	@override
	void bind(ViewElement view) {
		super.bind(view);
		if (_elements.where((UiElement elem) => (elem is UiForm)).length > 1) {
			throw "This view only support one form element";
		}

		try {
			bindButton(ViewElementEvent.Save, true);
			bindButton(ViewElementEvent.Cancel, false);
		}
		catch (e) {
			log.info(e);
		}
	}
}
