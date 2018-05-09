part of webui;

class PropertyContainer extends ContainerWrapper {

  PropertyContainer(View view, HtmlElement root) : super(view, root) {
    root.querySelectorAll('[data-property], button').forEach((Element element) {
      ElementWrapper ew = ElementFactory.make(view, element, _cls);
      _elements.add(ew);
    });
  }
}
