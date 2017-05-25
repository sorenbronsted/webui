
part of webui;

class UiSelect extends UiElement implements Observer {
  String _optionProperty;
  String _options;
  String _myvalue; //This shadows the value property, so that value can be set before any options are available

  UiSelect(SelectElement select, [String cls]) : super(select, cls) {
    _options = htmlElement.attributes['data-list'];
    _optionProperty = htmlElement.attributes['data-list-display'];
    if (_options != null && _options.isNotEmpty && _optionProperty != null && _optionProperty.isEmpty) {
      throw "options is used so option-display is needed";
    }
    htmlElement.onChange.listen((event) {
      store.setProperty(this, cls, property, (htmlElement as SelectElement).value, uid);
    });
  }

  @override
  void update() {
    String changedValue = _store.getProperty(cls, property, uid);
    (htmlElement as SelectElement).value = changedValue;
    _myvalue = changedValue;

    if (_options == null) {
      return;
    }

    (htmlElement as SelectElement).children.clear();
    Iterable<Map> list = _store.getObjects(_options);
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
  attach(ObjectStore store) {
    super.attach(store);
    if (_options != null) {
      store.attach(this, new Topic(_options));
    }
  }

  @override
  detach(ObjectStore store) {
    super.detach(store);
    if (_options != null) {
      store.detach(this, new Topic(_options));
    }
  }
}

