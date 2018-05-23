part of webui;

class Controller extends Observer {
	List<ViewBase> _views;

	Controller(ViewBase view) : this.views([view]);

	Controller.views(this._views) {
		_views.forEach((view) {
			view.addEventListener(this);
			addEventHandler(view.eventPropertyChanged, changed);

			Set<String> classes = new HashSet();
			classes.addAll(view.classes);
			classes.addAll(view.dataLists);
			classes.add('${CurrentViewState}');

			classes.forEach((String cls) {
				log.fine('view data class: ${cls}');
				Proxy proxy = Repo.instance.getByName(cls);
				if (proxy != null) {
					proxy.addEventListener(this);
					addEventHandler(proxy.eventReadOk, populate);
					addEventHandler(proxy.eventReadFail, fail);
				}
			});
		});
	}

	ViewBase getViewByType(Type type) => _views.firstWhere((view) => type == view.runtimeType);

	void changed(Type sender, ElementValue elem) {
		Proxy proxy = Repo.instance.getByName(elem.cls);
		proxy.setProperty(elem);
	}

	void populate(Type sender, Object value) {
		log.fine('populate sender: ${sender}');
		_views.forEach((view) => view.populate(sender, value));
	}

	void fail(Type sender, Object value) {
		log.fine('fail sender: ${sender}');
		throw value;
	}
}

class CrudController extends Controller {
	Uri _activationUri;

	CrudController(Uri activationUri, ViewBase view) : this.views(activationUri, [view]);

	CrudController.views(this._activationUri, List<ViewBase> views) : super.views(views) {
		Router router = Repo.instance.getByType(Router);
		router.addEventListener(this);
		addEventHandler(router.eventReadOk, _show);

		addEventHandler('create', create);
		addEventHandler('delete', delete);
		addEventHandler('save', update);
		addEventHandler('cancel', cancel);
		addEventHandler('edit', edit);
		addEventHandler('find', find);

		_views.forEach((ViewBase view) {
			view.classes.forEach((String cls) {
				Proxy proxy = Repo.instance.getByName(cls);
				if (proxy != null && proxy is Proxy) {
					addEventHandler(proxy.eventCreateOk, populate);
					addEventHandler(proxy.eventCreateFail, fail);
					addEventHandler(proxy.eventUpdateOk, back);
					addEventHandler(proxy.eventUpdateFail, showErrors);
					addEventHandler(proxy.eventDeleteOk, reload);
					addEventHandler(proxy.eventDeleteFail, fail);
				}
			});
		});
	}

	void _show(Type sender, Uri uri) {
		log.fine('show, sender: ${sender}');

		if (uri.pathSegments.length < 2) {
			log.info('Wrong request uri: ${uri}');
			return;
		}

		Proxy proxy = Repo.instance.getByName(uri.pathSegments[1]);
		if (proxy == null) {
			throw "No proxy found for cls: ${uri.pathSegments[1]}";
		}
		if (uri.pathSegments.sublist(0,2).join('/').toLowerCase() != _activationUri.toString().toLowerCase()) {
			// Don't listen for events, when not active
			proxy.removeEventListener(this);
			return;
		}
		log.fine('show, match found on activation uri ${_activationUri}');
		// Start listening on events
		proxy.addEventListener(this);

		// display view
		_views.forEach((view) {
			(view as View).show();

			// read datalist which are M-1 relations to proxy
			view.dataLists.forEach((String name) {
				log.fine('loading datalist: ${name}');
				Proxy proxy = Repo.instance.getByName(name);
				proxy?.read();
			});
		});


		if (uri.pathSegments.length == 2) {
			proxy.read();
		}
		else {
			if (uri.pathSegments.last == 'new') {
				proxy.create();
			}
			else {
				proxy.read(int.parse(uri.pathSegments.last));
				// read other data-class which relation is 1-M to this proxy
				_views.forEach((view) {
					view.classes.forEach((name) {
						if (name == proxy.cls) {
							return;
						}
						log.fine('loading dataclasses: ${name}');
						Proxy related = Repo.instance.getByName(name);
						related.read(int.parse(uri.pathSegments.last));
					});
				});
			}
		}

		onShow(uri);
	}

	void onShow(Uri uri)  {}

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
		_views.forEach((view) => (view as View).showErrors(value));
	}

  void edit(Type sender, ElementValue element) {
		log.fine('edit: sender ${sender} element value: ${element}');
		Router router = Repo.instance.getByType(Router);
		router.goto(Uri.parse(Uri.parse(element.value).fragment));
  }

  void create(Type sender, ElementValue element) {
		log.fine('create sender ${sender} element value: ${element}');
		Router router = Repo.instance.getByType(Router);
		router.goto(Uri.parse('detail/${element.cls}/new'));
	}

	void update(Type sender, ElementValue element) {
		log.fine('update sender ${sender} element value: ${element}');
		Proxy proxy = Repo.instance.getByName(element.cls);
		if (proxy == null) {
			log.info('click, no proxy found for cls: ${element.cls}');
			return;
		}
		proxy.update(element.uid);
	}

	void delete(Type sender, ElementValue element) {
		log.fine('delete sender ${sender} element value: ${element}');
		Proxy proxy = Repo.instance.getByName(element.cls);
		if (proxy == null) {
			log.info('click, no proxy found for cls: ${element.cls}');
			return;
		}
		if (!window.confirm('Er du sikker på du vil slette denne?')) {
			return;
		}
		proxy.delete(element.uid);
	}

	void cancel(Type sender, ElementValue element) {
		log.fine('cancel sender ${sender} element value: ${element}');
		Router router = Repo.instance.getByType(Router);
		var firstDirty = _views.firstWhere((view) => view.isDirty, orElse: () => null);
		if (firstDirty == null) { // No dirty views found
			router.back();
		}
		else if (window.confirm("Dine ændringer er ved at gå tabt. Vil du fortsætte?")) {
			router.back();
		}
	}

	void find(Type sender, ElementValue element) {
		log.fine('find sender ${sender} element value: ${element}');
		Proxy proxy = Repo.instance.getByName(element.cls);
		if (proxy == null) {
			log.info('click, no proxy found for cls: ${element.cls}');
			return;
		}
		proxy.read();
	}
}

