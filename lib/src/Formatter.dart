
library format;

abstract class Formatter {
  String display(String data);
  String internal(String data);
}

class Format {
  static Map<String, Formatter> _formatters;
  
  static addFormatter(String classId, Formatter formatter) {
    assert(classId != null);
    assert(formatter != null);
    _formatters[classId] = formatter;
  }
  
  static String display(Iterable classes, String value) {
    assert(classes != null);
    if (value == null || value == 'null') {
      return "";
    }
    if (value is! String) {
      value = '${value}';
    }
    return _execute(classes, value, (Formatter fmt, String value) => fmt.display(value));
  }

  static String internal(Iterable classes, String value) {
    assert(classes != null);
    assert(value != null);
    return _execute(classes, value, (Formatter fmt, String value) => fmt.internal(value));
  }

  static String _execute(Iterable classes, String value, Function callback) {
    assert(classes != null);
    assert(callback != null);

    if (_formatters == null) {
      _formatters = new Map();
      _loadFormatters();
    }
    var i = classes.iterator;
    value = value.trim();
    while (i.moveNext()) {
      var classId = i.current;
      var formatter = _formatters[classId];
      if (formatter != null) {
        return callback(formatter, value);
      }
    }
    return value;
  }
  
  static _loadFormatters() {
    addFormatter("date", new DateFmt());
    addFormatter("time", new TimeFmt());
    addFormatter("datetime", new DateTimeFmt());
    addFormatter("amountInt", new NumberFmt(0));
    addFormatter("integer", new NumberFmt(0));
    addFormatter("amount", new NumberFmt(2));
    addFormatter("decimal", new NumberFmt(4)); //TODO encode decimal length
    addFormatter("caseNumber", new CaseNumberFmt());
  }
}

class DateFmt implements Formatter {
  // Expected input format yyyy-mm-dd or yyyymmdd
  String display(String input) {
    assert(input != null);
    var value = input.replaceAll("-", "");
    if (input.length < 8) {
      return input;
    }
    var yy = value.substring(0,4);
    var mm = value.substring(4,6);
    var dd = value.substring(6,8);
    return "${dd}-${mm}-${yy}";
  }
  
  // Expected input format is dd-mm-yyyy
  String internal(String input) {
    assert(input != null);
    if (input.length < 10) {
      return input;
    }
    var tmp = input.substring(0,10).split("-");
    if (tmp.length != 3) {
      return input;
    }
    return "${tmp[2]}-${tmp[1]}-${tmp[0]}";
  }
}

class TimeFmt implements Formatter {

  // Expected input hh:mm:ss or hhmmss
  String display(String input) {
    assert(input != null);
    var value = input.replaceAll(":", "");
    if (value.length < 6) {
      value = value.padLeft(6, '0');
    }
    var hh = value.substring(0,2);
    var mm = value.substring(2,4);
    var ss = value.substring(4,6);
    return "${hh}:${mm}:${ss}";
  }

  // Exptected input hh:mm:ss
  String internal(String input) {
    assert(input != null);
    if (input.length < 10) {
      return input;
    }
    var tmp = input.substring(0,8).split(":");
    if (tmp.length != 3) {
      return input;
    }
    return "${tmp[0]}:${tmp[1]}:${tmp[2]}";
  }
}

class DateTimeFmt implements Formatter {
  // Expected input format yyyy-mm-dd hh:mm:ss
  String display(String input) {
    var tmp = input.split(" ");
    if (tmp.length != 2) {
      return input;
    }

    var fmtDate = new DateFmt();
    var date = fmtDate.display(tmp[0]);
    var fmtTime = new TimeFmt();
    var time = fmtTime.display(tmp[1]);
    return "${date} ${time}";
  }
  
  // Expected input format is dd-mm-yyyy hh:mm:ss
  String internal(String input) {
    var tmp = input.split(" ");
    if (tmp.length != 2) {
      return input;
    }
    var fmtDate = new DateFmt();
    var date = fmtDate.internal(tmp[0]);
    var fmtTime = new TimeFmt();
    var time = fmtTime.internal(tmp[1]);
    return "${date}T${time}";
  }
}

class NumberFmt implements Formatter {
  int _decimalCount;
  
  NumberFmt(this._decimalCount) {
    assert(_decimalCount >= 0);
  }
  
  String display(String input) {
    assert(input != null);
    if (input == "null" || input == "") {
      return "0,00";
    }
    var number = "0";
    var fraction = "00";
    if (input.contains(".")) {
      var parts = input.split('.');
      number = parts[0];
      fraction = parts[1];
    }
    else {
      number = input;
    }
    
    StringBuffer str = new StringBuffer();
    if (number[0] == '-') {
      str.write(number[0]);
      number = number.substring(1);
    }
    for (var i = 0; i < number.length; i++) {
      if (i > 0 && (number.length - i) % 3 == 0) {
        str.write('.');
      }
      str.write(number[i]);
    }
    if (_decimalCount > 0) {
      str.write(',');
      str.write(fraction);
    }
    return str.toString();
  }
  
  String internal(String input) {
    assert(input != null);
    return input.replaceAll(".","").replaceAll(",",".");
  }
}

class CaseNumberFmt implements Formatter {
  String display(String input) {
    assert(input != null);
    if (input.length != 8) {
      return input;
    }
    var year = input.substring(0, 4);
    var number = int.parse((input.substring(4)));
    return "$number/$year";
  }
  
  String internal(String input) {
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
