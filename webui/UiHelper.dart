
part of webui;

typedef String TableRowValue(String name, Set classes, Map row, String suggestion);
typedef String SelectOption(Map row);

class UiHelper {
  
  static populateSelect(String name, List data, SelectOption callback) {
    var options = new DocumentFragment();
    data.forEach((Map elem) {
      var option = new OptionElement();
      option.value = "${elem['uid']}";
      option.appendText(callback(elem));
      options.append(option);
    });
    SelectElement select = querySelector("select[name=$name]");
    if (select != null) {
      select.children.clear();
      select.append(options);
    }
  }
  

  static populateForm(String name, Map data) {
    var elements = querySelectorAll("form[name=$name] input");
    elements.forEach((InputElement elem) {
      if(data[elem.name] != null) {
        elem.value = '${Format.display(elem.classes, "${data[elem.name]}")}';
      }
    });
    elements = querySelectorAll("form[name=$name] select");
    elements.forEach((SelectElement elem) {
      if(data[elem.name] != null) {
        elem.value = "${data[elem.name]}";
      }
    });
    elements = querySelectorAll("form[name=$name] textarea");
    elements.forEach((TextAreaElement elem) {
      elem.value = "${data[elem.name]}"; 
    });
  }
  
  static populateTable(String id, List rows, [String linkPrefix, TableRowValue rowValue]) {
    var fragment = new DocumentFragment();
    
    TableSectionElement tbody = querySelector("$id tbody");
    if (tbody != null) {
      tbody.children.clear();
    }
    var columns = querySelectorAll("$id thead th");
    if (rows.length == 0) {
      var tableCell = new TableCellElement();
      tableCell.colSpan = columns.length;
      tableCell.appendText('Ingen rækker fundet');
      var tableRow = new TableRowElement();
      tableRow.append(tableCell);
      fragment.append(tableRow);
    }
    else {
      var rowCount = 0;
      rows.forEach((Map row){
        var tableRow = new TableRowElement();
        tableRow.classes.add(rowCount % 2 == 0 ? "row-even" : "row-odd");
        columns.forEach((TableCellElement column) {
          var value = "&nbsp;";
          var href = null;
          if (linkPrefix != null) {
            href = "/$linkPrefix/${row['uid']}";
          }
          
          if (column.classes.contains('edit')) {
            if (row[column.id] == null) {
              value = 'E';
            }
            else {
              value = row[column.id];
            }
            value = "<a class='edit' href='$href'>$value</a>";
          }
          else if (column.classes.contains('delete')) {
            if (row[column.id] == null) {
              value = 'X';
            }
            value = "<a class='delete' href='$href'>$value</a>";
          }
          else if (column.classes.contains('children')) {
            href += "/${column.id}";
            value = "<a class='children' href='$href'>se</a>";
          }
          else {
            value = Format.display(column.classes, "${row[column.id]}");
          }
          if (rowValue != null) {
            value = rowValue(column.id, column.classes, row, value);
          }
          
          var tableCell = new TableCellElement();
          tableCell.appendHtml(value);
          tableRow.append(tableCell);
        });
        fragment.append(tableRow);
        rowCount++;
      });
      tbody.append(fragment);
    }
  }
  
  static Map getFormdata(String name) {
    Map result = new Map();
    querySelectorAll("form[name=$name] input").forEach((InputElement elem) {
      if(elem.attributes['type'] == 'checkbox') {
        if(elem.checked) {
          result[elem.name] = Format.internal(elem.classes, elem.value);
        }
      } else if(elem.attributes['type'] != 'file') {
        result[elem.name] = Format.internal(elem.classes, elem.value);
      }
    });
    querySelectorAll("form[name=$name] select").forEach((SelectElement elem) {
      result[elem.name] = elem.value;
    });
    querySelectorAll("form[name=$name] textarea").forEach((TextAreaElement elem) {
      result[elem.name] = Format.internal(elem.classes, elem.value);
    });
    return result;
  }
  
  static clearFormdata(String name) {
    querySelectorAll("form[name=$name] input").forEach((InputElement elem) {
      if(elem.attributes['type'] == 'checkbox' ||
         elem.attributes['type'] == 'radio') {
        elem.checked = false;
      } else if(elem.attributes['type'] != 'submit' && elem.attributes['type'] != 'button') {
        elem.value = '';
      }
    });
    querySelectorAll("form[name=$name] select").forEach((SelectElement elem) {
      elem.value = '';
    });
    querySelectorAll("form[name=$name] textarea").forEach((TextAreaElement elem) {
      elem.value = '';
    });
  }
  
}
