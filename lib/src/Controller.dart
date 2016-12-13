
part of webui;

abstract class Controller implements EventBusListener {
  static const eventDirtyChanged = 'dirtyChanged';
  final Logger log = new Logger('Controller');

  List<View> _views;
  ObjectStore _store;
  List<Future> _preloaded;
  EventBus _eventBus;

  View get view => _views[0];

  List<View> get views => _views;

  ObjectStore get store => _store;

  Controller([View view]) {
    _store = new ObjectStore();
    _store.addStateListener(stateChanged);
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
    _eventBus = eventBus;
    _eventBus.listenOn(this);
  }

  @override
  void run(BusEvent event) {
    switch (event.name) {
      case Address.eventAddressChanged:
        if (!canRun()) {
          hideViews();
          return;
        }
        showViews();

        if (_preloaded == null) {
          _preloaded = preLoad();
        }
        Future.wait(_preloaded).then((_) => load());
        break;
      case eventDirtyChanged:
        dirtyChanged(event);
        break;
    }
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

  // Some other controller is now dirty;
  void dirtyChanged(BusEvent event) {
    // Default do nothing
  }

  // Called from ObjectStore when local store is dirty
  void stateChanged() {
    log.fine('stateChanged: ${this}');
    _eventBus?.fire(this, new BusEvent(eventDirtyChanged, store.isDirty));
  }
}
