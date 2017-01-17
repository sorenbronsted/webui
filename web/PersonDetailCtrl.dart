part of webuiSample;

class PersonDetailCtrl extends DefaultDetailCtrl {

  static  List<Map> zipcodes = [
    {'Zipcode':{'uid':'1000', 'name':'København'}},
    {'Zipcode':{'uid':'2100', 'name':'København Ø'}},
    {'Zipcode':{'uid':'2200', 'name':'København N'}},
    {'Zipcode':{'uid':'2300', 'name':'København S'}},
    {'Zipcode':{'uid':'2500', 'name':'Valby'}},
  ];

  PersonDetailCtrl() : super(new PersonDetailView("Person"));

  List<Future> preLoad() {
    store.add(zipcodes);
    return [];
  }

}