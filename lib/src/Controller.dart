
part of webui;

abstract class Controller implements EventBusListener {
  View _view;

  Controller(View this._view);

  // Getter on view
  View get view => _view;

  // Register which methods to call when on which events
  @override
  void register(EventBus eventBus) {
    eventBus.listenOn(Address.eventAddressChanged, run);
  }

  void run(String event) {
    if (!canRun()) {
      return;
    }
    _view.show().then((_) {
      List<Future> futures = preLoad();
      assert(futures != null);
      Future.wait(futures).then((_) => load());
    });
  }

  // Tell if the controller is runable with the current address
  bool canRun();

  // Called before data is loaded
  List<Future> preLoad() => [];

  // Load data
  void load();
}
