
library webui;

export 'src/Address.dart';
export 'src/EventBus.dart';
export 'src/Formatter.dart';
export 'src/Rest.dart';

import 'dart:html';
import 'dart:async';
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

part 'src/UiBinding.dart';
part 'src/UiFormBinding.dart';
part 'src/UiInputBinding.dart';
part 'src/UiInputFileBinding.dart';
part 'src/UiButtonBinding.dart';
part 'src/UiListBinding.dart';
part 'src/UiSelectBinding.dart';
part 'src/UiTableBinding.dart';

part 'src/UiInputValidator.dart';
part 'src/UiInputValidatorListener.dart';
part 'src/UiBootStrapInputValidatorListener.dart';
part 'src/UiBootStrapTableBindingCss.dart';

part 'src/ObjectStore.dart';
part 'src/UiInput.dart';

initWebUi() {
  document.registerElement(UiInput.uiTagName, UiInput, extendsTag: 'input');
}
