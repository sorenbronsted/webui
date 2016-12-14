
library webui;

export 'src/EventBus.dart';
export 'src/Formatter.dart';
export 'src/Rest.dart';
export 'src/ObjectStore.dart';

import 'dart:html';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'src/Rest.dart';
import 'src/Formatter.dart';
import 'src/EventBus.dart';
import 'src/ObjectStore.dart';

part 'src/Address.dart';
part 'src/View.dart';
part 'src/Controller.dart';
part 'src/DefaultListView.dart';
part 'src/DefaultListCtrl.dart';
part 'src/DefaultDetailView.dart';
part 'src/DefaultDetailCtrl.dart';

part 'src/UiBind.dart';
part 'src/UiInputValidator.dart';
part 'src/UiInputValidatorListener.dart';
part 'src/UiBootStrapInputValidatorListener.dart';
part 'src/UiBootStrapTableCss.dart';

part 'src/UiTh.dart';
part 'src/UiTable.dart';
part 'src/UiForm.dart';
part 'src/UiTextArea.dart';
part 'src/UiSelect.dart';
part 'src/UiList.dart';
part 'src/UiInputState.dart';
part 'src/UiInput.dart';
part 'src/UiInputType.dart';
part 'src/UiTab.dart';
part 'src/UiSpan.dart';

initWebUi() {
  document.registerElement(UiTable.uiTagName, UiTable, extendsTag: 'table');
  document.registerElement(UiTh.uiTagName, UiTh, extendsTag: 'th');
  document.registerElement(UiForm.uiTagName, UiForm, extendsTag: 'form');
  document.registerElement(UiInput.uiTagName, UiInput, extendsTag: 'input');
  document.registerElement(UiTextArea.uiTagName, UiTextArea, extendsTag: 'textarea');
  document.registerElement(UiSelect.uiTagName, UiSelect, extendsTag: 'select');
  document.registerElement(UiList.uiTagName, UiList, extendsTag: 'div');
  document.registerElement(UiTab.uiTagName, UiTab, extendsTag: 'a');
  document.registerElement(UiSpan.uiTagName, UiSpan, extendsTag: 'span');

  initializeDateFormatting(Intl.defaultLocale, null);
}
