
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
    return _execute(classes, value, (Formatter fmt, String value) => fmt.display(value));
  }

  static String internal(Iterable classes, String value) {
    assert(classes != null);
    assert(value != null);
    return _execute(classes, value, (Formatter fmt, String value) => fmt.internal(value));
  }

  static String _execute(Iterable classes, String value, callback) {
    assert(classes != null);
    assert(callback != null);

    if (_formatters == null) {
      _formatters = new Map();
      _loadFormatters();
    }
    var i = classes.iterator;
    while (i.moveNext()) {
      var classId = i.current;
      var formatter = _formatters[classId];
      if (formatter != null) {
        return callback(formatter, "$value");
      }
    }
    return "$value";
  }
  
  static _loadFormatters() {
    addFormatter("date", new DateFmt());
    addFormatter("datetime", new DateTimeFmt());
    addFormatter("amountInt", new AmountFmt(0));
    addFormatter("amount", new AmountFmt(2));
    addFormatter("caseNumber", new CaseNumberFmt());
  }
}

class DateFmt implements Formatter {
  // Excepted input format yyyy-mm-dd
  String display(String input) {
    assert(input != null);
    var tmp = input.split("-");
    if (tmp.length != 3) {
      return input;
    }
    return "${tmp[2]}-${tmp[1]}-${tmp[0]}";
  }
  
  // Excepted input format is dd-mm-yyyy
  String internal(String input) {
    assert(input != null);
    var tmp = input.split("-");
    if (tmp.length != 3) {
      return input;
    }
    return "${tmp[0]}-${tmp[1]}-${tmp[2]}";
  }
}

class DateTimeFmt implements Formatter {
  // Excepted input format yyyy-mm-dd hh:mm:ss
  String display(String input) {
    var tmp = input.split(" ");
    if (tmp.length != 2) {
      return input;
    }

    var fmt = new DateFmt();
    var date = fmt.display(tmp[0]);
    var time = tmp[1];
    return "${date} ${time}";
  }
  
  // Excepted input format is dd-mm-yyyy hh:mm:ss
  String internal(String input) {
    if (input.length == 0) {
      return input;
    }
    var parts = input.split(" ");
    assert(parts.length == 2);
    var tmp = parts[0].split("-");
    if (tmp.length != 3) {
      return input;
    }
    return "${tmp[0]}-${tmp[1]}-${tmp[2]} ${parts[1]}";
  }
}

class AmountFmt implements Formatter {
  int _decimalCount;
  
  AmountFmt(this._decimalCount) {
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
    if (year < 40) {
      year += 2000;
    }
    else {
      year += 1900;
    }
    var number = int.parse(tmp[0]);
    return "${year*10000+number}";
  }
}
