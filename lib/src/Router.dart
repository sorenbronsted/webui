part of webui;

class RouterMediator extends mvc.Mediator {
	static const String NAME = 'Router';
	static const String CHANGED = '${NAME}/changed';

	static String _root = '/';

	String get root => _root;

	Uri get uri => Uri.parse(Uri.parse(window.location.href).fragment);

	void set root(String root) => _root = root;

	RouterMediator() : super(NAME);

	@override
	void onRegister() {
		window.onHashChange.listen((event) {
			sendNotification(CHANGED, uri);
		});
	}

	void goto(String fragment) {
		if (fragment == null || fragment.isEmpty) {
			return;
		}
		var newUrl = "";
		if (fragment.startsWith("http")) {
			newUrl = fragment;
		}
		else {
			newUrl = "${window.location.origin}${_root}#${fragment}";
		}
		if (window.location.href != newUrl) { // If they are the same it will not trigger onHashChange event
			window.location.href = newUrl;
		}
		else {
			sendNotification(CHANGED, uri);
		}
	}

	void back() {
		window.history.back();
	}
}