part of webui;

class Anchor extends ElementWrapper {

	static AnchorCss _css = new AnchorCss();

	static set css(AnchorCss css) => _css = css;

	@override
	Object get value => Uri.parse((_htmlElement as AnchorElement).href).fragment;

	Anchor(View view, AnchorElement anchor, [String parentCls]) : super(view, anchor, parentCls) {
    _htmlElement.onClick.listen((event) {
      event.preventDefault();
      if ((value as String).isNotEmpty) {
        view.validateAndfire(view.eventClick, true, elementValue);
      }
    });
  }

  @override
  void populate(Type sender, Object object) {
    if (_cls != sender.toString()) {
      return;
    }
    DataClass data = object;
    var value = data.get(_property);
    if (value == null) {
    	return;
		}
		_uid = data.uid;
		(_htmlElement as AnchorElement).href = value;

    if (_htmlElement.attributes['data-type'] == 'tab') {
			_css.setNotActive(_htmlElement);
			if (data.get('active') == 'true') {
				_css.setActive(_htmlElement);
			}
		}
  }
}

class AnchorCss {
  void setNotActive(HtmlElement element) {
		element.classes.remove('active');
	}

  void setActive(HtmlElement element) {
		element.classes.add('active');
	}
}

class AnchorCssBootStrap implements AnchorCss {

  @override
  void setActive(HtmlElement element) {
		element.parent.classes.add('active');
  }

  @override
  void setNotActive(HtmlElement element) {
		element.parent.classes.remove('active');
  }
}