
library webui;

export 'src/Address.dart';
export 'src/EventBus.dart';
export 'src/Formatter.dart';
export 'src/Rest.dart';

import 'dart:html';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'src/Rest.dart';
import 'src/Formatter.dart';
import 'src/Address.dart';
import 'src/EventBus.dart';

part 'src/View.dart';
part 'src/Controller.dart';
part 'src/DefaultListView.dart';
part 'src/DefaultListCtrl.dart';
part 'src/DefaultDetailView.dart';
part 'src/DefaultDetailCtrl.dart';

part 'src/UiInputValidator.dart';
part 'src/UiInputValidatorListener.dart';
part 'src/UiBootStrapInputValidatorListener.dart';
part 'src/UiBootStrapTableCss.dart';

part 'src/ObjectStore.dart';
part 'src/UiTh.dart';
part 'src/UiTable.dart';
part 'src/UiForm.dart';
part 'src/UiInput.dart';
part 'src/UiSelect.dart';
part 'src/UiList.dart';
part 'src/UiInputState.dart';

initWebUi() {
  document.registerElement(UiTable.uiTagName, UiTable, extendsTag: 'table');
  document.registerElement(UiTh.uiTagName, UiTh, extendsTag: 'th');
  document.registerElement(UiForm.uiTagName, UiForm, extendsTag: 'form');
  document.registerElement(UiInput.uiTagName, UiInput, extendsTag: 'input');
  document.registerElement(UiSelect.uiTagName, UiSelect, extendsTag: 'select');
  document.registerElement(UiList.uiTagName, UiList, extendsTag: 'div');

  initializeDateFormatting("da_DK", null);
  Intl.defaultLocale = 'da_DK';
}
