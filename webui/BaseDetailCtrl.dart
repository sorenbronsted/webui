
part of webui;

class BaseDetailCtrl implements EventBusListener {
  BaseDetailView _view;
  String _name;
  
  BaseDetailCtrl(BaseDetailView this._view, String this._name) {
    _view.setViewName(_name);
    _view.addHandler("save", save);
    _view.addHandler("cancel", cancel);
  }

  BaseDetailView get view => _view;
  String get name => _name;
  
  void display(String event) {
    var url = Address.instance.current;
    var pattern = new RegExp("$_name/new");
    if (pattern.hasMatch(url)) {
      Future f = _view.show();
      f.then((result) {
        loadTypes(_view);
      });
    }
    else {
      pattern = new RegExp("$_name/\\w+\$");
      if (pattern.hasMatch(url)) {
        Future f = _view.show();
        f.then((_) {
          List<Future> futures = loadTypes(_view);
          assert(futures != null);
          var elements = url.split("/");
          var id = elements.last;
          Future.wait(futures).then((response) => load(id));
        });
      }
    }
  }

  List<Future> loadTypes(BaseDetailView view) {
    return new List();
  }
  
  void load(id) {
    Future f = Rest.instance.get("/rest/$_name/$id");
    f.then((data) {
      _view.populate(data);
    });
  }
  
  void save(String empty) {
    this._view.formHasChanged = false;

    Future post = Rest.instance.post("/rest/$_name", _view.formdata);
    post.then((Map postResult) {
      this._view.removeLeaveEvents();
      Address.instance.back();
    }).catchError((error) {
      this._view.formHasChanged = true;

      if (error is Map) {
        _view.showErrors(error);
      }
      else if (error is String){
        window.alert(error);
      }
      else {
        window.alert("Unknown error type");
      }
    });
  }
  
  void cancel(String empty) {
    this._view.removeLeaveEvents();
    this._view.formHasChanged = false;

    Address.instance.back();
  }

  @override
  void register(EventBus eventBus) {
    eventBus.listenOn(Address.eventAddressChanged, display);
  }
}
