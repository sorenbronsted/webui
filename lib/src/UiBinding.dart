
part of webui;

/* This provide a service contract for a UiBinding */
abstract class UiBinding {

  /* This will bind the view state to a UiBinding */
  void bind(View view);

  /* This will read an object from the UiBinding */
  Object read();

  /* This will write an object to the UiBinding */
  void write(Object);
}

class SelectorException {
  String _msg;

  SelectorException(String this._msg);
  String toString() => _msg;
}
