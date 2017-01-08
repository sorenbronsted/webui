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
    _store.addListener(this, 'Selected', 'tab');

    onClick.listen((event) {
      event.preventDefault();
      Uri uri = Uri.parse(href);
      if (uri.pathSegments.isNotEmpty && view.isValid) {
        _store.setProperty('Selected', 'tab', _uid);
        view.executeHandler('selected', true);
      }
    });
  }

  @override
  void valueChanged(String cls, [String property, String uid]) {
    //TODO this is depends on bootstrap
    if (cls == 'Selected' && property == 'tab') {
      var selectedUid = _store.getProperty(cls, property);
      var selected = _store.getObject('Tab', selectedUid);
      // Determined active tab
      if (selectedUid == _uid || selected['group'] == _uid) {
        parent.classes.add('active');
      }
      else {
        parent.classes.remove('active');
      }

      if (selectedUid == _uid) {
        parent.classes.remove('hidden'); // ensure visible
      }
      else {
        var self = _store.getObject('Tab', _uid);
        if (selected['group'] == _uid || selected['group'] == self['group']) { // Is selected and self in same group?
          parent.classes.remove('hidden');
        }
        else { // look at parent relationship
          var selectedParent = _store.getObject('Tab', selected['group']);
          if (selectedParent != null &&
            selectedParent['group'] == self['group']) {
            parent.classes.remove('hidden');
          }
          else {
            parent.classes.add('hidden');
          }
        }
      }
    }
    else if (uid == _uid) {
      var self = _store.getObject('Tab', _uid);
      href = self['url'];
    }
  }
}