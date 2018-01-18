part of webui_demo;

class PersonDetailView extends ui.DefaultDetailElement {
  PersonDetailView() : super(Person.NAME);
}

class PersonDetailMediator extends ui.DefaultDetailMediator {
  PersonDetailMediator() : super(Person.NAME, 'detail/${Person.NAME}', new PersonDetailView());
}

class PersonListView extends ui.DefaultListElement {
  PersonListView() : super(Person.NAME);
}

class PersonListMediator extends ui.DefaultListMediator {
  PersonListMediator() : super(Person.NAME, 'list/${Person.NAME}', new PersonListView());
}
