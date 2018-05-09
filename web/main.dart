library webui_demo;

import 'package:logging/logging.dart';
import 'package:webui/webui.dart';

part 'src/person.dart';

void main() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
  });

  initWebUi();

  InputValidator.css = new InputValidatorListenerW3();

  Repo.instance.add(new Router());
  Repo.instance.add(new RouterCtrl(new RouterView()));
  Repo.instance.add(new CurrentViewState());
  Repo.instance.add(new Person());
  Repo.instance.add(new PersonListCtrl(new View('PersonList')));
  Repo.instance.add(new PersonDetailCtrl(new View('PersonDetail')));

  Router router = Repo.instance.getByType(Router);
  router.goto(Uri.parse('list/Person'));
}
