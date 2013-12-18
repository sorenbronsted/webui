
part of webuiSample;

class PersonListCtrl extends BaseListCtrl {
  
  PersonListCtrl(EventBus eventBus) : super(eventBus, new PersonListView(), "Person") {}
  
  populateView(BaseListView view, String urlPrefix) {
    Future f = Rest.instance.get('/rest/Person');
    f.then((data) {
      view.populate(data, urlPrefix);
    });
  }
}