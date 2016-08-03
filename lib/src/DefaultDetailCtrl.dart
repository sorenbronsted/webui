
part of webui;

class DefaultDetailCtrl extends Controller {
  String _name;

  DefaultDetailCtrl(View view) : super(view) {
    _name = (_view as DefaultDetailView).name;
    _view.addHandler("save", _save);
    _view.addHandler("cancel", _cancel);
  }

  @override
  bool canRun() {
    var parts = Address.instance.pathParts;
    return (parts.length == 3 && parts[0] == 'detail' && parts[1] == _name);
  }

  @override
  void load() {
    var parts = Address.instance.pathParts;

    if (parts.last == 'new') {
      _store.setMap(_name, {});
      postLoad();
    }
    else {
      Rest.instance.get("/rest/$_name/${parts.last}").then((Map data) {
        data.forEach((String name, Map properties) {
          _store.setMap(name, properties);
        });
        postLoad();
      });
    }
  }

  // On data load completion
  void postLoad() {}

  void _save(String empty) {
    if (_store.isDirty == false) {
      Address.instance.back();
      return;
    }
    Map data = _store.getMap(_name);
    Rest.instance.post("/rest/$_name", data).then((Map postResult) {
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
    if (_store.isDirty) {
      proceed = _view.confirm("Siden er blevet ændret. Dine ændringer kan blive tabt. Ønsker du at fortsætte?");
    }
    if (proceed) {
      Address.instance.back();
    }
  }
}
