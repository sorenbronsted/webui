
part of webui;

class DefaultListCtrl extends Controller {

  DefaultListView _view;
  String _name;
  
  DefaultListCtrl(DefaultListView this._view, String this._name) {
    _view.name = _name;
    _view.addHandler("create", _create);
    _view.addHandler("edit", _edit);
    _view.addHandler("delete", _delete);
    _view.addHandler("children", _children);
  }

  DefaultListView get view => _view;

  run(String event) {
    var parts = Address.instance.pathParts;
    if (!(parts[0] == 'list' && parts[1] == _name)) {
      return;
    }

    _view.show().then((_) {
      List<Future> futures = preLoad();
      assert(futures != null);
      Future.wait(futures).then((_) => _load());
    });
  }

  List<Future> preLoad() => [];

  void postLoad() {}

  void _load() {
    Rest.instance.get('/rest/${_name}').then((data) {
      view.populate(data);
      postLoad();
    });
  }

  _edit(String href) {
    var elements = href.split("#");
    if (elements.length > 1) {
      Address.instance.goto(elements[1]);
    }
  }
  
  _delete(String href) {
    var answer = _view.confirm("Vil slette denne?");
    if (answer) {
      var tmp = href.split("#");
      var parts = tmp[1].split('/');
      if (parts.length == 2) {
        var url = '/rest/${parts[0]}/${parts[1]}';
        Rest.instance.delete(url).then((data) {
          postLoad();
        }).catchError((String error) {
          window.alert(error);
        });
      }
    }
  }
  
  _create(String empty) {
    var parts = Address.instance.pathParts;
    if (parts.length == 2) {
      Address.instance.goto("detail/${parts[1]}/new");
    }
  }
  
  _children(String href) {
    Address.instance.goto(href);
  }
}
