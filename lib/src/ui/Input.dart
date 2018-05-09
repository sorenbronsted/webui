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

  @override
  String get value {
    InputElement input = _htmlElement;
    switch(input.type) {
      case 'file':
        break;
      case 'checkbox':
      case 'radio':
        return input.checked ? '1' : '0';
      default:
        return Format.internal(_type, (_htmlElement as InputElement).value);
    }
    return '';
  }

  @override
  void populate(Type sender, Object object) {
    if (_cls != sender.toString()) {
      return;
    }

    Map values = object;
    _uid = values['uid'];

    resetUiState();
    InputElement input = _htmlElement;
    switch(input.type) {
      case 'file':
        break;
      case 'checkbox':
      case 'radio':
        input.checked = (input.value == values[_property]);
        break;
      default:
        input.value = Format.display(_type, values[_property], _format);
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

    _htmlElement.onBlur.listen((event) {
      event.preventDefault();
      isValid = validate();
      _log.fine("onBlur: isValid ${isValid} isDirty ${isDirty}");
      if (isValid) {
        view.validateAndfire(view.eventPropertyChanged, true, elementValue);
      }
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
      _log.fine("onChange: isValid ${isValid} isDirty ${isDirty}");
      //view.validateAndfire(view.eventPropertyChanged, true, elementValue);
    });
  }

  void _initRadio(View view) {
    (_htmlElement as InputElement).name = '${_cls}.${_property}'; // name must set for radio button to work
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
