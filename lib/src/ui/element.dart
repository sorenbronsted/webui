part of webui;

class ElementValue {
	String cls;
	String property;
	int uid;
	String value;

	ElementValue(this.cls, this.property, this.uid, this.value);

	@override
	String toString() => 'cls: ${cls}, property: ${property}, uid: ${uid}, value: ${value}';
}

abstract class ElementWrapper {
	Logger _log;
	String _cls;
	int _uid;
	HtmlElement _htmlElement;
	ViewBase _view;

	ElementWrapper(this._view, this._htmlElement, [this._cls]) {
		_log = new Logger(runtimeType.toString());
	}

	ElementValue get elementValue => new ElementValue(cls, property, uid, value);

	String get cls => _htmlElement.attributes.containsKey('data-class') ? _htmlElement.attributes['data-class'] : _cls;

	String get property => _htmlElement.attributes['data-property'];

	int get uid => _uid;

	String get link => _htmlElement.attributes['data-link'];

	String get type => _htmlElement.attributes['data-type'];

	String get format => _htmlElement.attributes['data-format'];

	bool get isDirty => false;

	bool get isValid => true;

	Object get value => null;

	set uid(int uid) => _uid = uid;

	set value(Object object);

	void showError(Object error) {}

 	@override
	String toString() =>{'cls':cls,'property':property,'uid':uid,'type':_htmlElement.runtimeType}.toString();
}

abstract class ContainerWrapper extends ElementWrapper {
	List<ElementWrapper> _elements = [];

	ContainerWrapper(View view, HtmlElement root, [String parentCls]) : super(view, root, parentCls) {
		root.querySelectorAll('[data-property]').forEach((Element element) {
			ElementWrapper ew = ElementFactory.make(view, element, cls);
			_elements.add(ew);
		});
	}
}