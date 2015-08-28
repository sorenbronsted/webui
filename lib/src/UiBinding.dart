
part of webui;

abstract class UiBinding {
  void validate() {}
  Object read();
  void write(Object);
}
