part of webui;

class ElementValue {
	String cls;
	String property;
	int uid;
	Object value;

	ElementValue(this.cls, this.property, this.uid, this.value);

	@override
	String toString() => 'cls: ${cls}, property: ${property}, uid: ${uid}, value: ${value}';
}

abstract class ElementWrapper {
	Logger _log;
	String _cls;
	String _property;
	String _type;
	String _format;
	int _uid;
	HtmlElement _htmlElement;
	ViewBase _view;

	ElementWrapper(this._view, this._htmlElement, [String parentCls]) {
		_log = new Logger(runtimeType.toString());
		_uid = _htmlElement.attributes.containsKey('data-uid') ? int.parse(_htmlElement.attributes['data-uid']) : null;
		_cls = _htmlElement.attributes.containsKey('data-class') ? _htmlElement.attributes['data-class'] : parentCls;
		_property = _htmlElement.attributes['data-property'];
		_type = _htmlElement.attributes['data-type'];
		_format = _htmlElement.attributes['data-format'];
	}

	ElementValue get elementValue => new ElementValue(_cls, _property, uid, value);

	int get uid => _uid;

	bool get isDirty => false;

	bool get isValid => true;

	Object get value => null;

	set uid(int uid) => _uid = uid;

	void populate(Type type, Object object);

	void showError(Map namedErrors) {}

 	@override
	String toString() =>{'cls':_cls,'property':_property,'uid':uid,'type':_htmlElement.runtimeType}.toString();

	Set<String> collectClasses(Set<String> result) {
		if (_cls != null) {
			result.add(_cls);
		}
		return result;
	}

  Set<String> collectDataLists(Set<String> result) => result;
}

abstract class ContainerWrapper extends ElementWrapper {
	List<ElementWrapper> _elements = [];

	ContainerWrapper(View view, HtmlElement root, [String parentCls]) : super(view, root, parentCls);

	@override
	void populate(Type type, Object object) {
		_elements.forEach((ElementWrapper elem) => elem.populate(type, object));
	}

	@override
	bool get isDirty {
		var first = _elements.firstWhere((ElementWrapper input) => input.isDirty, orElse: () => null);
		_log.fine('isDirty: first: ${first != null}');
		return first != null;
	}

	@override
	bool get isValid {
		var first = _elements.firstWhere((ElementWrapper input) => !input.isValid, orElse: () => null);
		_log.fine('isValid: first: ${first != null}');
		return first != null;
	}

	@override
	Set<String> collectClasses(Set<String> result) {
		_elements.forEach((ElementWrapper elem) => elem.collectClasses(result));
		return result;
	}

	@override
	Set<String> collectDataLists(Set<String> result) {
		_elements.forEach((ElementWrapper elem) => elem.collectDataLists(result));
		return result;
	}

	@override
	void showError(Map namedErrors) {
		_elements.forEach((ElementWrapper element) => element.showError(namedErrors));
	}
}