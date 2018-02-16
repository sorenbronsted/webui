part of webui;

class Controller extends Observer {
	ViewBase _view;

	Controller(this._view) {
		_view.addEventHandler(_view.eventPropertyChanged, _inputChanged);
		_view.classes.forEach((String cls) {
			CrudProxy proxy = Repo.instance.getByName(cls);
			if (proxy != null) {
				proxy.addEventHandler(proxy.eventReadOk, populate);
				proxy.addEventHandler(proxy.eventReadFail, fail);
			}
		});
	}

	void _inputChanged(Type sender, ElementValue value) {
		Proxy proxy = Repo.instance.getByName(value.cls);
		proxy.setProperty(value);
	}

	void populate(Type sender, Object value) {
		log.fine('populate sender: ${sender}');
		_view.populate(sender, value);
	}

	void fail(Type sender, Object value) {
		log.fine('fail sender: ${sender}');
		throw value;
	}
}

class CrudController extends Controller {
	Uri _activationUri;
	Map<String, Function> _methodMap;

	View get view => _view;

	CrudController(this._activationUri, View view) : super(view){
		Router router = Repo.instance.getByType(Router);
		router.addEventHandler(router.eventReadOk, show);

		_methodMap = {
			'create' : create,
			'delete' : delete,
			'save' : update,
			'cancel' : cancel,
			'edit' : edit,
		};
	}

	void show(Type sender, Uri uri) {
		log.fine('show, sender: ${sender}');

		if (uri.pathSegments.length < 2) {
			log.info('Wrong request uri: ${uri}');
			return;
		}

		if (uri.pathSegments.sublist(0,2).join('/').toLowerCase() != _activationUri.toString().toLowerCase()) {
			_removeEventHandlers();
			return;
		}
		view.show();
		_addEventHandlers();
		CrudProxy proxy = Repo.instance.getByName(uri.pathSegments[1]);
		if (proxy != null) {
			if (uri.pathSegments.length == 2) {
				proxy.readBy();
			}
			else {
				if (uri.pathSegments.last == 'new') {
					proxy.create();
				}
				else {
					proxy.read(int.parse(uri.pathSegments.last));
				}
			}
		}
	}

  void click(Type sender, ElementValue element) {
		log.fine('click sender: ${sender} element value: ${element}');
		Function f = _methodMap[element.property];
		if (f == null) {
			log.info('click, no function found for property: ${element.property}');
			return;
		}
		CrudProxy proxy = Repo.instance.getByName(element.cls);
		if (proxy == null) {
			log.info('click, no proxy found for cls: ${element.cls}');
			return;
		}
		f(element, proxy);
  }


	void back(Type sender, Object value) {
		log.fine('back sender: ${sender}');
		Router router = Repo.instance.getByType(Router);
		router.back();
	}

	void reload(Type sender, Object value) {
		log.fine('reload sender: ${sender}');
		Router router = Repo.instance.getByType(Router);
		router.reload();
	}

	void showErrors(Type sender, Object value) {
		log.fine('showErrors sender: ${sender}');
		(_view as View).showErrors(value);
	}

  void edit(ElementValue element, CrudProxy proxy) {
		log.fine('edit element value: ${element} proxy: ${proxy}');
		Router router = Repo.instance.getByType(Router);
		router.goto(Uri.parse(Uri.parse(element.value).fragment));
  }

  void create(ElementValue element, CrudProxy proxy) {
		log.fine('create element value: ${element} proxy: ${proxy}');
		Router router = Repo.instance.getByType(Router);
		router.goto(Uri.parse('detail/${proxy.cls}/new'));
	}

	void update(ElementValue element, CrudProxy proxy) {
		log.fine('update element value: ${element} proxy: ${proxy}');
		proxy.update(element.uid);
	}

	void delete(ElementValue element, CrudProxy proxy) {
		log.fine('delete element value: ${element} proxy: ${proxy}');
		if (!window.confirm('Er du sikker på du vil slette denne?')) {
			return;
		}
		proxy.delete(element.uid);
	}

	void cancel(ElementValue element, CrudProxy proxy) {
		log.fine('cancel element value: ${element} proxy: ${proxy}');
		Router router = Repo.instance.getByType(Router);
		if (!view.isDirty) {
			router.back();
		}
		else if (window.confirm("Dine ændringer er ved at gå tabt. Vil du fortsætte?")) {
			router.back();
		}
	}

  void _removeEventHandlers() {
		view.removeEventHandler(view.eventClick, click);
		view.classes.forEach((String cls) {
			CrudProxy proxy = Repo.instance.getByName(cls);
			if (proxy != null) {
				proxy.removeEventHandler(proxy.eventCreateOk, populate);
				proxy.removeEventHandler(proxy.eventCreateFail, fail);
				proxy.removeEventHandler(proxy.eventUpdateOk, back);
				proxy.removeEventHandler(proxy.eventUpdateFail, showErrors);
				proxy.removeEventHandler(proxy.eventDeleteOk, reload);
				proxy.removeEventHandler(proxy.eventDeleteFail, fail);
			}
		});
	}

  void _addEventHandlers() {
		view.addEventHandler(view.eventClick, click);
		view.classes.forEach((String cls) {
			CrudProxy proxy = Repo.instance.getByName(cls);
			if (proxy != null) {
				proxy.addEventHandler(proxy.eventCreateOk, populate);
				proxy.addEventHandler(proxy.eventCreateFail, fail);
				proxy.addEventHandler(proxy.eventUpdateOk, back);
				proxy.addEventHandler(proxy.eventUpdateFail, showErrors);
				proxy.addEventHandler(proxy.eventDeleteOk, reload);
				proxy.addEventHandler(proxy.eventDeleteFail, fail);
			}
		});
	}
}

