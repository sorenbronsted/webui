
part of webui;

class BaseListView extends BaseView {
  String _viewName;
  
  setViewName(String name) => _viewName = "${name}List";
  String getViewName() => _viewName;

  void onLoad() {
    onClick("input[name='create']", false);
  }

  Map get formdata => UiHelper.getFormdata("formdata");
  
  String getInputValue(String name) => (querySelector("input[name=$name]") as InputElement).value;
  
  setInputValue(String name, String value) => (querySelector("input[name=$name]") as InputElement).value = value;
  setSelectValue(String name, String value) => (querySelector("select[name=$name]") as SelectElement).value = value;

  populate(List rows, String urlPrefix) {
    UiHelper.populateTable("#list", rows, "#$urlPrefix");
    onLinkClick("#list tbody");
  }
}
