part of webui;

class UiTab extends AnchorElement with UiBind implements ObjectStoreListener {
  static String uiTagName = 'x-tab';

  ObjectStore _store;

  UiTab.created() : super.created() {
    setBind(getAttribute('bind'));
  }

  void bind(ObjectStore store, View view) {
    _store = store;
    _store.addListener(this, _cls, _property);
    _store.addListener(this, 'Selected', 'group');
    _store.addListener(this, 'Selected', 'tab');

    onClick.listen((event) {
      event.preventDefault();
      Uri uri = Uri.parse(href);
      if (uri.pathSegments.isNotEmpty) {
        _store.setPropertyWithNofication('Selected', 'tab', _property);
        view.executeHandler('selected', false);
      }
    });
  }

  @override
  void valueChanged(String cls, String property) {
    var selected = _store.getProperty(cls, property);
    switch(property) {
      case 'tab':
        if (selected == _property) {
          parent.classes.add('active'); //TODO this is depends on bootstrap
        }
        else {
          parent.classes.remove('active'); //TODO this is depends on bootstrap
        }
        break;
      case 'group':
        if (selected == _cls) {
          parent.classes.remove('hidden'); //TODO this is depends on bootstrap
        }
        else {
          parent.classes.add('hidden'); //TODO this is depends on bootstrap
        }
        break;
      default:
        href = selected;
    }
  }
}