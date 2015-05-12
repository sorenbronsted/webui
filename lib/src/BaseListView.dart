
part of webui;

class BaseListView extends BaseView {
  String _viewName;
  
  BaseListView([String bindId = '#content']) : super(bindId);
  
  setViewName(String name) => _viewName = "${name}List";
  String getViewName() => _viewName;

  void onLoad() {
    onClick("input[name='create']", false);
  }

  Map get formdata => UiHelper.getFormdata("formdata");

  populate(List rows, String urlPrefix) {
    UiHelper.populateTable("#list", rows, "#$urlPrefix");
    onLinkClick("#list tbody");
  }
}
