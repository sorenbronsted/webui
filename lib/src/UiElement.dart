part of webui;

abstract class UiElement  {
  String _cls;
  HtmlElement _element;

  String get cls => _element.attributes['data-class'] != null ? _element.attributes['data-class'] : _cls;
  String get property => _element.attributes['data-property'];
  String get uid => _element.attributes['data-uid'];
  void set uid(String uid) => _element.attributes['data-uid'] = uid;
  String get type => _element.attributes['data-type'];
  String get format => _element.attributes['data-format'];
  HtmlElement get htmlElement => _element;

  UiElement(this._element, [this._cls]);

  void showError(Map fieldsWithError);
}
