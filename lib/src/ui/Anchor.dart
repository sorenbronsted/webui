part of webui;

class Anchor extends ElementWrapper {

  Anchor(View view, AnchorElement anchor, [String parentCls]) : super(view, anchor, parentCls) {
    _htmlElement.onClick.listen((event) {
      event.preventDefault();
      Uri uri = value;
      if (uri.pathSegments.isNotEmpty) {
        view.validateAndfire(view.eventClick, true, elementValue);
      }
    });
  }

  @override
  Object get value => Uri.parse(Uri.parse((_htmlElement as AnchorElement).href).fragment);

  @override
  void populate(Type type, Object object) {
    if (_cls != type.toString()) {
      return;
    }
    DataClass data = object;
    AnchorElement a = _htmlElement;
    a.href = '#${data.uid}';
  }
}
