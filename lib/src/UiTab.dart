part of webui;

class UiTab extends UiElement implements Observer {

  UiTab(View view, AnchorElement anchor) : super(anchor){

    htmlElement.onClick.listen((event) {
      event.preventDefault();
      Uri uri = Uri.parse((htmlElement as AnchorElement).href);
      if (uri.pathSegments.isNotEmpty && view.isValid) {
        store.setProperty(this, 'Selected', 'tab', uid);
        view.executeHandler('selected', true);
      }
    });
  }

  @override
  void update() {
    //TODO this is depends on bootstrap
    if (cls == 'Selected' && property == 'tab') {
      var selectedUid = store.getProperty(cls, property);
      var selected = store.getObject('Tab', selectedUid);
      // Determined active tab
      if (selectedUid == uid || selected['group'] == uid) {
        htmlElement.parent.classes.add('active');
      }
      else {
        htmlElement.parent.classes.remove('active');
      }

      if (selectedUid == uid) {
        htmlElement.parent.classes.remove('hidden'); // ensure visible
      }
      else {
        var self = store.getObject('Tab', uid);
        if (selected['group'] == uid || selected['group'] == self['group']) { // Is selected and self in same group?
          htmlElement.parent.classes.remove('hidden');
        }
        else { // look at parent relationship
          var selectedParent = store.getObject('Tab', selected['group']);
          if (selectedParent != null &&
            selectedParent['group'] == self['group']) {
            htmlElement.parent.classes.remove('hidden');
          }
          else {
            htmlElement.parent.classes.add('hidden');
          }
        }
      }
    }
    else {
      var self = store.getObject('Tab', uid);
      (htmlElement as AnchorElement).href = self['url'];
    }
  }

  @override
  attach(ObjectStore store) {
    super.attach(store);
    store.attach(this, new Topic('Selected', 'tab'));
  }

  @override
  detach(ObjectStore store) {
    super.detach(store);
    store.detach(this, new Topic('Selected', 'tab'));
  }


}