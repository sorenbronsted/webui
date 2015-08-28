
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
    var url = Address.instance.current;
    if (!url.endsWith("$_name")) {
      return;
    }
    _view.show().then((_) {
      populateView(_view, _name);
    });
  }
  
  populateView(DefaultListView view, String urlPrefix) {}
  
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
      if (parts.length >= 2) {
        var url = '/rest/${parts[parts.length-2]}/${parts[parts.length-1]}';
        Rest.instance.delete(url).then((data) {
          populateView(_view, _name);
        }).catchError((String error) {
          window.alert(error);
        });
      }
    }
  }
  
  _create(String empty) {
    var url = Address.instance.current;
    var parts = url.split("#");
    if (parts.length > 1) {
      Address.instance.goto("${parts[1]}/new");
    }
  }
  
  _children(String href) {
    Address.instance.goto(href);
  }
}
