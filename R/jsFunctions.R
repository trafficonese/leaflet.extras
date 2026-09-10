defIconFunction <-
  JS("function(icon){
        if (!$.isEmptyObject(icon)) {
          return L.icon(icon);
        } else {
          return L.icon();
        }
     }")

awesomeIconFunction <-
  JS("function(icon){
        if (!$.isEmptyObject(icon)) {
          if (!icon.prefix) {
            icon.prefix = icon.library;
          }
          return L.AwesomeMarkers.icon(icon);
        } else {
          return L.AwesomeMarkers.icon();
        }
     }")

#' Converts GeoJSON Feature properties to HTML
#' @param props A list of GeoJSON Property Keys.
#' @param elem An optional wrapping element e.g. "div".
#' @param elem.attrs An optional named list for the wrapper element properties.
#' @export
#' @rdname utils
propsToHTML <- function(props, elem = NULL, elem.attrs = NULL) {
  if (!(inherits(props, "list") || (inherits(props, "character"))) || length(props) < 1) {
    stop("props needs to to be a list/vector of character strings with at least one element")
  }
  if (!is.null(elem.attrs) &&
    (!inherits(elem.attrs, "list") ||
      length(elem.attrs) < 1 ||
      is.null(names(elem.attrs)))) {
    stop("If elem.attrs is provided, then it needs to be a named list with atleast one element")
  }
  JS(sprintf(
    "function(feature){return \"%s\" + L.Util.template(\"%s\",feature.properties); + \"%s\";}",
    if (!is.null(elem) && !elem == "") {
      sprintf(
        "<%s%s>",
        elem,
        if (!is.null(elem.attrs)) {
          paste(sapply(
            names(elem.attrs),
            function(attr) sprintf(" %s=\"%s\"", attr, elem.attrs[[attr]])
          ), collapse = " ")
        } else {
          ""
        }
      )
    } else {
      ""
    },
    if (length(props) > 1) {
      paste(stringr::str_replace(props, "(.*)", "{\\1}"), collapse = ", ")
    } else {
      props
    },
    if (!is.null(elem) && !elem == "") {
      sprintf("</%s>", elem)
    } else {
      ""
    }
  ))
}

#' Converts GeoJSON Feature properties to HTML Table.
#' @param table.attrs An optional named list for the HTML Table.
#' @param drop.na whether to skip properties with empty values.
#' @export
#' @rdname utils
propstoHTMLTable <- function(props = NULL, table.attrs = NULL, drop.na = TRUE) {
  if (!is.null(table.attrs) &&
    (!inherits(table.attrs, "list") ||
      length(table.attrs) < 1 ||
      is.null(names(table.attrs)))) {
    stop("If table.attrs is provided, then it needs to be a named list with at least one element")
  }

  if (!is.null(props) && length(props) >= 1) {
    JS(sprintf(
      "function(feature){
         return '<table%s><caption>Properties</caption><tbody style=\"font-size:x-small\">' +
           ( $.isEmptyObject(feature.properties) ? '' :
             L.Util.template(\"%s\",feature.properties)
           )+ \"</tbody></table>\";
       }",
      if (!is.null(table.attrs)) {
        paste(sapply(
          names(table.attrs),
          function(attr) sprintf(" %s=\"%s\"", attr, table.attrs[[attr]])
        ), collapse = " ")
      } else {
        ""
      },
      paste(stringr::str_replace(props, "(.*)", "<tr><td><b>\\1</b></td><td>{\\1}</td></tr>"), collapse = "")
    ))
  } else {
    JS(sprintf(
      "function(feature){
        return '<table%s><caption>Properties</caption><tbody style=\"font-size:x-small\">' +
          ( function(props) {
            var rws = '';
            $.each(props, function (k, v) {
              if ( %s ||(v !== null && typeof v !== \"undefined\")) {
                rws = rws.concat(\"<tr><td><b>\"+k+\"</b></td><td>\"+
                ((v !== null && typeof v !== \"undefined\") ? v : '') +
                \"</td></tr>\");
              }
            });
            return rws;
          })(feature.properties) + \"</tbody></table>\";}",
      if (!is.null(table.attrs)) {
        paste(sapply(
          names(table.attrs),
          function(attr) sprintf(" %s=\"%s\"", attr, table.attrs[[attr]])
        ), collapse = " ")
      } else {
        ""
      },
      if (drop.na) "false" else "true"
    ))
  }
}
