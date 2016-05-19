
part of webuiSample;

class PersonListView extends DefaultListView {
  void set persons(persons) => populate(persons);

  onTableRow(TableRowElement tableRow, Map row) {
    //tableRow.classes.add('bg-danger');
  }

}
