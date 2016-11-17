
import 'dart:convert';
import "package:test/test.dart";
import "../lib/src/ObjectStore.dart";

//TODO make this work with dartium. Se https://pub.dartlang.org/packages/test

class ListenerMock implements ObjectStoreListener {
  int called = 0;
  String cls;
  Object property;

  @override
  void valueChanged(String cls, Object property) {
    called++;
    this.cls = cls;
    this.property = property;
  }
}

void main() {
  ObjectStore store;

  setUp(() {
    store = new ObjectStore();
  });

  test('Test add one object', () {
    ListenerMock listenerClass = new ListenerMock();
    store.addListener(listenerClass, 'Dog');

    ListenerMock listenerProperty = new ListenerMock();
    store.addListener(listenerProperty, 'Dog', 'uid');

    store.add({"Dog":{"uid":1,"name":"Fido"}});

    expect(store.getProperty('Dog','uid'), 1);

    expect(listenerClass.cls, 'Dog');
    expect(listenerClass.property, null);
    expect(listenerClass.called, 1);

    expect(listenerProperty.cls, 'Dog');
    expect(listenerProperty.property, 'uid', );
    expect(listenerProperty.called, 1);
  });

  test('Test add 2 objects', () {
    ListenerMock listenerClass = new ListenerMock();
    store.addListener(listenerClass, 'Dog');

    ListenerMock listenerProperty = new ListenerMock();
    store.addListener(listenerProperty, 'Dog', 'name');

    store.add([{"Dog":{"uid":1,"name":"Fido"}},{"Dog":{"uid":2,"name":"Egon"}}]);

    expect(store.getObjects('Dog').length, 2);
    expect(store.isDirty, false);

    expect(store.getProperty('Dog','name', '1'), 'Fido');
    expect(store.getProperty('Dog','name', '2'), 'Egon');

    expect(listenerClass.cls, 'Dog');
    expect(listenerClass.property, null);
    expect(listenerClass.called, 1);

    // Listener on properties are not called when adding multiple objects
    expect(listenerProperty.cls, null);
    expect(listenerProperty.property, null);
    expect(listenerProperty.called, 0);
  });

  test('Test setProperty', () {
    ListenerMock listenerClass = new ListenerMock();
    store.addListener(listenerClass, 'Dog');
    store.setProperty('Dog', 'name', 'Hund');

    expect(store.getProperty('Dog', 'name'), 'Hund');
    expect(store.isDirty, true);
    expect(store.getProperty('Dog', 'uid'), '0');
    expect(listenerClass.called, 0);
  });

  test('Test class not found', () {
    try {
      store.getObject('Dog');
    } on NotFound catch(e) {
      expect(e.msg.contains('Dog'), true);
    }
  });

  test('Test property not found', () {
    try {
      store.setProperty('Dog', 'name', 'Fido');
      store.getProperty('Dog', 'sex');
    } on NotFound catch(e) {
      expect(e.msg.contains('sex'), true);
    }
  });

  test('Test replace object',() {
    store.add({"Dog":{"uid":'1',"name":"Fido"}});
    expect(store.getProperty('Dog', 'uid'), '1');
    expect(store.getProperty('Dog', 'name'), 'Fido');

    store.replace({"Dog":{"uid":'2',"name":"Egon"}});
    expect(store.getProperty('Dog', 'uid'), '2');
    expect(store.getProperty('Dog', 'name'), 'Egon');
  });

  test('Test replace objects',() {
    store.add([{"Dog":{"uid":'1',"name":"Fido"}},{"Dog":{"uid":'2',"name":"Egon"}}]);
    expect(store.getObjects('Dog').length, 2);

    store.replace([{"Dog":{"uid":'1',"name":"Fido"}}]);
    expect(store.getObjects('Dog').length, 1);
  });

  test('Test addRemoveCollectionProperty', () {
    store.addCollectionProperty('Dog', 'legs', 'front');
    var property = store.getProperty('Dog', 'legs');
    expect(property.length, 1);
    store.addCollectionProperty('Dog', 'legs', 'rear');
    expect(property.length, 2);
    store.removeCollectionProperty('Dog', 'legs', 'rear');
    expect(property.length, 1);
  });

  test('Test addWithName', () {
    store.add({"Dog":{"uid":'1',"name":"Fido"}}, "Cat");
    expect(store.getProperty('Cat', 'uid'), '1');
    expect(store.getProperty('Cat', 'name'), 'Fido');
    expect(store.getProperty('Dog', 'name'), null);
  });
}