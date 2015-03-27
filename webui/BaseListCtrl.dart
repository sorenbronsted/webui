
part of webui;

class BaseListCtrl implements EventBusListener {

  BaseListView _view;
  String _name;
  
  BaseListCtrl(BaseListView this._view, String this._name) {
    _view.setViewName(_name);
    _view.addHandler("create", create);
    _view.addHandler("edit", edit);
    _view.addHandler("delete", delete);
    _view.addHandler("children", children);
    onInit(_view);
  }

  BaseListView get view => _view;
  String get name => _name;
  
  onInit(BaseListView view) {}
  
  display(String event) {
    var url = Address.instance.current;
    if (!url.endsWith("$_name")) {
      return;
    }
    Future f = _view.show();
    f.then((_) {
      populateView(_view, _name);
    });
  }
  
  populateView(BaseListView view, String urlPrefix) {}
  
  edit(String href) {
    var elements = href.split("#");
    if (elements.length > 1) {
      Address.instance.goto(elements[1]);
    }
  }
  
  delete(String href) {
    var answer = _view.confirm("Vil slette denne?");
    if (answer) {
      var tmp = href.split("#");
      var parts = tmp[1].split('/');
      if (parts.length >= 2) {
        var url = '/rest/${parts[parts.length-2]}/${parts[parts.length-1]}';
        Future f = Rest.instance.delete(url);
        f.then((data) {
          populateView(_view, _name);
        }).catchError((error) {
          if (error is String){
            window.alert(error);
          }
          else {
            window.alert("Unknown error type");
          }
        });
      }
    }
  }
  
  create(String empty) {
    var url = Address.instance.current;
    var parts = url.split("#");
    if (parts.length > 1) {
      Address.instance.goto("${parts[1]}/new");
    }
  }
  
  children(String href) {
    Address.instance.goto(href);
  }

  @override
  void register(EventBus eventBus) {
    eventBus.listenOn(Address.eventAddressChanged, display);
  }
}
