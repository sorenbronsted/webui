
import 'dart:core';
import "package:test/test.dart";
import "package:logging/logging.dart";
import "../lib/src/ObjectStore.dart";

class ObserverMock implements Observer {
  int called = 0;

  @override
  void update() {
    called++;
  }
}

void main() {
  ObjectStore store;
  ObserverMock sender;
  ObserverMock dogObserver;
  ObserverMock dogUidObserver;
  int stateChangedCalled = 0;

  Logger.root.level = Level.SEVERE;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  setUp(() {
    store = new ObjectStore();
    sender = new ObserverMock();
    store.attach(sender, new Topic('Cat'));

    dogObserver = new ObserverMock();
    store.attach(dogObserver, new Topic('Dog'));

    dogUidObserver = new ObserverMock();
    store.attach(dogUidObserver, new Topic('Dog', 'uid'));

    store.addStateListener(() => stateChangedCalled++);
    stateChangedCalled = 0;
  });

  test('Test add one object', () {
    store.add(sender, {"Dog":{"uid":1,"name":"Fido"}});

    expect(store.getProperty('Dog','uid'), '1');

    expect(dogObserver.called, 1);
    expect(dogUidObserver.called, 1);
    expect(sender.called, 0);
    expect(stateChangedCalled, 0);
    expect(store.isDirty, false);
  });

  test('Test add 2 objects', () {
    store.add(sender, [{"Dog":{"uid":1,"name":"Fido"}},{"Dog":{"uid":2,"name":"Egon"}}]);

    expect(store.getObjects('Dog').length, 2);
    expect(store.isDirty, false);

    expect(store.getProperty('Dog','name', '1'), 'Fido');
    expect(store.getProperty('Dog','name', '2'), 'Egon');

    expect(dogObserver.called, 1);
    expect(dogUidObserver.called, 1);
    expect(sender.called, 0);
  });

  test('Test setProperty', () {
    ObserverMock nameObserver = new ObserverMock();
    store.attach(nameObserver, new Topic('Dog', 'name'));

    expect(stateChangedCalled, 0);

    store.setProperty(sender, 'Dog', 'name', 'Hund');

    expect(store.getProperty('Dog', 'name'), 'Hund');
    expect(stateChangedCalled, 1);
    expect(store.isDirty, true);
    expect(store.getProperty('Dog', 'uid'), '0');
    expect(dogObserver.called, 0);
    expect(dogUidObserver.called, 0);
    expect(nameObserver.called, 1);
    expect(stateChangedCalled, 1);
  });

  test('Test class not found', () {
    Map object = store.getObject('Dog');
    expect(object.isEmpty, true);
  });

  test('Test property not found', () {
    store.setProperty(sender, 'Dog', 'name', 'Fido');
    expect(store.getProperty('Dog', 'sex'), null);
    expect(sender.called, 0);
  });

  test('Test replace object',() {
    store.add(sender, {"Dog":{"uid":'1',"name":"Fido"}});
    expect(store.getProperty('Dog', 'uid'), '1');
    expect(store.getProperty('Dog', 'name'), 'Fido');

    store.remove(sender, 'Dog');
    store.add(sender, {"Dog":{"uid":'2',"name":"Egon"}});
    expect(store.getProperty('Dog', 'uid'), '2');
    expect(store.getProperty('Dog', 'name'), 'Egon');
  });

  test('Test replace objects',() {
    store.add(sender, [{"Dog":{"uid":'1',"name":"Fido"}},{"Dog":{"uid":'2',"name":"Egon"}}]);
    expect(store.getObjects('Dog').length, 2);

    store.remove(sender, 'Dog');
    store.add(sender, [{"Dog":{"uid":'1',"name":"Fido"}}]);
    expect(store.getObjects('Dog').length, 1);
  });

  test('Test addRemoveCollectionProperty', () {
    store.addCollectionProperty(sender, 'Dog', 'legs', 'front');
    List property = store.getProperty('Dog', 'legs');
    expect(property.length, 1);
    store.addCollectionProperty(sender, 'Dog', 'legs', 'rear');
    expect(property.length, 2);
    store.removeCollectionProperty(sender, 'Dog', 'legs', 'rear');
    expect(property.length, 1);
  });

  test('Test addWithName', () {
    store.add(sender, {"Dog":{"uid":'1',"name":"Fido"}}, "Cat");
    expect(store.getProperty('Cat', 'uid'), '1');
    expect(store.getProperty('Cat', 'name'), 'Fido');
    expect(store.getProperty('Dog', 'name'), null);
    expect(sender.called, 0);
  });
}