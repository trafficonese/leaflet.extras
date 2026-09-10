# Enables measuring of length of polylines and areas of polygons

Enables measuring of length of polylines and areas of polygons

Options for measure-path

Adds a toolbar to enable/disable measuring path distances/areas

## Usage

``` r
enableMeasurePath(map)

measurePathOptions(
  showOnHover = FALSE,
  minPixelDistance = 30,
  showDistances = TRUE,
  showArea = TRUE,
  imperial = FALSE
)

addMeasurePathToolbar(map, options = measurePathOptions(), group = NULL)
```

## Arguments

- map:

  The map widget.

- showOnHover:

  If TRUE, the measurements will only show when the user hovers the
  cursor over the path.

- minPixelDistance:

  The minimum length a line segment in the feature must have for a
  measurement to be added.

- showDistances:

  If FALSE, doesn't show distances along line segments of of a
  polyline/polygon.

- showArea:

  If FALSE, doesn't show areas of a polyline/polygon.

- imperial:

  If TRUE the distances/areas will be shown in imperial units.

- options:

  The measurePathOptions.

- group:

  A character vector specifying the group(s) of layers for measurements.
  If \`group\` is \`NULL\` (default), measurements apply to all layers.
  For a single group or multiple groups, measurements apply only to
  matching layers.

## Examples

``` r
# \donttest{
geoJson <- readr::read_file(
  system.file(
    "examples/data/geojson/crimes_by_district.topojson",
    package = "leaflet.extras"
  )
)

leaflet() %>%
  addTiles() %>%
  setView(-75.14, 40, 11) %>%
  addBootstrapDependency() %>%
  enableMeasurePath() %>%
  addGeoJSONChoropleth(
    geoJson,
    valueProperty = "incidents",
    scale = c("white", "red"),
    mode = "q",
    steps = 4,
    padding = c(0.2, 0),
    labelProperty = "location",
    popupProperty = propstoHTMLTable(
      props = c("dist_numc", "location", "incidents"),
      table.attrs = list(class = "table table-striped table-bordered"),
      drop.na = TRUE
    ),
    color = "#ffffff", weight = 1, fillOpacity = 0.7,
    highlightOptions = highlightOptions(
      weight = 2, color = "#000000",
      fillOpacity = 1, opacity = 1,
      bringToFront = TRUE, sendToBack = TRUE
    ),
    pathOptions = pathOptions(
      showMeasurements = TRUE,
      measurementOptions = measurePathOptions(imperial = TRUE)
    )
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addGeoJSONChoropleth","args":["{\n  \"type\": \"Topology\",\n  \"bbox\": [-75.25, 39.87, -75.05, 40.05],\n  \"objects\": {\n    \"districts\": {\n      \"type\": \"GeometryCollection\",\n      \"geometries\": [\n        {\n          \"type\": \"Polygon\",\n          \"arcs\": [[0]],\n          \"properties\": {\n            \"dist_numc\": \"01\",\n            \"location\": \"Center City\",\n            \"incidents\": 120,\n            \"_feature_id_string\": \"1\"\n          }\n        },\n        {\n          \"type\": \"Polygon\",\n          \"arcs\": [[1]],\n          \"properties\": {\n            \"dist_numc\": \"02\",\n            \"location\": \"North\",\n            \"incidents\": 45,\n            \"_feature_id_string\": \"2\"\n          }\n        }\n      ]\n    }\n  },\n  \"arcs\": [\n    [[0, 0], [0, 1], [1, 1], [1, 0], [0, 0]],\n    [[1, 0], [1, 1], [2, 1], [2, 0], [1, 0]]\n  ]\n}\n",null,null,"location",{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},"function(feature){\n         return '<table class=\"table table-striped table-bordered\"><caption>Properties<\/caption><tbody style=\"font-size:x-small\">' +\n           ( $.isEmptyObject(feature.properties) ? '' :\n             L.Util.template(\"<tr><td><b>dist_numc<\/b><\/td><td>{dist_numc}<\/td><\/tr><tr><td><b>location<\/b><\/td><td>{location}<\/td><\/tr><tr><td><b>incidents<\/b><\/td><td>{incidents}<\/td><\/tr>\",feature.properties)\n           )+ \"<\/tbody><\/table>\";\n       }",{"maxWidth":300,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"className":""},{"interactive":true,"className":"","showMeasurements":true,"measurementOptions":{"showOnHover":false,"minPixelDistance":30,"showDistances":true,"showArea":true,"imperial":true},"valueProperty":"incidents","fillOpacityProperty":null,"scale":["white","red"],"steps":4,"mode":"q","channelMode":"rgb","padding":[0.2,0],"correctLightness":false,"bezierInterpolate":false,"colors":null,"stroke":true,"color":"#ffffff","weight":1,"opacity":0.5,"fillOpacity":0.7,"dashArray":null,"smoothFactor":1,"noClip":false},{"color":"#000000","weight":2,"opacity":1,"fillOpacity":1,"bringToFront":true,"sendToBack":true},null]}],"setView":[[40,-75.14],11,[]]},"evals":["calls.1.args.5"],"jsHooks":[]}# }

leaflet() %>%
  addTiles() %>%
  addCircles(lng = c(10, 20), lat = c(50, 60), group = "Group 1") %>%
  addCircles(lng = c(15, 25), lat = c(55, 65), group = "Group 2") %>%
  addMeasurePathToolbar(group = "Group 1") # Enable measurements for "Group 1" only

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addCircles","args":[[50,60],[10,20],10,null,"Group 1",{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]},{"method":"addCircles","args":[[55,65],[15,25],10,null,"Group 2",{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null,null]},{"method":"addEasyButtonBar","args":[[{"icon":[],"title":[],"position":"topleft","states":[{"stateName":"disabled-measurement","icon":"ion-ios-flask-outline","title":"Enable Measurements","onClick":"\n          function(btn, map) {\n             LeafletWidget.methods.enableMeasurements.call(map, '[\"Group 1\"]');\n             btn.state(\"enabled-measurement\");\n          }"},{"stateName":"enabled-measurement","icon":"ion-ios-flask","title":"Disable Measurements","onClick":"\n          function(btn, map) {\n             LeafletWidget.methods.disableMeasurements.call(map, '[\"Group 1\"]');\n             btn.state(\"disabled-measurement\");\n          }"}]},{"icon":"ion-android-refresh","title":"Recalculate Measurements","onClick":"\n          function(btn, map) {\n             LeafletWidget.methods.refreshMeasurements.call(map, '[\"Group 1\"]');\n          }","position":"topleft"}],"topleft",null]},{"method":"setMeasurementOptions","args":[{"showOnHover":false,"minPixelDistance":30,"showDistances":true,"showArea":true,"imperial":false}]}],"limits":{"lat":[50,65],"lng":[10,25]}},"evals":["calls.3.args.0.0.states.0.onClick","calls.3.args.0.0.states.1.onClick","calls.3.args.0.1.onClick"],"jsHooks":[]}
```
