part of webui;

class UiInput extends UiInputState {

  UiInput(InputElement input, [String parentCls]) : super(input, parentCls) {
    switch(input.type) {
      case 'file':
        _initFile();
        break;
      case 'checkbox':
        _initCheckbox();
        break;
      case 'radio':
        _initRadio();
        break;
      default:
        _initInput();
    }
    resetUiState();
  }

  @override
  void update() {
    resetUiState();
    InputElement input = htmlElement;
    switch(input.type) {
      case 'file':
        break;
      case 'checkbox':
        if (type == 'selection') {
          List values = store.getProperty(cls, property, uid);
          input.checked = (values.contains(input.value));
        }
        else {
          input.checked = (input.value == store.getProperty(cls, property, uid));
        }
        break;
      case 'radio':
        input.checked = (input.value == store.getProperty(cls, property, uid));
        break;
      default:
        input.value = Format.display(type, store.getProperty(cls, property, uid), format);
    }
    UiInputValidator.reset(this);
  }

  void _initInput() {
    htmlElement.onChange.listen((Event e) {
      isDirty = true;
      _writeStore();
    });

    htmlElement.onFocus.listen((event) {
      if (!isValid) {
        return;
      }
      UiInputValidator.reset(this);
      isValid = true;
    });

    htmlElement.onKeyUp.listen((event) => isDirty = true);

    htmlElement.onKeyDown.listen((event) {
      if (event.keyCode == 13) {
        _writeStore();
      }
    });
  }

  void _initRadio() {
    (htmlElement as InputElement).name = '${cls}.${property}'; // name must set for radio button to work
    htmlElement.onChange.listen((Event e) {
      store.setProperty(this, cls, property, (htmlElement as InputElement).value, uid);
    });
  }

  void _initCheckbox() {
    htmlElement.onChange.listen((Event e) {
      if (type == 'selection') {
        if ((htmlElement as InputElement).checked == true) {
          store.addCollectionProperty(this, cls, property, (htmlElement as InputElement).value, uid);
        }
        else {
          store.removeCollectionProperty(this, cls, property, (htmlElement as InputElement).value, uid);
        }
      }
      else {
        var value = ((htmlElement as InputElement).checked == true ? '1' : '0');
        store.setProperty(this, cls, property, value, uid);
      }
    });
  }

  void _initFile() {
    htmlElement.onChange.listen((event) {
      event.preventDefault();
      store.setProperty(this, cls, property, (htmlElement as InputElement).files);
    });
  }

  bool _doValidate() {
    return UiInputValidator.validate(this);
  }

  void _writeStore() {
    if (isDirty) {
      validate();
      if (isValid) {
        store.setProperty(this, cls, property, Format.internal(type, (htmlElement as InputElement).value, format), uid);
        isDirty = false;
      }
    }
  }
}
