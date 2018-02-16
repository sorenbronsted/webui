part of webui;

abstract class ViewBase extends Subject {

	String eventPropertyChanged = 'PropertyChanged';
	String eventClick = 'Click';

	Set<String> get classes;
	bool get isVisible;

	void populate(Type sender, Object value);
}

class View extends ViewBase {

	DivElement _dom;
	DivElement _binding;
	List<ElementWrapper> _elements = [];

	View(String viewName, [String bindId = '#content']) {
		LinkElement htmlFragment = document.querySelector('#${viewName}Import');
		if (htmlFragment == null) {
			throw "#${viewName}Import not found";
		}
		_dom = htmlFragment.import.querySelector('#${viewName}');
		if (_dom == null) {
			throw "#${viewName} not found";
		}
		_binding = document.querySelector(bindId);
		if (_binding == null) {
			throw "${bindId} not found";
		}
		_bind();
	}

	@override
	Set<String> get classes {
		Set<String> result = new HashSet();
		_elements.forEach((ElementWrapper elem) => result.add(elem.cls));
		return result;
	}

  bool get isDirty {
		var first = _elements.firstWhere((ElementWrapper input) => input.isDirty, orElse: () => null);
		log.fine('isDirty: first: ${first}');
		return first != null;
	}

	bool get isValid {
		var first = _elements.firstWhere((ElementWrapper input) => !input.isValid, orElse: () => null);
		log.fine('isValid: first: ${first}');
		return first == null;
	}

	@override
	bool get isVisible => _binding.children.isNotEmpty && _binding.children.first == _dom;

	@override
	void populate(Type sender, Object value) {
		log.fine(('populate sender ${sender} isVisible ${isVisible}'));
		if (!isVisible) {
			return;
		}
		_elements.forEach((ElementWrapper element) {
			if (element.cls == sender.toString()) {
				element.value = value;
			}
		});
	}

	void show() {
		if (isVisible) {
			return;
		}
		_binding.children.clear();
		_binding.append(_dom);
	}

	void _bind() {
		_dom.querySelectorAll("form[data-class], table[data-class], button").forEach((Element elem) {
			ElementWrapper binding = ElementFactory.make(this, elem);
			_elements.add(binding);
		});
	}

  void showErrors(Object error) {
		if (error is Map) {
			Map fieldsWithError = error['ValidationException'];
			if (fieldsWithError == null) {
				return;
			}
			_elements.forEach((ElementWrapper element) => element.showError(fieldsWithError));
		}
		else if (error is String) {
			window.alert(error);
		}
	}

	void validateAndfire(String name, isValidRequired, [Object body]) {
		if (isValidRequired == true && isValid == false) {
			return;
		}
		super.fire(name, body);
	}
}

