
part of webui;

class BaseDetailView extends BaseView {
  String _viewName;
  bool formHasChanged;
  
  setViewName(String name) => _viewName = "${name}Detail";
  String getViewName() => _viewName;

  List<StreamSubscription> preventPageLeaveEvents = new List();
  
  onLoad() {
    this.formHasChanged = false;

    setValidation("input[type=text]");
    onClick("input[name=save]", true);
    onClick("input[name=cancel]", false);

    querySelectorAll("input[type='text']").forEach((InputElement input) => preventPageLeaveEvents.add(input.onKeyUp.listen(fieldHasChanged)));
    querySelectorAll("select").forEach((SelectElement select) => preventPageLeaveEvents.add(select.onKeyUp.listen(fieldHasChanged)));
    querySelectorAll("#tabs a").forEach((AnchorElement a) => preventPageLeaveEvents.add(a.onClick.listen(leaveConfirmationDialog)));
  }

  void fieldHasChanged (KeyboardEvent e) {
    this.formHasChanged = true;
  }

  void leaveConfirmationDialog (MouseEvent e) {
    if(this.formHasChanged == true) {
      e.preventDefault();

      if(this.confirm("Der er foretaget ændringer på siden, er du sikker på at, du vil forlade siden?\n(Dine ændringer vil gå tabt)")) {
        this.formHasChanged = false;

        Address.instance.goto((e.target as AnchorElement).href);

        this.removeLeaveEvents();
      }
    }
  }

  void removeLeaveEvents() {
    preventPageLeaveEvents.forEach((StreamSubscription ss) => ss.cancel() );
    preventPageLeaveEvents.clear();
  }
  
  populate(Map data) {
    UiHelper.populateForm("formdata", data);
  }

  Map get formdata => UiHelper.getFormdata("formdata");
}