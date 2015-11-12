part of webuiSample;

class PersonDetailView extends DefaultDetailView {

  void set zipCodes(List<Map> codes) {
    (form['Person-zipcode'] as UiSelectBinding).options = codes;
  }
}

