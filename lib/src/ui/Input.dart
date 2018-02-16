part of webui;

class Input extends InputBase {

  Input(View view, InputElement input, [String parentCls]) : super(view, input, parentCls) {
    switch(input.type) {
      case 'file':
        _initFile(view);
        break;
      case 'checkbox':
        _initCheckbox(view);
        break;
      case 'radio':
        _initRadio(view);
        break;
      default:
        _initInput(view);
    }
    resetUiState();
  }

  String get value {
    InputElement input = _htmlElement;
    switch(input.type) {
      case 'file':
        break;
      case 'checkbox':
      case 'radio':
        return input.checked ? '1' : '0';
      default:
        return Format.internal(type, (_htmlElement as InputElement).value);
    }
    return '';
  }

  set value(Object value) {
    resetUiState();
    InputElement input = _htmlElement;
    switch(input.type) {
      case 'file':
        break;
      case 'checkbox':
      case 'radio':
        input.checked = (input.value == value);
        break;
      default:
        input.value = Format.display(type, value, format);
    }
    InputValidator.reset(this);
  }

  void _initInput(View view) {

    _htmlElement.onFocus.listen((event) {
      InputValidator.reset(this);
      isValid = true;
      _log.fine("onFocus: isValid ${isValid} isDirty ${isDirty}");
    });

    _htmlElement.onKeyPress.listen((event) {
      _log.fine('onKeyPress: keyCode: ${event.keyCode}');
      isDirty = true;
    });

    _htmlElement.onKeyDown.listen((event) {
      if (event.keyCode == 13) {
        _log.fine("onKeyDown: isValid ${isValid} isDirty ${isDirty}");
        view.validateAndfire(view.eventPropertyChanged, true, elementValue);
      }
    });

    _htmlElement.onChange.listen((Event event) {
      event.preventDefault();
      isDirty = true;
      isValid = validate();
      _log.fine("onChange: isValid ${isValid} isDirty ${isDirty}");
      view.validateAndfire(view.eventPropertyChanged, true, elementValue);
    });
  }

  void _initRadio(View view) {
    (_htmlElement as InputElement).name = '${cls}.${property}'; // name must set for radio button to work
    _htmlElement.onChange.listen((Event event) {
      event.preventDefault();
      view.validateAndfire(view.eventPropertyChanged, false, elementValue);
    });
  }

  void _initCheckbox(View view) {
    _htmlElement.onChange.listen((Event event) {
      event.preventDefault();
      view.validateAndfire(view.eventPropertyChanged, false, elementValue);
    });
  }

  void _initFile(View view) {
    _htmlElement.onChange.listen((event) {
      event.preventDefault();
      view.validateAndfire(view.eventPropertyChanged, false, elementValue);
    });
  }
}
