
part of webui;

class UiSelect extends SelectElement with UiBind implements ObjectStoreListener {
  static const String uiTagName = 'x-select';

  String _optionProperty;
  String _options;
  String _myvalue; //This shadows the value property, so that value can be set before any options are available
  ObjectStore _store;

  set bindOptions(String options) => _options = options;
  set bindOptionDisplay(String optionDisplay) => _optionProperty = optionDisplay;

  factory UiSelect([bind, String optionDisplay, String options]) {
    UiSelect select = document.createElement('select', UiSelect.uiTagName);
    if (bind != null) {
      select.setBind(bind);
    }
    if (options != null && options.isNotEmpty && optionDisplay != null && optionDisplay.isEmpty) {
      throw "options is used so option-display is needed";
    }
    select._options = options;
    select._optionProperty = optionDisplay;
    return select;
  }

  UiSelect.created() : super.created() {
    setBind(getAttribute('bind'));
    _options = attributes['options'];
    _optionProperty = attributes['option-display'];
    if (options != null && options.isNotEmpty && _optionProperty != null && _optionProperty.isEmpty) {
      throw "options is used so option-display is needed";
    }
  }

  void bind(ObjectStore store, View view) {
    _store = store;
    onChange.listen((event) {
      store.setProperty(_cls, _property, value);
    });
    store.addListener(this, _cls, _property);
    if (_options != null) {
      store.addListener(this, _options);
      valueChanged(_options, null);
      valueChanged(_cls, _property);
    }
  }

  void valueChanged(String cls, Object property) {
    if (_cls == cls && _property == property) {
      String changedValue = _store.getProperty(_cls, _property, _uid);
      value = changedValue;
      _myvalue = changedValue;
    }
    else if (_options != null && _options == cls) {
      children.clear();
      Iterable<Map> list = _store.getObjects(cls);
      if (list == null || list.isEmpty) {
        return;
      }
      var options = new DocumentFragment();
      list.forEach((Map row) {
        var option = new OptionElement();
        option.value = row['uid'].toString();
        option.appendText(row[_optionProperty]);
        options.append(option);
      });
      append(options);
      value = _myvalue;
    }
  }
}

