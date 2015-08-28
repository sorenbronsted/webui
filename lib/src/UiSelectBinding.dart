
part of webui;

class UiSelectBinding extends UiBinding {
  View _view;
  SelectElement _select;

  UiSelectBinding(View this._view, SelectElement this._select) {
    if (_select == null) {
      throw "IllegalArgument: argument must not be null";
    }
    _select.onChange.listen((event) => _view.isDirty = true);
  }

  set options(List<Map> data) {
    var options = new DocumentFragment();
    data.forEach((Map elem) {
      var option = new OptionElement();
      option.value = "${elem[elem.keys.elementAt(0)]}";
      option.appendText(elem[elem.keys.elementAt(1)]);
      options.append(option);
    });
    _select.children.clear();
    _select.append(options);
  }

  String read() {
    return _select.value;
  }

  void write(String value) {
    _select.value = value;
  }
}

