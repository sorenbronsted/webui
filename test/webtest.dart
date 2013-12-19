
library uitest;

//import 'dart:async';
import 'dart:io';
import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

void main() {
  var driver = new WebDriver('localhost', 4444, '/wd/hub');
  WebDriverSession session = null;
  var completionCallback;

  var exceptionHandler = (e) {
    print('Handled: ${e.toString()}');
    if (session != null) {
      session.close().then((_){
        session = null;
      });
    }
    return true;
  };

  group('Pensionrecipients test', () {
    setUp(() {
      completionCallback = expectAsync0((){
      });
    });

    test('Load', () {
      Future f = driver.newSession('chrome');
      f.catchError(exceptionHandler);
      f.then((_session) {
        session = _session;
        return session.setUrl('http://local-ras');
      }).then((_) {
        return session.findElement('name', 'case_number');
      }).then((element) {
        session.sendKeyStrokesToElement(element['ELEMENT'], ['1','9','6','0','0','1','3','3', 'U+E006']);
      }).then((_) {
        return session.findElement('id', 'list');
      }).then((element) {
        print(element);
        return session.close();
      }).then((_) {
        session = null;
        completionCallback();
      });
    });
  });
  
}