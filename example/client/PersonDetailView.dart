part of webuiSample;

class PersonDetailView extends DefaultDetailView {

  void set zipCodes(List<Map> codes) {
    (form['zipcode'] as UiSelectBinding).options = codes;
  }
}

