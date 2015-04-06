
part of validator;

typedef void Validate(InputElement element);

class Validators {

  Map<String,Validate> _methods;
  
  Validators() {
    _methods = new Map();
    setMethod("required", required);
    setMethod("date", date);
    //TODO setMethod("datetime", datetime);
    setMethod("caseNumber", caseNumber);
    setMethod("amountInt", amountInt);
    setMethod("amount", amount);
    setMethod("email", email);
  }
  
  getMethod(String name) => _methods[name];
  
  setMethod(String name, Validate func) => _methods[name] = func;
  
  required(InputElement element) {
    if (element.value.trim().isEmpty) {
      throw "Skal udfyldelse";
    }
  }

  /* All '-' (delimiters) are removed.
   * What remains will interpret as:
   * d      => day in current month and year
   * dd     => day in current month and year
   * ddm    => day and month i current year
   * ddmm   => day and month i current year
   * ddmmy  => if year < 40 : y + 2000 ? y + 19000 
   * ddmmyy => if year < 40 : y + 2000 ? y + 19000
   * ddmmyyyy 
   * anything else is an error
   */ 
  date(InputElement element) {
    var msg = "Dato er ikke en gyldig, fx ddmmyy.";
    var value = element.value.trim();
    if (value.isEmpty) {
      return;
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
          throw msg;
      }
    }
    on FormatException {
      throw msg;
    }
    var dd = (test.day < 10 ? "0${test.day}" : "${test.day}");
    var mm = (test.month < 10 ? "0${test.month}" : "${test.month}");
    var yyyy = "${test.year}";
    element.value = "$dd-$mm-$yyyy";
  }

  caseNumber(InputElement element) {
    var msg = "Sagsnr er ikke gyldigt, Fx 10/01 eller 20010001.";
    var value = element.value.trim();
    try {
      var number = 0;
      if (value.indexOf("/") >= 0) {
        var tmp = value.split("/");
        if (tmp.length != 2) {
          throw msg;
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
        throw msg;
      }
    } 
    on FormatException {
      throw msg;
    }
  }

  amountInt(InputElement element) {
    var msg = "Beløb er ikke gyldigt, 1.234";
    try {
      var value = element.value.trim();
      if (!value.isEmpty) {
        value = value.replaceAll(".", "");
        int.parse(value);
      }
    }
    on FormatException {
      throw msg;
    }
  }

  amount(InputElement element) {
    var msg = "Beløb er ikke gyldigt, 1.234,45";
    try {
      var value = element.value.trim();
      if (!value.isEmpty) {
        value = value.replaceAll(".","").replaceAll(",", ".");
        double.parse(value);
      }
    }
    on FormatException {
      throw msg;
    }
  }

  email(InputElement element) {
    var msg ="Email er ikke gyldig";
    var reg = new RegExp("^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\$");
    var value = element.value.trim().toLowerCase();
    if (!value.isEmpty && !reg.hasMatch(value)) {
      throw msg;
    }
  }
}