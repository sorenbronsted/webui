
part of webui;

class UiValidationException {
  String _msg;

  UiValidationException(String this._msg);
  String toString() => _msg;
}

class UiInputValidator {
  static Map _methods = {
    "datetime" : _datetime,
    "casenumber" : _caseNumber,
    "number" : _number,
    "email" : _email
  };

  static UiInputValidatorListener _css = new UiInputValidatorListener();

  static set css(UiInputValidatorListener css) => _css = css;

  static void reset(UiInputType input) {
    _css.clear(input);
  }

  static bool validate(UiInputType input) {
    var isValid = true;

    if (input.readOnly == true || input.disabled == true) {
      return isValid;
    }

    try {
      if (input.required) {
        input.value = _required(input.value);
      }
      var type = input.uiType;
      var format = input.format;
      if (_methods.containsKey(type)) {
        input.value = _methods[type](input.value, format);
      }
      _css.valid(input);
    }
    on UiValidationException catch(e) {
      _css.error(input, e.toString());
      isValid = false;
    }
    return isValid;
  }

  static String _required(String input) {
    if (input.trim().isEmpty) {
      throw new UiValidationException("Skal udfyldelse");
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
        throw new UiValidationException(msg);
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
      throw new UiValidationException(msg);
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
          throw new UiValidationException(msg);
      }
    }
    on FormatException {
      throw new UiValidationException(msg);
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
          throw new UiValidationException(msg);
      }
    }
    on FormatException {
      throw new UiValidationException(msg);
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
          throw new UiValidationException(msg);
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
        throw new UiValidationException(msg);
      }
    }
    on FormatException {
      throw new UiValidationException(msg);
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
      throw new UiValidationException(msg);
    }
    return input;
  }

  static String _email(String input, String format) {
    var msg ="Email er ikke gyldig";
    var reg = new RegExp("^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\$");
    var value = input.trim().toLowerCase();
    if (!value.isEmpty && !reg.hasMatch(value)) {
      throw new UiValidationException(msg);
    }
    return input;
  }
}