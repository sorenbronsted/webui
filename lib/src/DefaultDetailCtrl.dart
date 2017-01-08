
part of webui;

class DefaultDetailCtrl extends Controller {
  String _name;

  String get name => _name;

  DefaultDetailCtrl(View view) : super(view) {
    _name = (view as DefaultDetailView).name;
    view.addHandler("save", save);
    view.addHandler("cancel", cancel);
  }

  @override
  bool canRun() {
    var parts = Address.instance.pathParts;
    return (parts.length == 3 && parts[0] == 'detail' && parts[1] == _name);
  }

  @override
  void load() {
    var parts = Address.instance.pathParts;

    _store.remove(_name);
    if (parts.last == 'new') {
      _store.add({_name:{}});
      postLoad();
    }
    else {
      Rest.instance.get("/rest/$_name/${parts.last}").then((Map data) {
        _store.add(data);
        postLoad();
      });
    }
  }

  // On data load completion
  void postLoad() {}

  void save(String empty) {
    if (_store.isDirty == false) {
      Address.instance.back();
      return;
    }
    Map data = _store.getObject(_name);
    Rest.instance.post("/rest/$_name", data).then((Map postResult) {
      store.isDirty = false;
      super.stateChanged();
      Address.instance.back();
    }).catchError((error) {
      if (error is Map) {
        view.showErrors(error);
      }
      else if (error is String){
        window.alert(error);
      }
      else {
        window.alert("Unknown error type");
      }
    });
    store.isDirty = false;
  }
  
  void cancel(String empty) {
    var proceed = true;
    if (_store.isDirty) {
      proceed = view.confirm("Siden er blevet ændret. Dine ændringer kan blive tabt. Ønsker du at fortsætte?");
    }
    if (proceed) {
      store.isDirty = false;
      super.stateChanged();
      Address.instance.back();
    }
  }
}
