#' Options for drawn shapes
#' @param stroke	Whether to draw stroke along the path. Set it to false to disable borders on polygons or circles.
#' @param color	Stroke color.
#' @param weight	Stroke width in pixels.
#' @param opacity	Stroke opacity.
#' @param fill	Whether to fill the path with color. Set it to false to disable filling on polygons or circles.
#' @param fillColor	same as color	Fill color.
#' @param fillOpacity	Fill opacity.
#' @param dashArray	A string that defines the stroke dash pattern. Doesn't work on canvas-powered layers (e.g. Android 2).
#' @param lineCap	A string that defines shape to be used at the end of the stroke.
#' @param lineJoin	A string that defines shape to be used at the corners of the stroke.
#' @param clickable	If false, the vector will not emit mouse events and will act as a part of the underlying map.
#' @param pointerEvents	Sets the pointer-events attribute on the path if SVG backend is used.
#' @param smoothFactor	How much to simplify the polyline on each zoom level. More means better performance and smoother look, and less means more accurate representation.
#' @param noClip	Disabled polyline clipping.
#' @rdname draw-options
#' @export
drawShapeOptions <- function(
    stroke = TRUE,
    color = "#03f",
    weight = 1,
    opacity = 1,
    fill = TRUE,
    fillColor = "#03f",
    fillOpacity = 0.4,
    dashArray = NULL,
    lineCap = NULL,
    lineJoin = NULL,
    clickable = TRUE,
    pointerEvents = NULL,
    smoothFactor = 1.0,
    noClip = TRUE) {
  leaflet::filterNULL(list(
    stroke = stroke,
    color = color,
    weight = weight,
    opacity = opacity,
    fill = fill,
    fillColor = fillColor,
    fillOpacity = fillOpacity,
    dashArray = dashArray,
    lineCap = lineCap,
    lineJoin = lineJoin,
    clickable = clickable,
    pointerEvents = pointerEvents,
    smoothFactor = smoothFactor,
    noClip = noClip
  ))
}

#' Options for drawing polylines
#' @param allowIntersection	Determines if line segments can cross.
#' @param drawError	Configuration options for the error that displays if an intersection is detected.
#' @param guidelineDistance	Distance in pixels between each guide dash.
#' @param maxGuideLineLength Maximum length of the guide lines.
#' @param showLength Whether to display the distance in the tooltip.
#' @param metric	Determines which measurement system (metric or imperial) is used.
#' @param feet When not metric, use feet instead of yards for display.
#' @param nautic When not metric, not feet, use nautic mile for display.
#' @param zIndexOffset	This should be a high number to ensure that you can draw over all other layers on the map.
#' @param shapeOptions	Leaflet Polyline options	See \code{\link{drawShapeOptions}}().
#' @param repeatMode	Determines if the draw tool remains enabled after drawing a shape.
#' @export
#' @rdname draw-options
drawPolylineOptions <- function(
    allowIntersection = TRUE,
    drawError = list(color = "#b00b00", timeout = 2500),
    guidelineDistance = 20,
    maxGuideLineLength = 4000,
    showLength = TRUE,
    metric = TRUE,
    feet = TRUE,
    nautic = FALSE,
    zIndexOffset = 2000,
    shapeOptions = drawShapeOptions(fill = FALSE),
    repeatMode = FALSE) {
  leaflet::filterNULL(list(
    allowIntersection = allowIntersection,
    drawError = drawError,
    guidelineDistance = guidelineDistance,
    maxGuideLineLength = maxGuideLineLength,
    showLength = showLength,
    metric = metric,
    feet = feet,
    nautic = nautic,
    zIndexOffset = zIndexOffset,
    shapeOptions = shapeOptions,
    repeatMode = repeatMode
  ))
}

#' Options for drawing polygons
#' @param showArea Show the area of the drawn polygon in m², ha or km². The area is only approximate and become less accurate the larger the polygon is.
#' @rdname draw-options
#' @export
drawPolygonOptions <- function(
    showArea = FALSE,
    metric = TRUE,
    shapeOptions = drawShapeOptions(),
    repeatMode = FALSE) {
  leaflet::filterNULL(list(
    showArea = showArea,
    metric = metric,
    shapeOptions = shapeOptions,
    repeatMode = repeatMode
  ))
}

