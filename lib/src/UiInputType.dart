part of webui;

abstract class UiInputType {
  String get value;
  set value(String value);
  Map<String, String> get attributes;
  bool get required;
  CssClassSet classes;
  String get title;
  set title(String title);
}