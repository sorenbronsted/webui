part of webui;

class CurrentViewState extends Proxy {
	bool _isDirty = false;
	bool _isValid = true;
	String _currentView;

	bool get isDirty => _isDirty;
	bool get isValid => _isValid;
	String get currentView => _currentView;

  @override
  void read([int uid]) {} // Do nothing, because this is not server based

  @override
  void setProperty(ElementValue elem) {
  	log.fine('setProperty: ${elem}');
  	switch (elem.property) {
			case 'currentView':
				if (_currentView != elem.value) { // Change of view results in state reset
					_currentView = elem.value;
					_isDirty = false;
					_isValid = true;
				}
				break;
			case 'isDirty':
				_isDirty = elem.value;
				break;
			case 'isValid':
				_isValid = elem.value;
				break;
			default:
				throw "Unknown property ${elem.property}";
		}
  }
}

abstract class ViewBase extends Subject {
	Logger log;

	bool _isDirty = false;
	bool _isValid = true;

	String get eventPropertyChanged => '${runtimeType}/PropertyChanged';
	String get eventClick => '${runtimeType}/Click';

	Set<String> get classes;
	Set<String> get dataLists;

	bool get isDirty => _isDirty;
	bool get isValid => _isValid;

	set isDirty(bool state) {
		_isDirty = state;
		fire(eventPropertyChanged, new ElementValue('${CurrentViewState}', 'isDirty', null, _isDirty));
	}

	set isValid(bool state) {
		_isValid = state;
		fire(eventPropertyChanged, new ElementValue('${CurrentViewState}', 'isValid', null, _isValid));
	}

	ViewBase() {
		log = new Logger(runtimeType.toString());
	}

	void populate(Type sender, Object value);
}

class View extends ViewBase {

	DataClassWrapper _root; // root entry point for bindings
	DivElement _binding; // where to attch _root
	String _viewName; // name of view used when load or queried

	View(this._viewName, [String bindId = '#content']) {
		log.fine('View importing ${_viewName}');
		LinkElement htmlFragment = document.querySelector('#${_viewName}Import');
		if (htmlFragment == null) {
			throw "#${_viewName}Import not found";
		}
		DivElement dom = htmlFragment.import.querySelector('#${_viewName}');
		if (dom == null) {
			throw "#${_viewName} not found";
		}
		_binding = document.querySelector(bindId);
		if (_binding == null) {
			throw "${bindId} not found";
		}
		_root = new DataClassWrapper(this, dom);
		onInit(dom);
	}

	View.bind(this._viewName) {
		log.fine('View binding ${_viewName}');
		DivElement dom = querySelector('#${_viewName}');
		if (dom == null) {
			throw "#${_viewName} not found";
		}
		_root = new DataClassWrapper(this, dom);
	}

	void onInit(DivElement div) {}

	@override
	Set<String> get classes => _root.collectClasses(new HashSet());

	@override
	Set<String> get dataLists => _root.collectDataLists(new HashSet());

	bool get _isVisible {
		if (_binding == null) { // When view.bind contruct is used it is allways null
			return true;
		}
		return _binding.children.isNotEmpty && _binding.children.first == _root._htmlElement;
	}

	@override
	void populate(Type sender, Object value) {
		log.fine(('populate sender ${sender} isVisible ${_isVisible}'));
		if (!_isVisible) {
			return;
		}
		_root.populate(sender, value);
	}

	void show() {
		if (_isVisible) {
			return;
		}
		_binding.children.clear();
		_binding.append(_root._htmlElement);
		fire(eventPropertyChanged, new ElementValue('${CurrentViewState}', 'currentView', null, _viewName));
	}

  void showErrors(Object error) {
		if (error is Map) {
			Map fieldsWithError = error['ValidationException'];
			if (fieldsWithError == null) {
				return;
			}
			_root.showError(fieldsWithError);
			isValid = false;
			isDirty = true;
		}
		else if (error is String) {
			window.alert(error);
		}
	}

	void validateAndfire(String eventName, isValidRequired, [Object body]) {
		log.fine('validateAndfire: eventName: ${eventName}, isValidRequired: ${isValidRequired} isValid: ${isValid}');
		if (isValidRequired == true && isValid == false) {
			return;
		}
		super.fire(eventName, body);
	}
}
