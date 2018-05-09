
part of webui;

class ValidationException {
  String _msg;

  ValidationException(String this._msg);
  String toString() => _msg;
}

class InputValidator {
  static Logger _log = new Logger('${InputValidator}');

  static Map _methods = {
    "date" : _date,
    "time" : _time,
    "datetime" : _datetime,
    "casenumber" : _caseNumber,
    "number" : _number,
    "email" : _email
  };

  static InputCss _css = new InputCss();

  static set css(InputCss css) => _css = css;

  static InputCss get css => _css;

  static void reset(ElementWrapper input) {
    _css.clear(input._htmlElement);
  }

  static bool validate(ElementWrapper element) {
    _log.fine('validate: element: ${element}');
    var isValid = true;
    InputElement input = element._htmlElement;

    if (input.readOnly == true || input.disabled == true) {
      return isValid;
    }

    try {
      if (input.required) {
        input.value = _required(input.value);
      }
      var type = element._type;
      var format = element._format;
      if (_methods.containsKey(type)) {
        input.value = _methods[type](input.value, format);
      }
      _css.valid(input);
    }
    on ValidationException catch(e) {
      _css.error(input, e.toString());
      isValid = false;
    }
    _log.fine('validate: isValid: ${isValid}');
    return isValid;
  }

  static String _required(String input) {
    if (input.trim().isEmpty) {
      throw new ValidationException("Skal udfyldelse");
    }
    return input;
  }

  static String _datetime(String input, String format) {
    var msg = "Dato og tid er ikke en gyldig, da dato og klokkeslet skal være adskilt af en blank, fx 100717 1145";
    var value = input.trim();
    if (value.isEmpty) {
      return input;
    }
    try {
      var parts = value.split(new RegExp(r' +'));
      if (parts.length < 1 || parts.length > 2) {
        throw new ValidationException(msg);
      }
      if (parts.length == 1) {
        if (format.contains(new RegExp(r'[dMy]'))) {
          return "${_date(parts[0], format)}";
        }
        else {
          return "${_time(parts[0], format)}";
        }
      }
      else {
        var formatParts = format.split(new RegExp(r' +'));
        return "${_date(parts[0], formatParts[0])} ${_time(parts[1], formatParts[1])}";
      }
    }
    catch(e) {
      throw new ValidationException(msg);
    }
  }

  /* All ':' (delimiters) are removed
   * What remains wil be interpret as:
   * 9      => hour
   * 99     => hour
   * 9999   => hour and minute
   * 999999 => hour, minute and seconds
   * anything else is an error
   */
  static String _time(String input, String format) {
    var msg = "Tidspunkt er ikke en gyldig, fx 1045 el 10:45.";
    var value = input.trim();
    if (value.isEmpty) {
      return input;
    }
    var now = new DateTime.now();
    var test;
    value = value.replaceAll(':','');
    try {
      switch (value.length) {
        case 1:
        case 2:
          var hh = int.parse(value);
          test = new DateTime(now.year, now.month, now.day, hh, 0, 0);
          break;
        case 4:
          var hh = int.parse(value.substring(0, 2));
          var mm = int.parse(value.substring(2));
          test = new DateTime(now.year, now.month, now.day, hh, mm, 0);
          break;
        case 6:
          var hh = int.parse(value.substring(0, 2));
          var mm = int.parse(value.substring(2, 4));
          var ss = int.parse(value.substring(4));
          test = new DateTime(now.year, now.month, now.day, hh, mm, ss);
          break;
        default:
          throw new ValidationException(msg);
      }
    }
    on FormatException {
      throw new ValidationException(msg);
    }
    return new DateFormat(format).format(test);
  }

  /* All '-' (delimiters) are removed.
   * What remains will interpret as:
   * d      => day in current month and year
   * dd     => day in current month and year
   * ddm    => day and month i current year
   * ddmm   => day and month i current year
   * ddmmy  => if year < 40 : y + 2000 ? y + 1900
   * ddmmyy => if year < 40 : y + 2000 ? y + 1900
   * ddmmyyyy
   * anything else is an error
   */
  static String _date(String input, format) {
    var msg = "Dato er ikke en gyldig, fx ddmmyy.";
    var value = input.trim();
    if (value.isEmpty) {
      return input;
    }
    var now = new DateTime.now();
    var test;
    value = value.replaceAll('-','');
    try {
      switch(value.length) {
        case 1:
        case 2:
          var dd = int.parse(value);
          test = new DateTime(now.year, now.month, dd);
          break;
        case 3:
        case 4:
          var dd = int.parse(value.substring(0, 2));
          var mm = int.parse(value.substring(2));
          test = new DateTime(now.year, mm, dd);
          break;
        case 5:
        case 6:
        case 8:
          var dd = int.parse(value.substring(0,2));
          var mm = int.parse(value.substring(2,4));
          var yy = int.parse(value.substring(4));
          if (yy < 100) {
            if (yy < 40) {
              yy += 2000;
            }
            else {
              yy += 1900;
            }
          }
          test = new DateTime(yy, mm, dd);
          break;
        default:
          throw new ValidationException(msg);
      }
    }
    on FormatException {
      throw new ValidationException(msg);
    }
    return new DateFormat(format).format(test);
  }

  static String _caseNumber(String input, String empty) {
    var msg = "Sagsnr er ikke gyldigt, Fx 10/01 eller 20010001.";
    var value = input.trim();
    if (value.isEmpty) {
      return input;
    }
    try {
      var number = 0;
      if (value.indexOf("/") >= 0) {
        var tmp = value.split("/");
        if (tmp.length != 2) {
          throw new ValidationException(msg);
        }
        var year = int.parse(tmp[1]);
        if (year < 100) {
          if (year < 40) {
            year += 2000;
          }
          else {
            year += 1900;
          }
        }
        number = year * 10000 + int.parse(tmp[0]);
      }
      else {
        number = int.parse(value);
      }
      if (number < 19000001 || number > 21009999) {
        throw new ValidationException(msg);
      }
    }
    on FormatException {
      throw new ValidationException(msg);
    }
    return input;
  }

  static String _number(String input, String format) {
    var msg = "Tallet er ikke gyldigt, 1.234";
    try {
      var value = input.trim();
      if (!value.isEmpty) {
        var f = new NumberFormat(format);
        var n = f.parse(input);
        input = f.format(n);
      }
    }
    on FormatException {
      throw new ValidationException(msg);
    }
    return input;
  }

  static String _email(String input, String format) {
    var msg ="Email er ikke gyldig";
    var reg = new RegExp("^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\$");
    var value = input.trim().toLowerCase();
    if (!value.isEmpty && !reg.hasMatch(value)) {
      throw new ValidationException(msg);
    }
    return input;
  }
}