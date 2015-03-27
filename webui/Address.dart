
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
  
  void goto(String address) {
    if (address.startsWith("http")) {
      window.location.href = address;
    }
    else {
      var urls = window.location.href.split("#");
      if (urls.length >= 1) {
        window.location.href = "${urls[0]}#${address}";
      }
    }
  }
  
  String get current => _current;

  void back() {
    window.history.back();
  }
  
  String getHashUrl() {
    if (_current.contains("#")) {
      var urls = _current.split("#");
      return urls[1];
    }
    return null;
  }
  
  List<String> getHashUrlElements() {
    var url = getHashUrl();
    if (url != null) {
      return url.split("/");
    }
    return null;
  }
}
