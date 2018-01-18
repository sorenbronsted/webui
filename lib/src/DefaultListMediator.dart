part of webui;

abstract class DefaultListMediator extends BaseMediator {
	final Logger log = new Logger('DefaultListMediator');
	String _proxyName;

	DefaultListElement get view => viewComponent;
	ModelClass get proxy => facade.retrieveProxy(_proxyName);

	DefaultListMediator(this._proxyName, String mediatorName, ViewElement view) : super(mediatorName, view);

	void onRegister() {
		view.addEventHandler(ViewElementEvent.Create, handleEvent);
		view.addEventHandler(ViewElementEvent.Link, handleEvent);
		view.addEventHandler(ViewElementEvent.Delete, handleEvent);
	}

	List<String> listNotificationInterests() {
		return [ModelEvent.DeleteOk, ModelEvent.DeleteFail, ModelEvent.ReadOk, ModelEvent.ReadFail];
	}

	// Handle events from the view component
	void handleEvent(String name, Event event) {
		log.fine('Name ${name} Event ${event}');
		switch (name) {
			case ViewElementEvent.Create:
				sendNotification(AppEvent.Goto, 'detail/${_proxyName}/new');
				break;
			case ViewElementEvent.Link:
				Uri uri = Uri.parse((event.target as AnchorElement).href);
				sendNotification(AppEvent.Goto, uri.fragment);
				break;
			case ViewElementEvent.Delete:
				if (!view.confirm('Er du sikker på du vil slette denne?')) {
					return;
				}
				Uri uri = Uri.parse(Uri.parse((event.target as AnchorElement).href).fragment);
				proxy.delete(uri.pathSegments.last);
				break;
		}
	}

	// Called when a notification this Mediator is interested in is sent
	@override
	void handleNotification(mvc.INotification note) {
		log.fine('Note.name ${note.name} Note.body ${note.body}');
		switch(note.name) {
			case ModelEvent.DeleteOk:
				sendNotification(AppEvent.Goto, 'list/${_proxyName}');
				break;
			case ModelEvent.ReadOk:
				view.table.rows = note.body;
				break;
			case ModelEvent.DeleteFail:
			case ModelEvent.ReadFail:
				throw note.body;
				break;
		}
	}

	@override
	void requestData(Uri uri) {
		proxy.readBy({});
	}
}
