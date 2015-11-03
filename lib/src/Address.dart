
library address;

import 'dart:html';
import 'EventBus.dart';

class Address {
  
  static const eventAddressChanged = "AddressChanged";
  
  String _current = "";
  static Address _instance = null;
  
  Address._internal() {
    window.onHashChange.listen((event) {
      if (_current != window.location.href) {
        _current = window.location.href;
        EventBus.instance.fire(eventAddressChanged);
      }
    });
  }
  
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
    var newUrl = "";
    if (address.startsWith("http")) {
      newUrl = address;
    }
    else {
      var urls = window.location.href.split("#");
      if (urls.length >= 1) {
        newUrl = "${urls[0]}#${address}";
      }
    }
    // if they match no change is detected => no event
    if (window.location.href == newUrl) {
      window.location.href = "";
    }
    window.location.href = newUrl;
  }
  
  void back() {
    window.history.back();
  }
}
