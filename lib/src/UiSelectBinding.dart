
part of webui;

class UiSelectBinding extends UiBinding {
  SelectElement _select;
  String _selector;

  set options(List<Map> data) {
    _select.children.clear();
    if (data.isEmpty) {
      return;
    }

    var row = data[0];
    var idxUid = row.keys.toList().indexOf('uid');
    if (idxUid < 0) {
      throw "Must have an uid in rows";
    }

    var idxValue = row.keys.toList().indexOf('name');
    if (idxValue < 0) {
      idxValue = row.keys.toList().indexOf('text');
    }
    if (idxValue < 0) {
      throw "Most have a name or text in row";
    }

    var options = new DocumentFragment();
    data.forEach((Map elem) {
      var option = new OptionElement();
      option.value = "${elem[elem.keys.elementAt(idxUid)]}";
      option.appendText(elem[elem.keys.elementAt(idxValue)]);
      options.append(option);
    });
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

