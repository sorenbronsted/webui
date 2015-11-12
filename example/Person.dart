
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
      'class' : 'Person',
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
    data.forEach((String name, String value) {
      switch(name) {
        case 'Person-class':
          break;
        case 'Person-uid':
          person.uid = int.parse(value.length == 0 ? "0" : value);
          break;
        case 'Person-name':
          person.name = value;
          break;
        case 'Person-address':
          person.address = value;
          break;
        case 'Person-zipcode':
          person.zipcode = int.parse(value);
          break;
        case 'Person-town':
          person.town = value;
          break;
        case 'Person-created':
          person.created = DateTime.parse(value);
          break;
        case 'Person-born':
          person.born = DateTime.parse(value);
          break;
        case 'Person-time':
          person.time = int.parse(value.replaceAll(':',''));
          break;
        case 'Person-height':
          person.height = double.parse(value);
          break;
        default:
          throw "Unknown property ${name}";
      }
    });
    return person;
  }
}