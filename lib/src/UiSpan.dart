part of webui;

class UiSpan extends SpanElement with UiBind implements ObjectStoreListener {
	static String uiTagName = 'x-span';

  ObjectStore _store;
  String _uiType;
  String _format;

	UiSpan.created() : super.created() {
		setBind(getAttribute('bind'));
		_uiType = attributes['x-type'];
		_format = attributes['x-format'];
	}

	void bind(ObjectStore store, View view) {
		_store = store;
		_store.addListener(this, _cls, _property);
	}

	@override
	void valueChanged(String cls, [String property, String uid]) {
		children.clear();
		appendText(Format.display(_uiType, _store.getProperty(cls, property, uid), _format));
	}
}