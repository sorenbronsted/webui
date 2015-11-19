
part of webui;

class DefaultDetailCtrl extends Controller {
  String _name;

  DefaultDetailCtrl(View view, String this._name) : super(view) {
    (_view as DefaultDetailView).name = _name;
    _view.addHandler("save", _save);
    _view.addHandler("cancel", _cancel);
  }

  String get name => _name;

  @override
  bool canRun() {
    var parts = Address.instance.pathParts;
    return (parts.length == 3 && parts[0] == 'detail' && parts[1] == _name);
  }

  @override
  void load() {
    var parts = Address.instance.pathParts;

    if (parts.last == 'new') {
      postLoad();
    }
    else {
      Rest.instance.get("/rest/$_name/${parts.last}").then((data) {
        (_view as DefaultDetailView).formdata = data;
        postLoad();
      });
    }
  }

  // On data load completion
  void postLoad() {}

  void _save(String empty) {
    Rest.instance.post("/rest/$_name", (_view as DefaultDetailView).formdata[_name]).then((Map postResult) {
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
  
  void _cancel(String empty) {
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
