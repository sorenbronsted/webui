
library rest;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';

typedef void RestError(String text);

class RestEvent {
  static const String Start = 'Start';
  static const String Done = 'Done';
}

class Rest {
  final Logger log = new Logger('Rest');

  static Rest _instance;
  RestError _errorHandler;

  Rest._internal() {
    // Default error handler
    _errorHandler = (text) {
      log.shout(text);
    };
  }
  
  static Rest get instance {
    if (_instance == null) {
      _instance = new Rest._internal();
    }
    return _instance;
  }

  set errorHandler(RestError handler) => _errorHandler = handler;
  
  Future get(String url) {
    return _execute('GET', url);
  }
  
  Future post(String url, Map data) {
    var encodedData = encodeMap(data);
    return _execute('POST', url, encodedData, 'application/x-www-form-urlencoded');
  }
  
  Future postFile(String url, File file) {
    var formData = new FormData();
    formData.appendBlob('file', file, file.name);
    return _execute('POST', url, formData);
  }
  
  Future delete(String url) {
    return _execute('DELETE', url);
  }

  Future _execute(String method, String url, [dynamic data, String encoding]) {
    Completer c = new Completer();
    var req = new HttpRequest();
    req.onReadyStateChange.listen((Event e) {
      if (req.readyState == HttpRequest.OPENED) {
        //TODO EventBus.instance.fire(this, new BusEvent(RestEvent.Start));
      }
      else if (req.readyState == HttpRequest.DONE) {
        //TODO EventBus.instance.fire(this, new BusEvent(RestEvent.Done));
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
    if (encoding != null) {
      req.setRequestHeader('Content-type', encoding);
    }
    req.send(data);
    return c.future;
  }

  String encodeMap(Map data) {
    StringBuffer sb = new StringBuffer();
    sb.writeAll(data.keys.map((k) {
      return data[k] != null ? '${Uri.encodeComponent(k)}=${Uri.encodeComponent('${data[k]}')}' : '';
    }), '&');
    return sb.toString();
  }
}
