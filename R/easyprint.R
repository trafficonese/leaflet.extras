easyprintDependency <- function() {
  list(
    htmltools::htmlDependency(
      "lfx-easyprint", version = "2.1.0",
      src = system.file("htmlwidgets/build/lfx-easyprint", package = "leaflet.extras"),
      script = c("lfx-easyprint.js",
                 "lfx-easyprint-bindings.js")
    )
  )
}

#' Add easyPrint Plugin
#' @param map the map to add easyPrint to.
#' @param layerId the layer id
#' @param group the name of the group the newly created layers should belong to
#' @param options A named list of options. See \code{\link{easyprintOptions}}
#' @family easyPrint
#' @export
addEasyprint <- function(map, options = easyprintOptions()) {

  map$dependencies <- c(map$dependencies, easyprintDependency())

  leaflet::invokeMethod(map, NULL, "addEasyprint", options)
}

#' easyprintMap
#' @param map the map widget
#' @param sizeModes Options available include Current, A4Portrait, A4Landscape
#'   or a custom size object. Default is \code{A4Portrait}
#' @param filename Name of the file if export only option set to TRUE
#' @family easyPrint
#' @export
easyprintMap <- function(map, sizeModes = "A4Portrait", filename = "map") {
  leaflet::invokeMethod(map, NULL, "easyprintMap", sizeModes, filename)
}

#' easyprintMapremoveEasyprint
#' @export
removeEasyprint <- function(map) {
  leaflet::invokeMethod(map, NULL, "removeEasyprint")
}



#' easyPrint Options
#' @param title Sets the text which appears as the tooltip of the print/export button
#' @param position Positions the print button
#' @param sizeModes Options available include Current, A4Portrait, A4Landscape
#'   or a custom size object
#' @param defaultSizeTitles button tooltips for the default page sizes
#' @param exportOnly 	If set to true the map is exported to a png file
#' @param tileLayer A tile layer that you can wait for to draw (helpful when resizing)
#' @param tileWait How long to wait for the tiles to draw (helpful when resizing)
#' @param filename Name of the file if export only option set to TRUE
#' @param hidden Set to true if you don't want to display the toolbar.
#'   Instead you can create your own buttons or fire print events programmatically.
#'   You still need to call addTo(map) to set the leaflet map context.
#' @param hideControlContainer Hides the leaflet controls like the zoom buttons
#'   and the attribution on the print out.
#' @param hideClasses Hides classes on the print out. Use a list of strings as
#'   follow : list('div1', 'div2')
#' @param customWindowTitle A title for the print window which will get
#'   added the printed paper.
#' @param spinnerBgColor A valid css colour for the spinner background color.
#' @param customSpinnerClass A class for a custom css spinner to use while
#'   waiting for the print.
#' @family easyPrint
#' @export
easyprintOptions <- function(title = 'Print map',
                             position = 'topleft',
                             sizeModes = list("A4Portrait", "A4Landscape", "Current"),
                             defaultSizeTitles = NULL,
                             exportOnly = FALSE,
                             tileLayer = NULL,
                             tileWait = 500,
                             filename = 'map',
                             hidden = FALSE,
                             hideControlContainer = TRUE,
                             hideClasses = list(),
                             customWindowTitle = NULL,
                             spinnerBgColor = '#0DC5C1',
                             customSpinnerClass = 'epLoader') {
  leaflet::filterNULL(list(
    title = title,
    position = position,
    sizeModes = sizeModes,
    defaultSizeTitles = defaultSizeTitles,
    exportOnly = exportOnly,
    tileLayer = tileLayer,
    tileWait = tileWait,
    filename = filename,
    hidden = hidden,
    hideControlContainer = hideControlContainer,
    hideClasses = hideClasses,
    customWindowTitle = customWindowTitle,
    spinnerBgColor = spinnerBgColor,
    customSpinnerClass = customSpinnerClass
  ))
}
