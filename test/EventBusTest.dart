
import 'package:unittest/unittest.dart';
import '../webui/EventBus.dart';

void main() {
  group('EventBus', () {
    var bus = new EventBus();
    var myEvent = 'myEvent';
    var isCalled = false;
    
    void eventHandler(String event) {
      expect(event, myEvent);
      isCalled = true;
    }
    
    test('initial', () { 
      bus.fire(myEvent);
      expect(isCalled, equals(false));
    });
    
    test('addAndfire', () { 
      bus.addListener(myEvent, eventHandler);
      bus.fire(myEvent);
      expect(isCalled, equals(true));
    });
    
    test('remove', () {
      isCalled = false;
      bus.removeListener(myEvent, eventHandler);
      bus.fire(myEvent);
      expect(isCalled, equals(false));
    });
  });
  
}
