
part of server;

class Person {
  int uid;
  String name;
  String address;
  int zipcode;
  String town;
  DateTime created;
  DateTime born;
  DateTime time;
  double height;
  bool lovely;
  int age;
  String sex;
  
  toJson() {
    return {
      'Person': {
        'uid':uid,
        'name':name,
        'address':address,
        'zipcode': zipcode.toString(),
        'town':town,
        'created' : created.toString(),
        'born' : born.toString(),
        'time' : time.toString(),
        'height' : height.toString(),
        'lovely' : lovely.toString(),
        'sex' : sex,
        'age' : age.toString(),
      }
    };
  }

  toString() {
    return toJson();
  }

  static parse(Map data) {
    var person = new Person();
    person.uid = 0;
    data.forEach((String name, String value) {

      switch(name) {
        case 'uid':
          person.uid = int.parse(value.length == 0 ? "0" : value);
          break;
        case 'name':
          person.name = value;
          break;
        case 'address':
          person.address = value;
          break;
        case 'zipcode':
          person.zipcode = (value == 'null' ? null : int.parse(value));
          break;
        case 'town':
          person.town = value;
          break;
        case 'created':
          person.created = (value == 'null' ? null : DateTime.parse(value));
          break;
        case 'born':
          person.born = (value == 'null' ? null : DateTime.parse(value));
          break;
        case 'time':
          person.time = (value == 'null' ? null : DateTime.parse(value));
          break;
        case 'height':
          person.height = (value == 'null' ? null : double.parse(value));
          break;
        case 'age':
          person.age = (value == 'null' ? null : double.parse(value).toInt());
          break;
        case 'lovely':
          person.lovely = (value == 'null' ? null : (value == '1'));
          break;
        case 'sex':
          person.sex = (value == 'null' ? null : value);
          break;
        default:
          print("Unknown property ${name}");
      }
    });
    return person;
  }
}