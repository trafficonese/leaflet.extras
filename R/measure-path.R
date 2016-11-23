measurePathDependencies <- function() {
  list(
    htmltools::htmlDependency(
      "measurePath",version = "1.3.1",
      system.file("htmlwidgets/lib/measure-path", package = "leaflet.extras"),
      script = c('leaflet-measure-path.js', 'measure-path-bindings.js'),
      stylesheet = c('leaflet-measure-path.css')
    )
  )
}

#' Enables measuring of length of polylines and areas of polygons
#' @param map The map widget.
#' @rdname measure-path
#' @export
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
  imperial = FALSE
) {
  list(
    showOnHover = showOnHover,
    minPixelDistance = minPixelDistance,
    showDistances = showDistances,
    showArea = showArea,
    imperial = imperial
  )
}

#' Adds a toolbar to enable/disable measuing path distances/areas
#' @param options The measurePathOptions.
#' @rdname measure-path
#' @export
addMeasurePathToolbar <- function(
  map,
  options = measurePathOptions()
) {
  map <- enableMeasurePath(map) %>%
  addEasyButtonBar(
    easyButton(
    states = list(
      easyButtonState(
        stateName='disabled-measurement',
        icon='ion-ios-flask-outline',
        title='Enable Measurements',
        onClick = JS("
          function(btn, map) {
             LeafletWidget.methods.enableMeasurements.call(map);
             btn.state('enabled-measurement');

          }")
      ),
      easyButtonState(
        stateName='enabled-measurement',
        icon='ion-ios-flask',
        title='Disable Measurements',
        onClick = JS("
          function(btn, map) {
             LeafletWidget.methods.disableMeasurements.call(map);
             btn.state('disabled-measurement');
          }")
      )
    )
  ),
  easyButton(
      icon='ion-android-refresh', title='Recalculate Measurements',
      onClick=JS("function(btn, map){ LeafletWidget.methods.refreshMeasurements.call(map); }"))
  )
  invokeMethod(map, leaflet::getMapData(map), 'setMeasurementOptions', options)
}
