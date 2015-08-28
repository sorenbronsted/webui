
part of webui;

abstract class Controller implements EventBusListener {

  // Register which methods to call when on which events
  @override
  void register(EventBus eventBus) {
    eventBus.listenOn(Address.eventAddressChanged, run);
  }

  // Excuted when event happens
  void run(String event);
}
