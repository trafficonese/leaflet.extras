# Options for drawn shapes

Options for drawn shapes

Options for drawing polylines

Options for drawing polygons

Options for drawing rectangles

Options for drawing Circles

Options for drawing markers

Options for drawing markers

Options for path when in editMode

Options for editing shapes

## Usage

``` r
drawShapeOptions(
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
  smoothFactor = 1,
  noClip = TRUE
)

drawPolylineOptions(
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
  repeatMode = FALSE
)

drawPolygonOptions(
  showArea = FALSE,
  metric = TRUE,
  shapeOptions = drawShapeOptions(),
  repeatMode = FALSE
)

drawRectangleOptions(
  showArea = TRUE,
  metric = TRUE,
  shapeOptions = drawShapeOptions(),
  repeatMode = FALSE
)

drawCircleOptions(
  showRadius = TRUE,
  metric = TRUE,
  feet = TRUE,
  nautic = FALSE,
  shapeOptions = drawShapeOptions(),
  repeatMode = FALSE
)

drawMarkerOptions(markerIcon = NULL, zIndexOffset = 2000, repeatMode = FALSE)

drawCircleMarkerOptions(
  stroke = TRUE,
  color = "#3388ff",
  weight = 4,
  opacity = 0.5,
  fill = TRUE,
  fillColor = NULL,
  fillOpacity = 0.2,
  clickable = TRUE,
  zIndexOffset = 2000,
  repeatMode = FALSE
)

selectedPathOptions(
  dashArray = c("10, 10"),
  weight = 2,
  color = "black",
  fill = TRUE,
  fillColor = "black",
  fillOpacity = 0.6,
  maintainColor = FALSE
)

editToolbarOptions(
  edit = TRUE,
  remove = TRUE,
  selectedPathOptions = NULL,
  allowIntersection = TRUE
)
```

## Arguments

- stroke:

  Whether to draw stroke along the path. Set it to false to disable
  borders on polygons or circles.

- color:

  Stroke color.

- weight:

  Stroke width in pixels.

- opacity:

  Stroke opacity.

- fill:

  Whether to fill the path with color. Set it to false to disable
  filling on polygons or circles.

- fillColor:

  same as color Fill color.

- fillOpacity:

  Fill opacity.

- dashArray:

  A string that defines the stroke dash pattern. Doesn't work on
  canvas-powered layers (e.g. Android 2).

- lineCap:

  A string that defines shape to be used at the end of the stroke.

- lineJoin:

  A string that defines shape to be used at the corners of the stroke.

- clickable:

  If false, the vector will not emit mouse events and will act as a part
  of the underlying map.

- pointerEvents:

  Sets the pointer-events attribute on the path if SVG backend is used.

- smoothFactor:

  How much to simplify the polyline on each zoom level. More means
  better performance and smoother look, and less means more accurate
  representation.

- noClip:

  Disabled polyline clipping.

- allowIntersection:

  Determines if line segments can cross.

- drawError:

  Configuration options for the error that displays if an intersection
  is detected.

- guidelineDistance:

  Distance in pixels between each guide dash.

- maxGuideLineLength:

  Maximum length of the guide lines.

- showLength:

  Whether to display the distance in the tooltip.

- metric:

  Determines which measurement system (metric or imperial) is used.

- feet:

  When not metric, use feet instead of yards for display.

- nautic:

  When not metric, not feet, use nautic mile for display.

- zIndexOffset:

  This should be a high number to ensure that you can draw over all
  other layers on the map.

- shapeOptions:

  Leaflet Polyline options See `drawShapeOptions`().

- repeatMode:

  Determines if the draw tool remains enabled after drawing a shape.

- showArea:

  Show the area of the drawn polygon in m², ha or km². The area is only
  approximate and become less accurate the larger the polygon is.

- showRadius:

  Show the radius of the drawn circle in m, km, ft (feet), or nm
  (nautical mile).

- markerIcon:

  Can be either
  [`makeIcon`](https://rstudio.github.io/leaflet/reference/makeIcon.html)()
  OR
  [`makeAwesomeIcon`](https://rstudio.github.io/leaflet/reference/makeAwesomeIcon.html)

- maintainColor:

  Whether to maintain shape's original color

- edit:

  Editing enabled by default. Set to false do disable editing.

- remove:

  Set to false to disable removing.

- selectedPathOptions:

  To customize shapes in editing mode pass `selectedPathOptions`().
