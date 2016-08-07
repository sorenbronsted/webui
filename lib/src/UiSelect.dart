
part of webui;

class UiSelect extends SelectElement implements ObjectStoreListener {
  static const String uiTagName = 'x-select';

  String _class;
  String _property;
  String _options;

  UiSelect.created() : super.created() {
    var display = attributes['option-display'];
    _options = attributes['options'];
    var parts = display.split('.');
    if (parts.length < 1 || parts.length > 2) {
      throw "UiSelect: wrong format. Must be class.property or property";
    }
    if (parts.length == 2) {
      _class = parts[0];
      _property = parts[1];
    }
    else {
      _property = parts[0];
    }
  }

  void bind(ObjectStore store, View view) {
    onChange.listen((event) {
      store.changeMapProperty(name, value);
    });
    store.addListener(name, this);
    store.addListener(_options, this);
  }

  void valueChanged(String nameValue, Object changedValue) {
    if (name == nameValue) {
      value = changedValue;
    }
    else if (_options == nameValue) {
      children.clear();
      var list = (changedValue as List);
      if (list.isEmpty) {
        return;
      }
      var options = new DocumentFragment();
      (changedValue as List).forEach((Map elem) {
        var row = (_class != null ? elem[_class] : elem);
        var option = new OptionElement();
        option.value = "${row['uid']}";
        option.appendText(row[_property]);
        options.append(option);
      });
      append(options);
    }
  }
}

