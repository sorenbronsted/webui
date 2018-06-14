library format;

import 'package:intl/intl.dart';

abstract class Formatter {
  String display(String data, String format);
  String internal(String data, String format);
}

class Format {
  static Map<String, Formatter> _formatters;
  
  static addFormatter(String classId, Formatter formatter) {
    assert(classId != null);
    assert(formatter != null);
    _formatters[classId] = formatter;
  }
  
  static String display(String type, Object value, [String format]) {
    if (type == null) {
      return value;
    }
    if (value == null || value == 'null') {
      return "";
    }
    if (value is! String) {
      value = '${value}';
    }
    return _execute(type, value, format, (Formatter fmt, String value, String format) => fmt.display(value, format));
  }

  static String internal(String type, String value, [String format]) {
    if (type == null) {
      return value;
    }
    return _execute(type, value, null, (Formatter fmt, String value, String Format) => fmt.internal(value, format));
  }

  static String _execute(String type, String value, String format, Function callback) {
    if (callback == null) {
      return value;
    }

    if (_formatters == null) {
      _formatters = new Map();
      _loadFormatters();
    }
    value = value.trim();
    var formatter = _formatters[type];
    if (formatter != null) {
      return callback(formatter, value, format);
    }
    return value;
  }
  
  static _loadFormatters() {
    addFormatter("date", new DateTimeFmt());
    addFormatter("time", new DateTimeFmt());
    addFormatter("datetime", new DateTimeFmt());
    addFormatter("number", new NumberFmt());
    addFormatter("casenumber", new CaseNumberFmt());
  }
}

class DateTimeFmt implements Formatter {
  String display(String input, String format) {
    if (input == null || input.trim().isEmpty || format == null) {
      return input;
    }
    return new DateFormat(format).format(DateTime.parse(input));
  }

  String internal(String input, String format) {
    if (input == null || input.trim().isEmpty || format == null) {
      return input;
    }
    var dt = new DateFormat(format).parse(input);
    return dt.toString();
  }
}

class NumberFmt implements Formatter {

  String display(String input, String format) {
    if (input == null || input.trim().isEmpty || format == null) {
      return input;
    }
    return new NumberFormat(format).format(num.parse(input));
  }

  String internal(String input, String format) {
    if (input == null || input.trim().isEmpty || format == null) {
      return input;
    }
    num value = new NumberFormat(format).parse(input); //This allways returns a decimal
    if (!format.contains('.')) {
      value = value.toInt();
    }
    return value.toString();
  }
}

class CaseNumberFmt implements Formatter {
  String display(String input, String format) {
    assert(input != null);
    if (input.length != 8) {
      return input;
    }
    var year = input.substring(0, 4);
    var number = int.parse((input.substring(4)));
    return "$number/$year";
  }
  
  String internal(String input, String format) {
    assert(input != null);
    var tmp = input.split("/");
    if (tmp.length != 2) {
      return input;
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
    var number = int.parse(tmp[0]);
    return "${year*10000+number}";
  }
}
