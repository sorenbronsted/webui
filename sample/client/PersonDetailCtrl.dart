part of webuiSample;

class PersonDetailCtrl extends BaseDetailCtrl {
  
  PersonDetailCtrl(EventBus eventBus) : super(eventBus, new PersonDetailView(), "Person") {}
}