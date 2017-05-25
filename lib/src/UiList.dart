
part of webui;

class UiListListener {
  void onListRow(AnchorElement a, Map row) {}

  void onListHref(AnchorElement a, String cls, String uid) {
    a.href = "#${cls}/${uid}";
  }

  void onListText(AnchorElement a, String text) {
    a.text = text;
  }
}

class UiList extends UiElement implements Observer {
  UiListListener _listener = new UiListListener();

  set listener(UiListListener listener) => _listener = listener;

  UiList(DivElement div, [String cls]) : super(div, cls);

  @override
  void update() {
    htmlElement.children.clear();
    List<Map> values = _store.getObjects(cls);
    if (values.isEmpty) {
      return;
    }
    UListElement list = new UListElement();
    values.forEach((Map row) {
      LIElement li = new LIElement();
      list.append(li);
      var a = new AnchorElement();
      li.append(a);
      _listener.onListRow(a, row);
      _listener.onListHref(a, cls, row['uid']);
      _listener.onListText(a, row[property]);
      a.onClick.listen((event) {
        event.preventDefault();
        store.remove(this, cls, row['uid']);
      });
    });
    htmlElement.append(list);
  }
}
