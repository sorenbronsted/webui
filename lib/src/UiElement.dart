part of webui;

abstract class UiElement implements Observer {
  String _cls;
  HtmlElement _element;
  ObjectStore _store;

  String get cls => _element.attributes['data-class'] != null ? _element.attributes['data-class'] : _cls;
  String get property => _element.attributes['data-property'];
  String get uid => _element.attributes['data-uid'];
  String get type => _element.attributes['data-type'];
  String get format => _element.attributes['data-format'];
  HtmlElement get htmlElement => _element;
  ObjectStore get store => _store;

  UiElement(this._element, [this._cls]);

  attach(ObjectStore store) {
    store.attach(this, new Topic(cls, property, uid));
    _store = store;
  }

  detach(ObjectStore store) {
    store.detach(this, new Topic(cls, property, uid));
    _store = null;
  }
}