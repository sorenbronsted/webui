
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
      view.validateAndfire(view.eventPropertyChanged, false, value);
    });
  }

  set list(Iterable<Map> list) {
    if (_options == null) {
      throw "options is not define, so can not be set";
    }

    (_htmlElement as SelectElement).children.clear();
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
    _htmlElement.append(options);
    (_htmlElement as SelectElement).value = _myvalue;
  }

  @override
  Object get value => (_htmlElement as SelectElement).value;

  @override
  set value(Object value) {
    (_htmlElement as SelectElement).value = value;
    _myvalue = value;
  }
}

