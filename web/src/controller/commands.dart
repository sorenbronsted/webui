part of webui_demo;

class StartupCommand extends mvc.MacroCommand {
  @override
  void initializeMacroCommand() {
    // add the subcommands
    addSubCommand(() => new PrepareControllerCommand());
    addSubCommand(() => new PrepareModelCommand());
    addSubCommand(() => new PrepareViewCommand());
  }
}

class PrepareViewCommand extends mvc.SimpleCommand {
  @override
  void execute(mvc.INotification note) {
    facade.registerMediator(new ui.RouterMediator());
    facade.registerMediator(new PersonListMediator());
    facade.registerMediator(new PersonDetailMediator());
  }
}

class PrepareModelCommand extends mvc.SimpleCommand {
  @override
  void execute(mvc.INotification note) {
    facade.registerProxy(new Person());
  }
}

class PrepareControllerCommand extends mvc.SimpleCommand {
  @override
  void execute(mvc.INotification note) {
    facade.registerCommand(ui.RouterMediator.CHANGED, () => new DisplayCommand());
    facade.registerCommand(ui.AppEvent.Save, () => new BackCommand());
    facade.registerCommand(ui.AppEvent.Cancel, () => new BackCommand());
    facade.registerCommand(ui.AppEvent.Goto, () => new GotoCommand());
    facade.registerCommand(ui.AppEvent.Create, () => new GotoCommand());
  }
}

class DisplayCommand extends mvc.SimpleCommand {
  @override
  void execute(mvc.INotification note) {
    ui.RouterMediator router = facade.retrieveMediator(ui.RouterMediator.NAME);
    Uri uri = router.uri;
    if (uri.pathSegments.length >= 2) {
      String name = '${uri.pathSegments[0]}/${uri.pathSegments[1]}';
      ui.BaseMediator mediator = facade.retrieveMediator(name);
      if (mediator == null) {
        throw "Mediator not found name: ${name}";
      }
      mediator.display(uri);
    }
    else {
      throw "Wrong uri format: ${uri.fragment}";
    }
  }
}

class BackCommand extends mvc.SimpleCommand {
  @override
  void execute(mvc.INotification note) {
    ui.RouterMediator router = facade.retrieveMediator(ui.RouterMediator.NAME);
    router.back();
  }
}

class GotoCommand extends mvc.SimpleCommand {
  @override
  void execute(mvc.INotification note) {
    ui.RouterMediator router = facade.retrieveMediator(ui.RouterMediator.NAME);
    router.goto(note.body);
  }
}
