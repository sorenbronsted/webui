part of webui;

class DefaultDetailMediator extends BaseMediator {
	final Logger log = new Logger('DefaultDetailMediator');
	String _proxyName;

	DefaultDetailElement get view => viewComponent;
	ModelClass get proxy => facade.retrieveProxy(_proxyName);

	DefaultDetailMediator(this._proxyName, String mediatorName, ViewElement view) : super(mediatorName, view);

	void onRegister() {
		view.addEventHandler(ViewElementEvent.Save, handleEvent);
		view.addEventHandler(ViewElementEvent.Cancel, handleEvent);
		view.addEventHandler(ViewElementEvent.Change, handleEvent);
	}

	List<String> listNotificationInterests() {
		return [ModelEvent.CreateOk, ModelEvent.ReadOk, ModelEvent.UpdateOk, ModelEvent.CreateFail, ModelEvent.ReadFail, ModelEvent.UpdateFail];
	}

	// Handle events from the view component
	void handleEvent(String name, Event event) {
		log.fine('Name ${name} Event ${event}');
		switch (name) {
			case ViewElementEvent.Save:
				proxy.update(view.form.uid);
				break;
			case ViewElementEvent.Cancel:
				if (view.isDirty) {
					if (view.confirm('Dine ændringer er ved at gå tabt. Vil du fortsætte?') == false) {
						return;
					}
				}
				sendNotification(AppEvent.Cancel);
				break;
			case ViewElementEvent.Change:
				proxy.setProperty(view.form.uid, view.form.getElementName(event.target), view.form.getElementValue(event.target));
				break;
		}
	}

	// Called when a notification this Mediator is interested in is sent
	@override
	void handleNotification(mvc.INotification note) {
		log.fine('Note.name ${note.name} Note.body ${note.body}');
		switch(note.name) {
			case ModelEvent.CreateOk:
			case ModelEvent.ReadOk:
				view.form.values = note.body;
				break;
			case ModelEvent.CreateFail:
			case ModelEvent.ReadFail:
				throw note.body;
				break;
			case ModelEvent.UpdateOk:
				sendNotification(AppEvent.Save);
				break;
			case ModelEvent.UpdateFail:
				view.showErrors(note.body);
				break;
		}
	}

	@override
	void requestData(Uri uri) {
		String uid = uri.pathSegments.last;
		if (uid == 'new') {
			proxy.create();
		}
		else {
			proxy.read(uid);
		}
	}
}
