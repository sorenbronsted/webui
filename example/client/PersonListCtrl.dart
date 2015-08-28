
part of webuiSample;

class PersonListCtrl extends DefaultListCtrl {

  PersonListCtrl() : super(new PersonListView(), "Person");
  
  populateView(PersonListView view, String urlPrefix) {
    Rest.instance.get('/rest/Person').then((data) {
      view.persons = data;
    });
  }
}