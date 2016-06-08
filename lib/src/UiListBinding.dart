
part of webui;

class UiListListener {
  void onListRow(AnchorElement a) {}

  void onListHref(AnchorElement a, Map row) {
    if (!row.containsKey('class')) {
      throw "Must have class key in rows";
    }
    if (!row.containsKey('uid')) {
      throw "Must have uid key in rows";
    }
    a.href = "#${row['class']}/${row['uid']}";
  }

  void onListText(AnchorElement a, Map row) {
    var key = null;
    ['name', 'text', 'value'].forEach((name) {
      if (row.containsKey(name)) {
        key = name;
      }
    });
    if (key == null) {
      throw "Must have either name, text or value key in rows";
    }
    a.text = '${row[key]}';
  }
}

class UiListBinding implements UiBinding {
  String _selector;
  DivElement _list;
  View _view;
  List _rows;
  UiListListener _listener;

  UiListBinding(String this._selector, [UiListListener listener]) {
    if (listener == null) {
      _listener = new UiListListener();
    }
    else {
      _listener = listener;
    }
  }

  @override
  void bind(View view) {
    _list = querySelector(_selector);
    if (_list == null) {
      throw new SelectorException("Div not found (selector $_selector)");
    }
    _view = view;
  }

  @override
  List read() {
    return _rows;
  }

  @override
  void write(List rows) {
    _list.children.clear();
    if (rows.isEmpty) {
      return;
    }
    _rows = rows;

    rows.forEach((Map row) {
      var a = new AnchorElement();
      _listener.onListRow(a);
      _listener.onListHref(a, row);
      _listener.onListText(a, row);
      a.onClick.listen((event) {
        event.preventDefault();
        _view.executeHandler(_list.id, false, a.href);
      });
      _list.append(a);
    });
  }
}