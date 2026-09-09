# Options for the GPS Control

Options for the GPS Control

Add a gps to the Map.

Removes the GPS Control

Activate the GPS Control. You should have already added the GPS control
before calling this method.

Deactivate the GPS Control. You should have already added the GPS
control before calling this method.

## Usage

``` r
gpsOptions(
  position = "topleft",
  activate = FALSE,
  autoCenter = FALSE,
  maxZoom = NULL,
  setView = FALSE
)

addControlGPS(map, options = gpsOptions())

removeControlGPS(map)

activateGPS(map)

deactivateGPS(map)
```

## Arguments

- position:

  Position of the Control

- activate:

  If TRUE activates the GPS on addition.

- autoCenter:

  If TRUE auto centers the map when GPS location changes

- maxZoom:

  If set zooms to this level when auto centering

- setView:

  If TRUE sets the view to the GPS location when found

- map:

  a map widget object

- options:

  Options for the GPS control.

## Examples

``` r
leaflet() %>%
  addTiles() %>%
  addControlGPS()

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addControlGPS","args":[{"position":"topleft","activate":false,"autoCenter":false,"setView":false}]}]},"evals":[],"jsHooks":[]}
```
