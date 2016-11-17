
part of webui;

class UiList extends DivElement with UiBind implements ObjectStoreListener {
  static const String uiTagName = 'x-list';

  View _view;

  UiList.created() : super.created() {
    setBind(getAttribute('bind'));
  }

  void bind(ObjectStore store, View view) {
    store.addListener(this, _cls);
    _view = view;
  }

  void valueChanged(String name, String property) {
    children.clear();
    List<Map> values = _view.store.getObjects(name);
    if (values.isEmpty) {
      return;
    }
    values.forEach((Map value) {
      var a = new AnchorElement();
      a.appendText('${value['text']}'); //TODO must read from html tag
      children.add(a);
      a.onClick.listen((event) {
        event.preventDefault();
        _view.store.remove(_cls, value['uid']);
      });
    });
  }
}
