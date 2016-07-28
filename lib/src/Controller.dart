
part of webui;

abstract class Controller implements EventBusListener {
  View _view;
  ObjectStore _store;
  List<Future> _preloaded;

  // Getter on view
  View get view => _view;

  ObjectStore get store => _store;

  Controller(View this._view) {
    _store = new ObjectStore();
    _view.bind(_store);
  }

  // Register which methods to call when on which events
  @override
  void register(EventBus eventBus) {
    eventBus.listenOn(Address.eventAddressChanged, run);
  }

  void run(String event) {
    if (!canRun()) {
      return;
    }
    _view.show();
    if (_preloaded == null) {
      _preloaded = preLoad();
    }
    Future.wait(_preloaded).then((_) => load());
  }

  // Tell if the controller is runable with the current address
  bool canRun();

  // Called before data is loaded
  List<Future> preLoad() => [];

  // Load data
  void load();
}
