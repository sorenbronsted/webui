part of webui;

class RootWrapper extends ContainerWrapper {
  RootWrapper(View view, DivElement root) : super(view, root) {
    root.querySelectorAll('form[data-class], table[data-class], div[data-class], button[data-class]').forEach((Element elem) {
      ElementWrapper binding = ElementFactory.make(view, elem);
      _elements.add(binding);
    });
  }
}
