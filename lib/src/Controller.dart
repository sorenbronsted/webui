
part of webui;

abstract class Controller implements EventBusListener {
  List<View> _views;
  ObjectStore _store;
  List<Future> _preloaded;

  View get view => _views[0];

  List<View> get views => _views;

  ObjectStore get store => _store;

  Controller([View view]) {
    _store = new ObjectStore();
    _views = [];
    if (view != null) {
      addView(view);
    }
  }

  void addView(View view) {
    view.store = _store;
    _views.add(view);
  }

  // Register which methods to call when on which events
  @override
  void register(EventBus eventBus) {
    eventBus.listenOn(Address.eventAddressChanged, run);
  }

  void run(String event) {
    if (!canRun()) {
      hideViews();
      return;
    }
    showViews();

    if (_preloaded == null) {
      _preloaded = preLoad();
    }
    Future.wait(_preloaded).then((_) => load());
  }

  // Hide all views
  void hideViews() {
    _views.forEach((view) => view.hide());
  }

  // Show all views
  void showViews() {
    _views.forEach((view) => view.show());
  }

  // Tell if the controller is runable with the current address
  bool canRun();

  // Called before data is loaded
  List<Future> preLoad() => [];

  // Load data
  void load();
}
