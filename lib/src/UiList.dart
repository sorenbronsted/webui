
part of webui;

class UiList extends DivElement implements ObjectStoreListener {
  static const String uiTagName = 'x-list';

  String _name;
  View _view;

  UiList.created() : super.created() {
    _name = attributes['name'];
  }

  void bind(ObjectStore store, View view) {
    store.addListener(_name, this);
    _view = view;
  }

  void valueChanged(String nameValue, List<Map> values) {
    children.clear();
    if (values.isEmpty) {
      return;
    }
    values.forEach((Map value) {
      var a = new AnchorElement(href : '${_name}/${value['uid']}');
      a.appendText('${value['text']}');
      children.add(a);
      a.onClick.listen((event) {
        event.preventDefault();
        //TODO modify store instead
        _view.executeHandler(_name, false, a.href);
      });
    });
  }
}
