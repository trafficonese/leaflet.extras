# Add style editor

Add style editor

Remove style editor

## Usage

``` r
addStyleEditor(
  map,
  position = c("topleft", "topright", "bottomleft", "bottomright"),
  openOnLeafletDraw = TRUE,
  useGrouping = FALSE,
  ...
)

removeStyleEditor(map)
```

## Arguments

- map:

  the map widget

- position:

  position of the control

- openOnLeafletDraw:

  whether to open automatically when used with
  [`addDrawToolbar`](https://trafficonese.github.io/leaflet.extras/reference/draw.md)()

- useGrouping:

  Should be false to work with
  [`addDrawToolbar`](https://trafficonese.github.io/leaflet.extras/reference/draw.md)()

- ...:

  other options. See [plugin
  code](https://github.com/dwilhelm89/Leaflet.StyleEditor/blob/master/src/javascript/Leaflet.StyleEditor.js)

## Examples

``` r
leaflet() %>%
  setView(0, 0, 2) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addDrawToolbar(
    targetGroup = "draw",
    editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions())
  ) %>%
  addLayersControl(
    overlayGroups = c("draw"), options = layersControlOptions(collapsed = FALSE)
  ) %>%
  # add the style editor to alter shapes added to map
  addStyleEditor()

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"setView":[[0,0],2,[]],"calls":[{"method":"addProviderTiles","args":["CartoDB.Positron",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addDrawToolbar","args":[null,"draw",{"position":"topleft","draw":{"polyline":{"allowIntersection":true,"drawError":{"color":"#b00b00","timeout":2500},"guidelineDistance":20,"maxGuideLineLength":4000,"showLength":true,"metric":true,"feet":true,"nautic":false,"zIndexOffset":2000,"shapeOptions":{"stroke":true,"color":"#03f","weight":1,"opacity":1,"fill":false,"fillColor":"#03f","fillOpacity":0.4,"clickable":true,"smoothFactor":1,"noClip":true},"repeatMode":false},"polygon":{"showArea":false,"metric":true,"shapeOptions":{"stroke":true,"color":"#03f","weight":1,"opacity":1,"fill":true,"fillColor":"#03f","fillOpacity":0.4,"clickable":true,"smoothFactor":1,"noClip":true},"repeatMode":false},"circle":{"shapeOptions":{"stroke":true,"color":"#03f","weight":1,"opacity":1,"fill":true,"fillColor":"#03f","fillOpacity":0.4,"clickable":true,"smoothFactor":1,"noClip":true},"repeatMode":false,"showRadius":true,"metric":true,"feet":true,"nautic":false},"rectangle":{"showArea":true,"metric":true,"shapeOptions":{"stroke":true,"color":"#03f","weight":1,"opacity":1,"fill":true,"fillColor":"#03f","fillOpacity":0.4,"clickable":true,"smoothFactor":1,"noClip":true},"repeatMode":false},"marker":{"zIndexOffset":2000,"repeatMode":false},"circlemarker":{"stroke":true,"color":"#3388ff","weight":4,"opacity":0.5,"fill":true,"fillOpacity":0.2,"clickable":true,"zIndexOffset":2000,"repeatMode":false},"singleFeature":false},"edit":{"edit":true,"remove":true,"selectedPathOptions":{"dashArray":"10, 10","weight":2,"color":"black","fill":true,"fillColor":"black","fillOpacity":0.6,"maintainColor":false},"allowIntersection":true},"toolbar":null,"handlers":null,"edittoolbar":null,"edithandlers":null}]},{"method":"addLayersControl","args":[[],"draw",{"collapsed":false,"autoZIndex":true,"position":"topright"}]},{"method":"addStyleEditor","args":[{"position":"topleft","openOnLeafletDraw":true,"useGrouping":false}]}]},"evals":[],"jsHooks":[]}
```
