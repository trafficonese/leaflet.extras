measurePathDependencies <- function() {
  list(
    html_dep_prod("lfx-measure-path", "1.5.0", has_style = TRUE, has_binding = TRUE)
  )
}

#' Enables measuring of length of polylines and areas of polygons
#' @param map The map widget.
#' @rdname measure-path
#' @export
#' @examples
#' \donttest{
#' geoJson <- readr::read_file(
#'   "https://rawgit.com/benbalter/dc-maps/master/maps/ward-2012.geojson"
#' )
#'
#' leaflet() %>%
#'   addTiles() %>%
#'   setView(-77.0369, 38.9072, 11) %>%
#'   addBootstrapDependency() %>%
#'   enableMeasurePath() %>%
#'   addGeoJSONChoropleth(
#'     geoJson,
#'     valueProperty = "AREASQMI",
#'     scale = c("white", "red"),
#'     mode = "q",
#'     steps = 4,
#'     padding = c(0.2, 0),
#'     labelProperty = "NAME",
#'     popupProperty = propstoHTMLTable(
#'       props = c("NAME", "AREASQMI", "REP_NAME", "WEB_URL", "REP_PHONE", "REP_EMAIL", "REP_OFFICE"),
#'       table.attrs = list(class = "table table-striped table-bordered"),
#'       drop.na = TRUE
#'     ),
#'     color = "#ffffff", weight = 1, fillOpacity = 0.7,
#'     highlightOptions = highlightOptions(
#'       weight = 2, color = "#000000",
#'       fillOpacity = 1, opacity = 1,
#'       bringToFront = TRUE, sendToBack = TRUE
#'     ),
#'     pathOptions = pathOptions(
#'       showMeasurements = TRUE,
#'       measurementOptions = measurePathOptions(imperial = TRUE)
#'     )
#'   )
#' }
#'
enableMeasurePath <- function(map) {
  map$dependencies <- c(map$dependencies, measurePathDependencies())
  map
}

#' Options for measure-path
#' @param showOnHover If TRUE, the measurements will only show when the user hovers the cursor over the path.
#' @param minPixelDistance The minimum length a line segment in the feature must have for a measurement to be added.
#' @param showDistances If FALSE, doesn't show distances along line segments of of a polyline/polygon.
#' @param showArea If FALSE, doesn't show areas of a polyline/polygon.
#' @param imperial If TRUE the distances/areas will be shown in imperial units.
#' @rdname measure-path
#' @export
measurePathOptions <- function(
    showOnHover = FALSE,
    minPixelDistance = 30,
    showDistances = TRUE,
    showArea = TRUE,
    imperial = FALSE) {
  list(
    showOnHover = showOnHover,
    minPixelDistance = minPixelDistance,
    showDistances = showDistances,
    showArea = showArea,
    imperial = imperial
  )
}

#' Adds a toolbar to enable/disable measuring path distances/areas
#' @param options The measurePathOptions.
#' @param group The group name
#' @param group A character vector specifying the group(s) of layers for measurements.
#' If `group` is `NULL` (default), measurements apply to all layers.
#' For a single group or multiple groups, measurements apply only to matching layers.
#' @rdname measure-path
#' @export
#' @examples
#' leaflet() %>%
#'   addTiles() %>%
#'   addCircles(lng = c(10, 20), lat = c(50, 60), group = "Group 1") %>%
#'   addCircles(lng = c(15, 25), lat = c(55, 65), group = "Group 2") %>%
#'   addMeasurePathToolbar(group = "Group 1") # Enable measurements for "Group 1" only
addMeasurePathToolbar <- function(
    map,
    options = measurePathOptions(),
    group = NULL) {

  if (is.null(group)) group = ""
  group <- jsonlite::toJSON(group)

  map <- enableMeasurePath(map) %>%
    addEasyButtonBar(
      easyButton(
        states = list(
          easyButtonState(
            stateName = "disabled-measurement",
            icon = "ion-ios-flask-outline",
            title = "Enable Measurements",
            onClick = JS(sprintf("
          function(btn, map) {
             LeafletWidget.methods.enableMeasurements.call(map, '%s');
             btn.state(\"enabled-measurement\");
          }", group))
          ),
          easyButtonState(
            stateName = "enabled-measurement",
            icon = "ion-ios-flask",
            title = "Disable Measurements",
            onClick = JS(sprintf("
          function(btn, map) {
             LeafletWidget.methods.disableMeasurements.call(map, '%s');
             btn.state(\"disabled-measurement\");
          }", group))
          )
        )
      ),
      easyButton(
        icon = "ion-android-refresh", title = "Recalculate Measurements",
        onClick = JS(sprintf("
          function(btn, map) {
             LeafletWidget.methods.refreshMeasurements.call(map, '%s');
          }", group))
      )
    )
  invokeMethod(map, leaflet::getMapData(map), "setMeasurementOptions", options)
}
