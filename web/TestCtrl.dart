part of webuiSample;

class TestCtrl extends Controller {

	//This list contains view with single componet test
	//Expand it as new components are made
	//Key is last part in the url and setup in main.html
	Map<String, View> _views = {
		'textarea': new TestView('TextAreaTest'),
		'select': new TestView('SelectTest'),
		'input': new TestView('InputTest'),
		'number': new TestView('InputNumberTest'),
		'radio': new TestView('InputRadioTest'),
		'checkbox': new TestView('InputCheckboxTest'),
		'selection': new TestView('InputCheckboxSelectionTest'),
		'file': new TestView('InputFileTest'),
		'list': new TestView('ListTest'),
	};

	TestCtrl() {
		_views.values.forEach((view) => addView(view));
	}

	@override
	void showViews() {
		var parts = Address.instance.pathParts;
		if (parts == null || parts.isEmpty) {
			return;
		}
		_views[parts.last].show(store);
	}

	@override
  bool canRun() {
		var parts = Address.instance.pathParts;
		if (parts == null || parts.isEmpty) {
			return false;
		}
    return parts.first == 'test';
  }

  @override
  void load() {
		store.add(this, [
			{'ZipCode' : {'uid':2100, 'name': 'København Ø'}},
			{'ZipCode' : {'uid':2300, 'name': 'København S'}},
			{'ZipCode' : {'uid':2500, 'name': 'Valby'}},
			{'ZipCode' : {'uid':7600, 'name': 'Struer'}},
		]);
  }
}