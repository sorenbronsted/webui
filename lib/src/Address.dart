
part of webui;

class Address {
  static const eventAddressChanged = "AddressChanged";
  final Logger log = new Logger('Address');

  String _current = "";
  static Address _instance = null;
  String _root = '/';
  
  Address._internal() {
    window.onHashChange.listen((event) {
      log.fine('onHashChange: _current ${_current} location.href ${window.location.href}');
      if (_current != window.location.href) {
        _current = window.location.href;
        EventBus.instance.fire(this, new BusEvent(eventAddressChanged));
      }
    });
  }

  String get root => _root;

  void set root(String root) => _root = root;

  static Address get instance {
    if (_instance == null) {
      _instance = new Address._internal();
    }
    return _instance;
  }

  String get current => _current;

  String get fragment => Uri.parse(_current).fragment;

  List<String> get pathParts => Uri.parse(Uri.parse(_current).fragment).pathSegments;

  Map<String, String> get parameters => Uri.parse(Uri.parse(_current).fragment).queryParameters;

  void goto(String address) {
    log.fine('goto: address ${address} href ${window.location.href}');
    if (address == null || address.isEmpty) {
      return;
    }
    var newUrl = "";
    if (address.startsWith("http")) {
      newUrl = address;
    }
    else {
      newUrl = "${window.location.origin}${_root}#${address}";
    }
    window.location.href = newUrl;
  }
  
  void back() {
    window.history.back();
  }
}
