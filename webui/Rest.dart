
library rest;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'EventBus.dart';

typedef void RestError(String text);

class Rest {
  static Rest _instance;
  RestError _errorHandler;

  Rest._internal() {
    // Default error handler
    _errorHandler = (text) {
      print(text);
    };
  }
  
  static Rest get instance {
    if (_instance == null) {
      _instance = new Rest._internal();
    }
    return _instance;
  }

  set errorHandler(RestError handler) => _errorHandler = handler;
  
  Future load(String url) {
    Completer c = new Completer();
    var req = new HttpRequest();
    req.open('GET', url);
    req.onReadyStateChange.listen((Event e) {
      if (req.readyState == HttpRequest.HEADERS_RECEIVED) {
        EventBus.instance.fire("RestRequestStart");
      }
      else if (req.readyState == HttpRequest.DONE) {
        EventBus.instance.fire("RestRequestDone");
        switch (req.status) {
          case 0:
          case 200:
            c.complete(req.responseText);
            break;
          default:
            _errorHandler("Ups! http result code: ${req.status}");
        }
      }
    });
    req.send();
    return c.future;
  }
  
  Future get(String url) {
    return _execute('GET', url);
  }
  
  Future post(String url, Map data) {
    var encodedData = encodeMap(data);
    return _execute('POST', url, encodedData);
  }
  
  Future postFile(String url, dynamic data) {
    return _execute('POST', url, data);
  }
  
  Future delete(String url) {
    return _execute('DELETE', url);
  }

  Future _execute(String method, String url, [dynamic data]) {
    Completer c = new Completer();
    var req = new HttpRequest();
    req.onReadyStateChange.listen((Event e) {
      if (req.readyState == HttpRequest.OPENED) {
        EventBus.instance.fire("RestRequestStart");
      }
      else if (req.readyState == HttpRequest.DONE) {
        EventBus.instance.fire("RestRequestDone");
        switch (req.status) {
          case 0:
          case 200:
            var data = null;
            var errors = false;
            if (req.responseText.length > 0) {
              data = JSON.decode(req.responseText);
              if (data is Map) {
                if (data['error'] != null) {
                  errors = true;
                  c.completeError(data['error']); //Futures must do the error them self
                  //_errorHandler(data['error']);
                }
              }
            }
            if (!errors) {
              c.complete(data);
            }
            break;
          default:
            _errorHandler("Ups! http result code: ${req.status}");
        }
      }
    });
    req.open(method, url);
    if (method == 'POST') {
      req.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    }
    req.send(data);
    return c.future;
  }
  
  String encodeMap(Map data) {
    StringBuffer sb = new StringBuffer();
    sb.writeAll(data.keys.map((k) {
      return data[k] != null ? '${Uri.encodeComponent(k)}=${Uri.encodeComponent(data[k])}' : '';
    }), '&');
    return sb.toString();
  }
}
