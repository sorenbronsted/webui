
part of webui;

class Select extends InputBase {
  String _optionProperty;
  String _options;
  String _myvalue; //This shadows the value property, so that value can be set before any options are available

  Select(View view, SelectElement select, [String cls]) : super(view, select, cls) {
    _options = _htmlElement.attributes['data-list'];
    _optionProperty = _htmlElement.attributes['data-list-display'];
    if (_options != null && _options.isNotEmpty && _optionProperty != null && _optionProperty.isEmpty) {
      throw "options is used so option-display is needed";
    }
    _htmlElement.onChange.listen((event) {
      view.validateAndfire(view.eventPropertyChanged, false, elementValue);
    });
  }

  set list(Iterable<DataClass> list) {
    if (_options == null) {
      throw "options is not define, so can not be set";
    }

    (_htmlElement as SelectElement).children.clear();
    if (list == null || list.isEmpty) {
      return;
    }
    var options = new DocumentFragment();
    list.forEach((DataClass row) {
      var option = new OptionElement();
      option.value = row.uid.toString();
      option.appendText(row.get(_optionProperty));
      options.append(option);
    });
    _htmlElement.append(options);
    (_htmlElement as SelectElement).value = _myvalue;
  }

  @override
  Object get value => (_htmlElement as SelectElement).value;

  @override
  void populate(Type type, Object object) {
    if (_cls == type.toString()) {
      DataClass data = object;
      uid = data.uid;
      (_htmlElement as SelectElement).value = data.get(_property);
      _myvalue = data.get(_property);
      InputValidator.reset(this);
    }
    else if (_options == type.toString()) {
      list = object;
      (_htmlElement as SelectElement).value = _myvalue;
    }
  }

  @override
  Set<String> collectDataLists(Set<String> result) {
    if (_options != null) {
      result.add(_options);
    }
    return result;
  }
}

