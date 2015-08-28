part of webuiSample;

class PersonDetailCtrl extends DefaultDetailCtrl {

  static  List<Map> zipcodes = [
    {'uid':'1000', 'name':'København'},
    {'uid':'2100', 'name':'København Ø'},
    {'uid':'2200', 'name':'København N'},
    {'uid':'2300', 'name':'København S'},
    {'uid':'2500', 'name':'Valby'},
  ];

  PersonDetailCtrl() : super(new PersonDetailView(), "Person");

  List<Future> loadTypes(PersonDetailView view) {
    view.zipCodes = zipcodes;
    return new List();
  }

}