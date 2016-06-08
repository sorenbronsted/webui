
part of webui;

class UiSelectBinding extends UiBinding {
  SelectElement _select;
  String _selector;

  set options(List<Map> data) {
    _select.children.clear();
    if (data.isEmpty) {
      return;
    }

    Map row = data[0];
    if (!row.containsKey('uid')) {
      throw "Must have an uid key in rows";
    }

    var key = null;
    if (row.containsKey('name')) {
      key = 'name';
    }
    else if (row.containsKey('text')) {
      key = 'text';
    }
    if (key == null) {
      throw "Most have a name or text key in rows";
    }

    var options = new DocumentFragment();
    data.forEach((Map elem) {
      var option = new OptionElement();
      option.value = "${elem['uid']}";
      option.appendText(elem[key]);
      options.append(option);
    });
    _select.append(options);
  }

  UiSelectBinding(String this._selector);

  UiSelectBinding.byElement(SelectElement select) {
    _selector = '#${select.id}';
  }

  void bind(View view) {
    _select = querySelector(_selector);
    if (_select == null) {
      throw new SelectorException("Select not found (selector $_selector)");
    }
    _select.onChange.listen((event) {
      view.isDirty = true;
      event.preventDefault();
      view.executeHandler(_select.id, false);
    });
  }

  String read() {
    return _select.value;
  }

  void write(String value) {
    _select.value = value;
  }
}

