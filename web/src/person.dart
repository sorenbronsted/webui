part of webui_demo;

class PersonListCtrl extends CrudController {
	PersonListCtrl(ViewBase view) : super(Uri.parse('list/person'), view);
}

class PersonDetailCtrl extends CrudController {
	PersonDetailCtrl(ViewBase view) : super(Uri.parse('detail/person'), view);
}

class Person extends CrudProxy {
}
