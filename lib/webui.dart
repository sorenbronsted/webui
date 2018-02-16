
library webui;

export 'src/mvc/Rest.dart';
export 'src/ui/Formatter.dart';

import 'dart:html';
import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';

import 'src/mvc/Rest.dart';
import 'src/ui/Formatter.dart';

part 'src/mvc/observer.dart';
part 'src/mvc/proxy.dart';
part 'src/mvc/view.dart';
part 'src/mvc/control.dart';
part 'src/mvc/router.dart';
part 'src/mvc/Repo.dart';

part 'src/ui/Button.dart';
part 'src/ui/element.dart';
part 'src/ui/factory.dart';
part 'src/ui/Form.dart';
part 'src/ui/Input.dart';
part 'src/ui/InputCss.dart';
part 'src/ui/InputCssBootStrap.dart';
part 'src/ui/InputCssW3.dart';
part 'src/ui/InputBase.dart';
part 'src/ui/InputValidator.dart';
part 'src/ui/UList.dart';
part 'src/ui/Select.dart';
part 'src/ui/Anchor.dart';
part 'src/ui/Table.dart';
part 'src/ui/TableCss.dart';
part 'src/ui/TableCssBootStrap.dart';
part 'src/ui/TableCssW3.dart';
part 'src/ui/Text.dart';
part 'src/ui/TextArea.dart';
part 'src/ui/Th.dart';

initWebUi() {
  initializeDateFormatting(Intl.defaultLocale, null);
}
