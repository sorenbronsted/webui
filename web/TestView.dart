part of webuiSample;

class TestView extends View {
	UiForm _uiForm;

	TestView(String name) : super('#content', name);

	@override
	void bind(DivElement dom) {
		FormElement form = dom.querySelector('form');
		_uiForm = new UiForm(this, form);
	}

	@override
	bool get isValid {
		return _uiForm.isValid();
	}
}

