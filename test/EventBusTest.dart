
import 'package:unittest/unittest.dart';
import '../webui/EventBus.dart';

class Test implements EventBusListener {
  
  static var myEvent = 'myEvent';
  var isCalled = false;

  void eventHandler(String event) {
    expect(event, myEvent);
    isCalled = true;
  }
  
  void stopListening() {
    EventBus.instance.listenOff(myEvent, eventHandler);
  }
  
  @override
  void register(EventBus eventBus) {
    eventBus.listenOn(myEvent, eventHandler);
  }
}

void main() {
  group('EventBus', () {
    var bus = EventBus.instance;
    
    test('initial', () {
      var tst = new Test();
      bus.fire(Test.myEvent);
      expect(tst.isCalled, equals(false));
    });
    
    test('addAndfire', () {
      var tst = new Test();
      bus.register(tst);
      bus.fire(Test.myEvent);
      expect(tst.isCalled, equals(true));
    });
    
    test('remove', () {
      var tst = new Test();
      bus.register(tst);

      tst.stopListening();
      bus.fire(Test.myEvent);
      expect(tst.isCalled, equals(false));
    });
  });
  
}
