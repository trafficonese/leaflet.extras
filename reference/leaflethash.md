# Add dynamic URL Hash

Leaflet-hash lets you to add dynamic URL hashes to web pages with
Leaflet maps. You can easily link users to specific map views.

## Usage

``` r
addHash(map)
```

## Arguments

- map:

  The leaflet map

## Examples

``` r
leaflet() %>%
  addTiles() %>%
  addHash()

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]}]},"evals":[],"jsHooks":{"render":[{"code":"function(el, x, data) {\n  return (function(el,x,data){var hash = new L.Hash(this);}).call(this.getMap(), el, x, data);\n}","data":null}]}}
```
