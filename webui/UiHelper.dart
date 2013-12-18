
part of webui;

typedef String TableRowValue(String name, Set classes, Map row);
typedef String SelectOption(Map row);

class UiHelper {
  
  static populateSelect(String name, List data, SelectOption callback) {
    var options = new StringBuffer();
    data.forEach((Map elem) {
      options.write("<option value='${elem['uid']}'>${callback(elem)}</option>");
    });
    SelectElement select = querySelector("select[name=$name]");
    if (select != null) {
      select.innerHtml = options.toString();
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
  }
  
  static populateTable(String id, List rows, [String linkPrefix, TableRowValue rowValue]) {
    TableSectionElement tbody = querySelector("$id tbody");
    if (tbody != null) {
      tbody.innerHtml = "";
    }
    var columns = querySelectorAll("$id thead th");
    var tmp = new StringBuffer();
    if (rows.length == 0) {
      tmp.write("<tr><td colspan='${columns.length}'>Ingen rækker fundet</td><tr>");
      tbody.setInnerHtml(tmp.toString());
    }
    else {
      var rowCount = 0;
      rows.forEach((Map row){
        tmp.write("<tr class=${rowCount % 2 == 0 ? "row-even" : "row-odd"}>");
        columns.forEach((TableCellElement column) {
          var value = "&nbsp;";

          if (rowValue != null) {
            value = rowValue(column.id, column.classes, row);
          }
          else {
            var href = null;
            if (linkPrefix != null) {
              href = "/$linkPrefix/${row['uid']}";
            }
            switch(column.id) {
              case "edit":
                if (href == null) {
                  throw "Missing link prefix";
                }
                value = "<a class='edit' href='$href'>E</a>";
                break;
              case "delete":
                if (href == null) {
                  throw "Missing link prefix";
                }
                value = "<a class='delete' href='$href'>X</a>";
                break;
              default:
                value = Format.display(column.classes, "${row[column.id]}");
            }
          }
          
          tmp.write("<td>$value</td>");
        });
        tmp.write("</tr>");
        rowCount++;
        tbody.setInnerHtml(tmp.toString());
      });
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
