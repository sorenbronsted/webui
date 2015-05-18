
part of server;

class Person {
  String uid;
  String name;
  String address;
  int zipcode;
  String town;
  
  toJson() {
    var result = {'uid':uid,'name':name,'address':address,'zipcode':zipcode,'town':town};
    return result;
  }
  
  static parse(String content) {
    print(content);
    var person = new Person();
    person.uid = '';
    
    var fields = content.split('&');
    for(var field in fields) {
      var values = field.split('=');
      print(values);
      if (values.length == 2) {
        switch(values[0]) {
          case 'uid':
            person.uid = values[1];
            break;
          case 'name':
            person.name = values[1];
            break;
          case 'address':
            person.address = values[1];
            break;
          case 'zipcode':
            person.zipcode = int.parse(values[1]);
            break;
          case 'town':
            person.town = values[1];
            break;
        }
      }
    }
    return person;
  }
}