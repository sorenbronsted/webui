part of webui;

abstract class UiInputType {
  String get value;
  set value(String value);
  bool get required;
  CssClassSet classes;
  String get title;
  set title(String title);
  String get uiType;
  String get format;
  bool get disabled;
  bool get readOnly;
}