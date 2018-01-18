part of webui;

abstract class BaseMediator extends mvc.Mediator {
	final Logger log = new Logger('BaseMediator');
	BaseMediator(String name, ViewElement view) : super(name, view);

	ViewElement get view;

	void display(Uri uri) {
		log.fine('Dislay uri ${uri}');
		view.show();
		requestData(uri);
	}

	void requestData(Uri uri);
}
