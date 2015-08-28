
part of webui;

class ValidationException {
  String _msg;

  ValidationException(String this._msg);
  String toString() => _msg;
}

class UiInputValidator {
  static Map _methods = {
    "required" : _required,
    "date" : _date,
    "time" : _time,
    "datetime" : _datetime,
    "caseNumber" : _caseNumber,
    "amountInt" : _integer,
    "integer" : _integer,
    "amount" :  _decimal,
    "decimal" :  _decimal,
    "email" : _email
  };

  static void reset(HtmlElement input) {
    input.classes.remove("valid");
    input.classes.remove("error");
    input.title = "";
  }

  static void validate(InputElement input) {

    if (input.attributes.containsKey("readonly") ||
        input.attributes.containsKey("disabled") ||
        input.classes.contains("ignore") ||
        input.classes.contains("error")) {
      return;
    }

    input.classes.forEach((elem) {
      if (!_methods.containsKey(elem)) {
        return;
      }

      try {
        input.value = _methods[elem](input.value);
      }
      on ValidationException catch(e) {
        input.title = e.toString();
        input.classes.add("error");
      }
    });

    if (!input.classes.contains("error")) {
      input.classes.add("valid");
    }
  }

  static String _required(String input) {
    if (input.trim().isEmpty) {
      throw new ValidationException("Skal udfyldelse");
    }
    return input;
  }

  static String _datetime(String input) {
    var msg = "Dato og tid er ikke en gyldig, fx 100917 1145";
    var value = input.trim();
    if (value.isEmpty) {
      return input;
    }
    try {
      var parts = input.split(" ");
      if (parts.length != 2) {
        throw new ValidationException(msg);
      }
      return "${_date(parts[0])} ${_time(parts[1])}";
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
  static String _time(String input) {
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
    var hh = (test.hour < 10 ? "0${test.hour}" : "${test.hour}");
    var mm = (test.minute < 10 ? "0${test.minute}" : "${test.minute}");
    var ss = (test.second < 10 ? "0${test.second}" : "${test.second}");
    return "${hh}:${mm}:${ss}";
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
  static String _date(String input) {
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
    var dd = (test.day < 10 ? "0${test.day}" : "${test.day}");
    var mm = (test.month < 10 ? "0${test.month}" : "${test.month}");
    var yyyy = "${test.year}";
    return "$dd-$mm-$yyyy";
  }

  static String _caseNumber(String input) {
    var msg = "Sagsnr er ikke gyldigt, Fx 10/01 eller 20010001.";
    var value = input.trim();
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

  static String _integer(String input) {
    var msg = "Beløb er ikke gyldigt, 1.234";
    try {
      var value = input.trim();
      if (!value.isEmpty) {
        value = value.replaceAll(".", "");
        int.parse(value);
      }
    }
    on FormatException {
      throw new ValidationException(msg);
    }
    return input;
  }

  static String _decimal(String input) {
    var msg = "Beløb er ikke gyldigt, 1.234,45";
    try {
      var value = input.trim();
      if (!value.isEmpty) {
        value = value.replaceAll(".","").replaceAll(",", ".");
        double.parse(value);
      }
    }
    on FormatException {
      throw new ValidationException(msg);
    }
    return input;
  }

  static String _email(String input) {
    var msg ="Email er ikke gyldig";
    var reg = new RegExp("^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\$");
    var value = input.trim().toLowerCase();
    if (!value.isEmpty && !reg.hasMatch(value)) {
      throw new ValidationException(msg);
    }
    return input;
  }
}