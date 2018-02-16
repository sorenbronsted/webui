part of webui;

class UListListener {
  void onListRow(AnchorElement a, Map row) {}

  void onListHref(AnchorElement a, String cls, String uid) {
    a.href = "#${cls}/${uid}";
  }

  void onListText(AnchorElement a, String text) {
    a.text = text;
  }
}

class UList extends ContainerWrapper {
  UListListener _listener = new UListListener();

  set listener(UListListener listener) => _listener = listener;

  UList(View view, DivElement div, [String cls]) : super(view, div, cls);

  set value(Object value) {
    throw "Not Implemented";
/*
    htmlElement.children.clear();
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
        _view.handleEvent(UiViewElementEvent.Change, false, event, this);
      });
    });
    htmlElement.append(list);
    */
  }
}
