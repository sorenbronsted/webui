
library webui;

export 'src/Formatter.dart';
export 'src/Rest.dart';

import 'dart:html';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:puremvc/puremvc.dart' as mvc;
import 'src/Rest.dart';
import 'src/Formatter.dart';

part 'src/ViewElement.dart';
part 'src/DefaultListElement.dart';
part 'src/DefaultDetailElement.dart';

part 'src/BaseMediator.dart';
part 'src/DefaultDetailMediator.dart';
part 'src/DefaultListMediator.dart';
part 'src/ModelClass.dart';
part 'src/Router.dart';
part 'src/AppEvent.dart';

part 'src/UiElement.dart';
part 'src/UiInputValidator.dart';
part 'src/UiInputValidatorListener.dart';
part 'src/UiInputValidatorListenerBootStrap.dart';
part 'src/UiInputValidatorListenerW3.dart';
part 'src/UiTableCssBootStrap.dart';
part 'src/UiTableCss.dart';
part 'src/UiTableCssW3.dart';

part 'src/UiTh.dart';
part 'src/UiTable.dart';
part 'src/UiForm.dart';
part 'src/UiTextArea.dart';
part 'src/UiSelect.dart';
part 'src/UiList.dart';
part 'src/UiInputElement.dart';
part 'src/UiInput.dart';
part 'src/UiTab.dart';
part 'src/UiText.dart';

initWebUi() {
  initializeDateFormatting(Intl.defaultLocale, null);
}
