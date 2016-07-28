
part of webui;

class DefaultListCtrl extends Controller {
  String _name;

  DefaultListCtrl(View view) : super(view) {
    _name = (view as DefaultListView).name;
    view.addHandler("create", _create);
    view.addHandler("edit", _edit);
    view.addHandler("delete", _delete);
    view.addHandler("children", _children);
  }

  @override
  bool canRun() {
    var parts = Address.instance.pathParts;
    return (parts[0] == 'list' && parts[1] == _name);
  }

  void load() {
    Rest.instance.get('/rest/${_name}').then((data) {
      _store.set('${_name}Table', data);
      postLoad();
    });
  }

  void postLoad() {}

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
          load();
        }).catchError((String error) {
          window.alert(error);
        });
      }
    }
  }
  
  _create(String empty) {
    var parts = Address.instance.pathParts;
    if (parts.length == 2) {
      var url = new StringBuffer("detail/${parts[1]}/new");
      var params = Address.instance.current.split('?');
      if (params.length == 2) {
        url.write('?');
        url.write(params[1]);
      }
      Address.instance.goto(url.toString());
    }
  }
  
  _children(String href) {
    Address.instance.goto(href);
  }
}
