part of webui;

class UList extends ContainerWrapper {

	UList(View view, UListElement ulist, [String cls]) : super(view, ulist, cls) {
		ulist.querySelectorAll('[data-property]').forEach(
				(Element element) => _elements.add(ElementFactory.make(view, element, _cls))
		);
	}

	@override
	void populate(Type sender, Object object) {
		if (object is! Iterable) {
			return;
		}

		(object as Iterable).forEach((DataClass data) {
			_elements.forEach((ElementWrapper element) {
				element.populate(sender, data);
			});
		});
	}
}
