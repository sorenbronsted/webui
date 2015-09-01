
part of webui;

class UiSelectBinding extends UiBinding {
  SelectElement _select;
  String _selector;

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

  UiSelectBinding(String this._selector);

  UiSelectBinding.byElement(SelectElement select) {
    _selector = 'select[name="${select.name}"]';
  }

  void bind(View view) {
    _select = querySelector(_selector);
    if (_select == null) {
      throw new SelectException("Select not found (selector $_selector)");
    }
    _select.onChange.listen((event) => view.isDirty = true);
  }

  String read() {
    return _select.value;
  }

  void write(String value) {
    _select.value = value;
  }
}

