# Adds a Toolbar to draw shapes/points on the map.

Adds a Toolbar to draw shapes/points on the map.

Removes the draw toolbar

## Usage

``` r
addDrawToolbar(
  map,
  targetLayerId = NULL,
  targetGroup = NULL,
  position = c("topleft", "topright", "bottomleft", "bottomright"),
  polylineOptions = drawPolylineOptions(),
  polygonOptions = drawPolygonOptions(),
  circleOptions = drawCircleOptions(),
  rectangleOptions = drawRectangleOptions(),
  markerOptions = drawMarkerOptions(),
  circleMarkerOptions = drawCircleMarkerOptions(),
  editOptions = FALSE,
  singleFeature = FALSE,
  toolbar = NULL,
  handlers = NULL,
  edittoolbar = NULL,
  edithandlers = NULL,
  drag = TRUE
)

removeDrawToolbar(map, clearFeatures = FALSE)
```

## Arguments

- map:

  The map widget.

- targetLayerId:

  An optional layerId of a GeoJSON/TopoJSON layer whose features need to
  be editable. Used for adding a GeoJSON/TopoJSON layer and then editing
  the features using the draw plugin.

- targetGroup:

  An optional group name of a Feature Group whose features need to be
  editable. Used for adding shapes(markers, lines, polygons) and then
  editing them using the draw plugin. You can either set layerId or
  group or none but not both.

- position:

  The position where the toolbar should appear.

- polylineOptions:

  See
  [`drawPolylineOptions`](https://trafficonese.github.io/leaflet.extras/reference/draw-options.md)().
  Set to FALSE to disable polyline drawing.

- polygonOptions:

  See
  [`drawPolygonOptions`](https://trafficonese.github.io/leaflet.extras/reference/draw-options.md)().
  Set to FALSE to disable polygon drawing.

- circleOptions:

  See
  [`drawCircleOptions`](https://trafficonese.github.io/leaflet.extras/reference/draw-options.md)().
  Set to FALSE to disable circle drawing.

- rectangleOptions:

  See
  [`drawRectangleOptions`](https://trafficonese.github.io/leaflet.extras/reference/draw-options.md)().
  Set to FALSE to disable rectangle drawing.

- markerOptions:

  See
  [`drawMarkerOptions`](https://trafficonese.github.io/leaflet.extras/reference/draw-options.md)().
  Set to FALSE to disable marker drawing.

- circleMarkerOptions:

  See
  [`drawCircleMarkerOptions`](https://trafficonese.github.io/leaflet.extras/reference/draw-options.md)().
  Set to FALSE to disable circle marker drawing.

- editOptions:

  By default editing is disable. To enable editing pass
  [`editToolbarOptions`](https://trafficonese.github.io/leaflet.extras/reference/draw-options.md)().

- singleFeature:

  When set to TRUE, only one feature can be drawn at a time, the
  previous ones being removed.

- toolbar:

  See
  [`toolbarOptions`](https://trafficonese.github.io/leaflet.extras/reference/toolbarOptions.md).
  Set to `NULL` to take Leaflets default values.

- handlers:

  See
  [`handlersOptions`](https://trafficonese.github.io/leaflet.extras/reference/handlersOptions.md).
  Set to `NULL` to take Leaflets default values.

- edittoolbar:

  See
  [`edittoolbarOptions`](https://trafficonese.github.io/leaflet.extras/reference/edittoolbarOptions.md).
  Set to `NULL` to take Leaflets default values.

- edithandlers:

  See
  [`edithandlersOptions`](https://trafficonese.github.io/leaflet.extras/reference/edithandlersOptions.md).
  Set to `NULL` to take Leaflets default values.

- drag:

  When set to `TRUE`, the drawn features will be draggable during
  editing, utilizing the `Leaflet.Draw.Drag` plugin. Otherwise, this
  library will not be included.

- clearFeatures:

  whether to clear the map of drawn features.

## Details

The drawn features emit events upon mouse interaction. Event names
follow the pattern: `input$MAPID_LAYERCATEGORY_EVENTNAME`, where
`LAYERCATEGORY` can be one of:

- `marker`

- `shape`

- `polyline`

Similarly, for `EVENTNAME`, valid values are:

- `click`

- `mouseover`

- `mouseout`

See the provided example for usage:

`browseURL(system.file("examples/shiny/draw-events/draw_mouse_events.R", package = "leaflet.extras"))`

## Examples

``` r
leaflet() %>%
  setView(0, 0, 2) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addDrawToolbar(
    targetGroup = "draw",
    editOptions = editToolbarOptions(
      selectedPathOptions = selectedPathOptions()
    )
  ) %>%
  addLayersControl(
    overlayGroups = c("draw"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  addStyleEditor()

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"setView":[[0,0],2,[]],"calls":[{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addDrawToolbar","args":[null,"draw",{"position":"topleft","draw":{"polyline":{"allowIntersection":true,"drawError":{"color":"#b00b00","timeout":2500},"guidelineDistance":20,"maxGuideLineLength":4000,"showLength":true,"metric":true,"feet":true,"nautic":false,"zIndexOffset":2000,"shapeOptions":{"stroke":true,"color":"#03f","weight":1,"opacity":1,"fill":false,"fillColor":"#03f","fillOpacity":0.4,"clickable":true,"smoothFactor":1,"noClip":true},"repeatMode":false},"polygon":{"showArea":false,"metric":true,"shapeOptions":{"stroke":true,"color":"#03f","weight":1,"opacity":1,"fill":true,"fillColor":"#03f","fillOpacity":0.4,"clickable":true,"smoothFactor":1,"noClip":true},"repeatMode":false},"circle":{"shapeOptions":{"stroke":true,"color":"#03f","weight":1,"opacity":1,"fill":true,"fillColor":"#03f","fillOpacity":0.4,"clickable":true,"smoothFactor":1,"noClip":true},"repeatMode":false,"showRadius":true,"metric":true,"feet":true,"nautic":false},"rectangle":{"showArea":true,"metric":true,"shapeOptions":{"stroke":true,"color":"#03f","weight":1,"opacity":1,"fill":true,"fillColor":"#03f","fillOpacity":0.4,"clickable":true,"smoothFactor":1,"noClip":true},"repeatMode":false},"marker":{"zIndexOffset":2000,"repeatMode":false},"circlemarker":{"stroke":true,"color":"#3388ff","weight":4,"opacity":0.5,"fill":true,"fillOpacity":0.2,"clickable":true,"zIndexOffset":2000,"repeatMode":false},"singleFeature":false},"edit":{"edit":true,"remove":true,"selectedPathOptions":{"dashArray":"10, 10","weight":2,"color":"black","fill":true,"fillColor":"black","fillOpacity":0.6,"maintainColor":false},"allowIntersection":true},"toolbar":null,"handlers":null,"edittoolbar":null,"edithandlers":null}]},{"method":"addLayersControl","args":[[],"draw",{"collapsed":false,"autoZIndex":true,"position":"topright"}]},{"method":"addStyleEditor","args":[{"position":"topleft","openOnLeafletDraw":true,"useGrouping":false}]}]},"evals":[],"jsHooks":[]}
## for more examples see
# browseURL(system.file("examples/draw.R",
#                       package = "leaflet.extras"))
# browseURL(system.file("examples/shiny/draw-events/app.R",
#                       package = "leaflet.extras"))
# browseURL(system.file("examples/shiny/draw-events/draw_mouse_events.R",
#                       package = "leaflet.extras"))
```
