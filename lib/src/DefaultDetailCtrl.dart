
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
    _view.show().then((_) {
      List<Future> futures = preLoad();
      assert(futures != null);
      Future.wait(futures).then((_) => _load());
    });
  }

  List<Future> preLoad() {
    return [];
  }

  void postLoad() {}

  void _load() {
    var parts = Address.instance.pathParts;

    if (parts.last == 'new') {
      postLoad();
    }
    else {
      Rest.instance.get("/rest/$_name/${parts.last}").then((data) {
        _view.formdata = data;
        postLoad();
      });
    }
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
