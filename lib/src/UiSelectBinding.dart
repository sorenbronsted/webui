
part of webui;

class UiSelectBinding extends UiBinding {
  SelectElement _select;

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

  UiSelectBinding(SelectElement this._select) {
    if (_select == null) {
      throw "IllegalArgument: argument must not be null";
    }
  }

  void bind(View view) {
    _select.onChange.listen((event) => view.isDirty = true);
  }

  String read() {
    return _select.value;
  }

  void write(String value) {
    _select.value = value;
  }
}

