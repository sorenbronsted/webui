part of webui;

class Anchor extends ElementWrapper {
  Anchor(View view, AnchorElement anchor, [String parentCls]) : super(view, anchor, parentCls) {
    _htmlElement.onClick.listen((event) {
      event.preventDefault();
      Uri uri = Uri.parse((_htmlElement as AnchorElement).href);
      if (uri.fragment.isNotEmpty) {
        view.validateAndfire(view.eventClick, true, uri);
      }
    });
  }

  @override
  set value(Object object) {
    (_htmlElement as AnchorElement).href = object;
  }
}
