# Add fullscreen control

Add a fullscreen control button

## Usage

``` r
addFullscreenControl(map, position = "topleft", pseudoFullscreen = FALSE)
```

## Arguments

- map:

  The leaflet map

- position:

  position of control: "topleft", "topright", "bottomleft", or
  "bottomright"

- pseudoFullscreen:

  if true, fullscreen to page width and height

## Examples

``` r
leaflet() %>%
  addTiles() %>%
  addFullscreenControl()

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"fullscreenControl":{"position":"topleft","pseudoFullscreen":false}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]}]},"evals":[],"jsHooks":[]}
```
