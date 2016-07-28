
import "package:test/test.dart";
import 'package:webui/webui.dart';
//import "../lib/src/ObjectStore.dart";

//TODO make this work with dartium. Se https://pub.dartlang.org/packages/test
void main() {
  test('Test ObjectStore set and get', () {
    var store = new ObjectStore();
    store.set('a.b', 'sletmig');
    expect('sletmig', store.get('a.b'));
  });
}