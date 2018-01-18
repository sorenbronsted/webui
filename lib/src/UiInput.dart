part of webui;

class UiInput extends UiInputElement {
  final Logger log = new Logger('UiInput');

  UiInput(ViewElement view, InputElement input, [String parentCls]) : super(input, parentCls) {
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
    InputElement input = htmlElement;
    switch(input.type) {
      case 'file':
        break;
      case 'checkbox':
      case 'radio':
        return input.checked ? '1' : '0';
      default:
        return Format.internal(type, (htmlElement as InputElement).value);
    }
    return '';
  }

  set value(String value) {
    resetUiState();
    InputElement input = htmlElement;
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
    UiInputValidator.reset(this);
  }

  void _initInput(ViewElement view) {

    htmlElement.onFocus.listen((event) {
      UiInputValidator.reset(this);
      isValid = true;
      log.fine("onFocus: isValid ${isValid} isDirty ${isDirty}");
    });

    htmlElement.onKeyUp.listen((event) => isDirty = true);

    htmlElement.onKeyDown.listen((event) {
      if (event.keyCode == 13) {
        log.fine("onKeyDown: isValid ${isValid} isDirty ${isDirty}");
        view.handleEvent(ViewElementEvent.Change, true, event);
      }
    });

    htmlElement.onChange.listen((Event event) {
      isDirty = true;
      isValid = UiInputValidator.validate(this);
      log.fine("onChange: isValid ${isValid} isDirty ${isDirty}");
      view.handleEvent(ViewElementEvent.Change, true, event);
    });
  }

  void _initRadio(ViewElement view) {
    (htmlElement as InputElement).name = '${cls}.${property}'; // name must set for radio button to work
    htmlElement.onChange.listen((Event event) {
      view.handleEvent(ViewElementEvent.Change, true, event);
    });
  }

  void _initCheckbox(ViewElement view) {
    htmlElement.onChange.listen((Event event) {
      view.handleEvent(ViewElementEvent.Change, false, event);
    });
  }

  void _initFile(ViewElement view) {
    htmlElement.onChange.listen((event) {
      view.handleEvent(ViewElementEvent.Change, false, event);
    });
  }
}