#' Options for drawing rectangles
#' @rdname draw-options
#' @export
drawRectangleOptions <- function(
    showArea = TRUE,
    metric = TRUE,
    shapeOptions = drawShapeOptions(),
    repeatMode = FALSE) {
  leaflet::filterNULL(list(
    showArea = showArea,
    metric = metric,
    shapeOptions = shapeOptions,
    repeatMode = repeatMode
  ))
}

#' Options for drawing Circles
#' @rdname draw-options
#' @param showRadius Show the radius of the drawn circle in m, km, ft (feet), or nm (nautical mile).
#' @export
drawCircleOptions <- function(
    showRadius = TRUE,
    metric = TRUE,
    feet = TRUE,
    nautic = FALSE,
    shapeOptions = drawShapeOptions(),
    repeatMode = FALSE) {
  leaflet::filterNULL(list(
    shapeOptions = shapeOptions,
    repeatMode = repeatMode,
    showRadius = showRadius,
    metric = metric,
    feet = feet,
    nautic = nautic
  ))
}

#' Options for drawing markers
#' @param markerIcon Can be either \code{\link[leaflet]{makeIcon}}() OR \code{\link[leaflet]{makeAwesomeIcon}}
#' @rdname draw-options
#' @export
drawMarkerOptions <- function(
    markerIcon = NULL,
    zIndexOffset = 2000,
    repeatMode = FALSE) {
  leaflet::filterNULL(list(
    markerIcon = markerIcon,
    zIndexOffset = zIndexOffset,
    repeatMode = repeatMode
  ))
}

#' Options for drawing markers
#' @rdname draw-options
#' @export
drawCircleMarkerOptions <- function(
    stroke = TRUE,
    color = "#3388ff",
    weight = 4,
    opacity = 0.5,
    fill = TRUE,
    fillColor = NULL, # same as color by default
    fillOpacity = 0.2,
    clickable = TRUE,
    zIndexOffset = 2000,
    repeatMode = FALSE) {
  leaflet::filterNULL(list(
    stroke = stroke,
    color = color,
    weight = weight,
    opacity = opacity,
    fill = fill,
    fillColor = fillColor, # same as color by default
    fillOpacity = fillOpacity,
    clickable = clickable,
    zIndexOffset = zIndexOffset,
    repeatMode = repeatMode
  ))
}

#' Options for path when in editMode
#' @param maintainColor Whether to maintain shape's original color
#' @rdname draw-options
#' @export
selectedPathOptions <- function(
    dashArray = c("10, 10"),
    weight = 2,
    color = "black",
    fill = TRUE,
    fillColor = "black",
    fillOpacity = 0.6,
    maintainColor = FALSE) {
  leaflet::filterNULL(list(
    dashArray = dashArray,
    weight = weight,
    color = color,
    fill = fill,
    fillColor = fillColor,
    fillOpacity = fillOpacity,
    maintainColor = maintainColor
  ))
}

#' Options for editing shapes
#' @param edit Editing enabled by default. Set to false do disable editing.
#' @param selectedPathOptions To customize shapes in editing mode pass \code{\link{selectedPathOptions}}().
#' @param remove Set to false to disable removing.
#' @rdname draw-options
#' @export
editToolbarOptions <- function(
    edit = TRUE,
    remove = TRUE,
    selectedPathOptions = NULL,
    allowIntersection = TRUE) {
  leaflet::filterNULL(list(
    edit = edit,
    remove = remove,
    selectedPathOptions = selectedPathOptions,
    allowIntersection = allowIntersection
  ))
}


