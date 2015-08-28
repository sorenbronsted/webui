
part of server;

class Person {
  int uid;
  String name;
  String address;
  int zipcode;
  String town;
  DateTime created;
  DateTime born;
  int time;
  double height;
  
  toJson() {
    return {
      'uid':uid,
      'name':name,
      'address':address,
      'zipcode': zipcode.toString(),
      'town':town,
      'created' : created.toString(),
      'born' : born.toString(),
      'time' : time.toString(),
      'height' : height.toString(),
    };
  }

  toString() {
    return toJson();
  }

  static parse(Map data) {
    var person = new Person();
    person.uid = 0;
    data.forEach((name, value) {
      switch(name) {
        case 'uid':
          person.uid = value;
          break;
        case 'name':
          person.name = value;
          break;
        case 'address':
          person.address = value;
          break;
        case 'zipcode':
          person.zipcode = int.parse(value);
          break;
        case 'town':
          person.town = value;
          break;
        case 'created':
          person.created = DateTime.parse(value);
          break;
        case 'born':
          person.born = DateTime.parse(value);
          break;
        case 'time':
          person.time = int.parse(value.replaceAll(':',''));
          break;
        case 'height':
          person.height = double.parse(value);
          break;
        default:
          throw "Unknown property ${name}";
      }
    });
    return person;
  }
}