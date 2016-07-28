
part of webui;

class UiSelect extends SelectElement implements ObjectStoreListener {
  static const String uiTagName = 'x-select';

  String _optionName;

  UiSelect.created() : super.created() {
    _optionName = attributes['optionname'];
  }

  void bind(ObjectStore store, View view) {
    onChange.listen((event) {
      view.isDirty = true;
      store.setMapProperty(name, value);
    });
    store.addListener(name, this);
    store.addListener('${name}.list', this);
  }

  void valueChanged(String nameValue, Object changedValue) {
    if (name == nameValue) {
      value = changedValue;
    }
    else if ('${name}.list' == nameValue) {
      children.clear();
      var list = (changedValue as List);
      if (list.isEmpty) {
        return;
      }
      var options = new DocumentFragment();
      (changedValue as List).forEach((Map elem) {
        var option = new OptionElement();
        option.value = "${elem['uid']}";
        option.appendText(elem[_optionName]);
        options.append(option);
      });
      append(options);
    }
  }
}

