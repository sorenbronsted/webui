library webui_demo;

// DART HTML Library
import 'package:logging/logging.dart';
import 'package:webui/webui.dart' as ui;

// PureMVC Framework for Dart
import 'package:puremvc/puremvc.dart' as mvc;

// Model Tier
part 'src/model/person.dart';

// View Tier
part 'src/view/personview.dart';

// Controller Tier
part 'src/controller/commands.dart';
part 'src/controller/app.dart';

void main() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
  });

  ui.UiInputValidator.css = new ui.UiInputValidatorListenerW3();

  // Get a unique multiton Facade instance for the application
  mvc.IFacade facade = mvc.Facade.getInstance(AppNotes.Appname);

  // Startup the application's PureMVC core
  facade.registerCommand(ui.AppEvent.Startup, () => new StartupCommand());
  facade.sendNotification(ui.AppEvent.Startup);
  facade.sendNotification(ui.AppEvent.Goto, 'list/${Person.NAME}');
}
