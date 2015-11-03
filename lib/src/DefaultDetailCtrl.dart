
part of webui;

class DefaultDetailCtrl extends Controller {
  DefaultDetailView _view;
  String _name;
  
  DefaultDetailCtrl(DefaultDetailView this._view, String this._name) {
    _view.name = _name;
    _view.addHandler("save", save);
    _view.addHandler("cancel", cancel);
  }

  DefaultDetailView get view => _view;
  String get name => _name;
  
  void run(String event) {
    var parts = Address.instance.pathParts;
    if (!(parts.length == 3 && parts[0] == 'detail' && parts[1] == _name)) {
      return;
    }

    if (parts.last == 'new') {
      _view.show().then((result) {
        loadTypes(_view);
      });
    }
    else {
      _view.show().then((_) {
        List<Future> futures = loadTypes(_view);
        assert(futures != null);
        var id = parts.last;
        Future.wait(futures).then((response) => load(id));
      });
    }
  }

  List<Future> loadTypes(DefaultDetailView view) {
    return new List();
  }
  
  void load(id) {
    Rest.instance.get("/rest/$_name/$id").then((data) {
      _view.formdata = data;
    });
  }
  
  void save(String empty) {
    Rest.instance.post("/rest/$_name", _view.formdata).then((Map postResult) {
      _view.isDirty = false;
      Address.instance.back();
    }).catchError((error) {
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
    var proceed = true;
    if (_view.isDirty) {
      proceed = _view.confirm("Siden er blevet ændret. Dine ændringer kan blive tabt. Ønsker du at fortsætte?");
    }
    if (proceed) {
      _view.isDirty = false;
      Address.instance.back();
    }
  }
}
