
library server;

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:mime_type/mime_type.dart' as mime;

part 'Person.dart';

class Server {
  
  String _basePath;
  Map<String, Person> _persons;
  
  Server(String this._basePath) {
    print("basePath ${_basePath}");
    _persons = {};
  }
  
  _sendNotFound(HttpResponse response) {
    response.statusCode = HttpStatus.NOT_FOUND;
    response.close();
  }
  
  _procesRest(HttpRequest request, String content) {
    HttpResponse res = request.response;
    switch(request.method) {
      case 'POST':
        var p = Person.parse(content);
        if (p.uid.length == 0) {
          p.uid = "${_persons.length + 1}";
        }
        _persons[p.uid] = p;
        break;
      case 'DELETE':
        if (request.uri.pathSegments.length == 3) { // eg /rest/person/1
          var uid = request.uri.pathSegments.last;
          if (_persons.containsKey(uid)) {
            _persons.remove(uid);          
          }
        }
        else {
          res.statusCode = HttpStatus.NOT_FOUND;
        }
        break;
      case 'GET':
        if (_persons.length == 0) {
          var s = JSON.encode([]);
          res.write(s);
        }
        else if (request.uri.pathSegments.length == 2) { // eg. /rest/person
          print(_persons.values);
          var s = JSON.encode(new List.from(_persons.values));
          res.write(s);
        }          
        else if (request.uri.pathSegments.length == 3) { // eg /rest/person/1
          var uid = request.uri.pathSegments.last;
          if (_persons.containsKey(uid)) {
            var s = JSON.encode(_persons[uid]);
            res.write(s);
          }
          else {
            res.statusCode = HttpStatus.NOT_FOUND;
          }
        }
        else {
          res.statusCode = HttpStatus.NOT_FOUND;
        }
        break;
    }
  }
  
  _rest(HttpRequest request) {
    HttpResponse res = request.response;
    List<int> body = [];
    request.listen((List<int> buffer) => body.addAll(buffer),
      onDone: () {
        var content = new String.fromCharCodes(body);
        _procesRest(request, content);
        res.close();
      },
      onError: (error) {
        throw "request failed ${error}";
      }
    );
  }
  
  _file(HttpRequest request) {
    HttpResponse res = request.response;
    final String stringPath = request.uri.path == '/' ? '/index.html' : request.uri.path;
    final File file = new File('${_basePath}${stringPath}');
    file.exists().then((bool found) {
      if (found) {
        res.headers.contentType = ContentType.parse(mime.mime(file.path)); 
        file.openRead().pipe(request.response).catchError((e) { 
          res.statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
          res.close();
        });
      } 
      else {
        _sendNotFound(res);
      }
    });
  }
  
  run() {
    HttpServer.bind('127.0.0.1', 8080).then((server) {
      server.listen((HttpRequest request) {
        print("request: ${request.method} ${request.uri.path}");
        if (!path.isAbsolute(request.uri.path)) {
          _sendNotFound(request.response);
          return;
        }
        if (request.uri.path.startsWith("/rest")) {
          _rest(request);
        }
        else {
          _file(request);
        }
      });
    });
  }
}


main() {
  // Compute base path for the request based on the location of the
  // script and then start the server.
  var server = new Server(path.dirname(Platform.script.toFilePath()));
  server.run();
}
