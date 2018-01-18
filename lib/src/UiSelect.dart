
part of webui;

class UiSelect extends UiInputElement {
  String _optionProperty;
  String _options;
  String _myvalue; //This shadows the value property, so that value can be set before any options are available

  UiSelect(ViewElement view, SelectElement select, [String cls]) : super(select, cls) {
    _options = htmlElement.attributes['data-list'];
    _optionProperty = htmlElement.attributes['data-list-display'];
    if (_options != null && _options.isNotEmpty && _optionProperty != null && _optionProperty.isEmpty) {
      throw "options is used so option-display is needed";
    }
    htmlElement.onChange.listen((event) {
      view.handleEvent(ViewElementEvent.Change, false, event);
    });
  }

  set list(Iterable<Map> list) {
    if (_options == null) {
      throw "options is not define, so can not be set";
    }

    (htmlElement as SelectElement).children.clear();
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
    htmlElement.append(options);
    (htmlElement as SelectElement).value = _myvalue;
  }

  @override
  String get value => (htmlElement as SelectElement).value;

  @override
  set value(String value) {
    (htmlElement as SelectElement).value = value;
    _myvalue = value;
  }
}

