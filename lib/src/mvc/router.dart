part of webui;

class Router extends Proxy {
	ListQueue<Uri> _history;

  void goto(Uri uri) {
  	log.fine('goto uri: ${uri}');
  	if (_history.isNotEmpty && _history.first.toString() == uri.toString()) {
  		return;
		}
		_history.addFirst(uri); // push
  	fire(eventReadOk, _history.first);
  }

	Router() {
		_history = new ListQueue<Uri>();
	}

	@override
  void setProperty(ElementValue element) {
		log.fine('setProperty element value: ${element}');
  	if (element.cls == cls && element.property == 'uri') {
			goto(Uri.parse(element.value));
		}
  }

  @override
  void read(int uid) {
    throw "Not implemented";
  }

	void back() {
		log.fine('back');
		if (_history.length <= 1) {
			log.fine('back history.length <= 1');
			return;
		}
		_history.removeFirst(); // pop
		fire(eventReadOk, _history.first);
	}

	void reload() {
		log.fine('reload');
		fire(eventReadOk, _history.first);
	}
}

class RouterView extends ViewBase {

  RouterView() {
  	window.onHashChange.listen((event) {
			Uri uri = Uri.parse(Uri.parse(window.location.href).fragment);
  		fire(eventPropertyChanged, new ElementValue('${Router}', 'uri', 0, uri.toString()));
		});
	}

  @override
  Set<String> get classes => ['${Router}'].toSet();

  @override
  void populate(Type sender, Object value) {
  	String fragment = value.toString();
		if (fragment == null || fragment.isEmpty) {
			return;
		}
		var newUrl = "";
		if (fragment.startsWith("http")) {
			newUrl = fragment;
		}
		else {
			newUrl = "${window.location.origin}/#${fragment}";
		}
		window.location.href = newUrl;
  }

  @override
  bool get isVisible => true;
}

class RouterCtrl extends Controller {
	RouterCtrl(RouterView view) : super(view);
}