#' Options for editing handlers
#' @description Customize tooltips for \code{\link{addDrawToolbar}}
#' @param polyline List of options for polyline tooltips.
#' @param polygon List of options for polygon tooltips.
#' @param rectangle List of options for rectangle tooltips.
#' @param circle List of options for circle tooltips.
#' @param marker List of options for marker tooltips.
#' @param circlemarker List of options for circlemarker tooltips.
#' @export
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras)
#' leaflet() %>%
#'   addTiles() %>%
#'   addDrawToolbar(
#'     handlers = handlersOptions(
#'       polyline = list(
#'         tooltipStart = "Click It",
#'         tooltipCont = "Keep going",
#'         tooltipEnd = "Make it stop"
#'       ),
#'     ),
#'     polylineOptions = T, rectangleOptions = F, circleOptions = F,
#'     polygonOptions = F, markerOptions = F, circleMarkerOptions = F
#'   )
#' }
handlersOptions <- function(
    polyline = list(
      error = "<strong>Error:</strong> shape edges cannot cross!",
      tooltipStart = "Click to start drawing line.",
      tooltipCont = "Click to start drawing line.",
      tooltipEnd = "Click to start drawing line."
    ),
    polygon = list(
      tooltipStart = "Click to start drawing shape.",
      tooltipCont = "Click to start drawing shape.",
      tooltipEnd = "Click to start drawing shape."
    ),
    rectangle = list(
      tooltipStart = "Click and drag to draw rectangle."
    ),
    circle = list(
      tooltipStart = "Click map to place circle marker.",
      radius = "Radius"
    ),
    marker = list(
      tooltipStart = "Click map to place marker."
    ),
    circlemarker = list(
      tooltipStart = "Click and drag to draw circle."
    )) {
  leaflet::filterNULL(list(
    polyline = list(
      error = polyline$error,
      tooltip = list(
        start = polyline$tooltipStart,
        cont = polyline$tooltipCont,
        end = polyline$tooltipEnd
      )
    ),
    polygon = list(
      tooltip = list(
        start = polygon$tooltipStart,
        cont = polygon$tooltipCont,
        end = polygon$tooltipEnd
      )
    ),
    rectangle = list(tooltip = list(start = rectangle$tooltipStart)),
    circle = list(
      radius = circle$radius,
      tooltip = list(start = circle$tooltipStart)
    ),
    marker = list(tooltip = list(start = marker$tooltipStart)),
    circlemarker = list(tooltip = list(start = circlemarker$tooltipStart))
  ))
}


#' Options for editing the toolbar
#' @description Customize the toolbar for \code{\link{addDrawToolbar}}
#' @param actions List of options for actions toolbar button.
#' @param finish List of options for finish toolbar button.
#' @param undo List of options for undo toolbar button.
#' @param buttons List of options for buttons toolbar button.
#' @export
#' @examples \dontrun{
#' library(leaflet)
#' library(leaflet.extras)
#' leaflet() %>%
#'   addTiles() %>%
#'   addDrawToolbar(
#'     toolbar = toolbarOptions(
#'       actions = list(text = "STOP"),
#'       finish = list(text = "DONE"),
#'       buttons = list(
#'         polyline = "Draw a sexy polyline",
#'         rectangle = "Draw a gigantic rectangle",
#'         circlemarker = "Make a nice circle"
#'       ),
#'     ),
#'     polylineOptions = T, rectangleOptions = T, circleOptions = T,
#'     polygonOptions = F, markerOptions = F, circleMarkerOptions = F
#'   )
#' }
toolbarOptions <- function(
    actions = list(
      title = "Cancel drawing",
      text = "Cancel"
    ),
    finish = list(
      title = "Finish drawing",
      text = "Finish"
    ),
    undo = list(
      title = "Delete last point drawn",
      text = "Delete last point"
    ),
    buttons = list(
      polyline = "Draw a polyline",
      polygon = "Draw a polygon",
      rectangle = "Draw a rectangle",
      circle = "Draw a circle",
      marker = "Draw a marker",
      circlemarker = "Draw a circlemarker"
    )) {
  leaflet::filterNULL(list(
    actions = list(
      title = actions$title,
      text = actions$text
    ),
    finish = list(
      title = finish$title,
      text = finish$text
    ),
    undo = list(
      title = undo$title,
      text = undo$text
    ),
    buttons = list(
      polyline = buttons$polyline,
      polygon = buttons$polygon,
      rectangle = buttons$rectangle,
      circle = buttons$circle,
      marker = buttons$marker,
      circlemarker = buttons$circlemarker
    )
  ))
}
