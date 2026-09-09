# Add Bounce Markers to map

Add Bounce Markers to map

## Usage

``` r
addBounceMarkers(
  map,
  lng = NULL,
  lat = NULL,
  layerId = NULL,
  group = NULL,
  icon = NULL,
  duration = 1000,
  height = 100,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  options = leaflet::markerOptions(),
  data = leaflet::getMapData(map)
)
```

## Arguments

- map:

  a map widget object created from
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)

- lng:

  a numeric vector of longitudes, or a one-sided formula of the form
  `~x` where `x` is a variable in `data`; by default (if not explicitly
  provided), it will be automatically inferred from `data` by looking
  for a column named `lng`, `long`, or `longitude` (case-insensitively)

- lat:

  a vector of latitudes or a formula (similar to the `lng` argument; the
  names `lat` and `latitude` are used when guessing the latitude column
  from `data`)

- layerId:

  the layer id

- group:

  the name of the group the newly created layers should belong to (for
  [`clearGroup`](https://rstudio.github.io/leaflet/reference/remove.html)
  and
  [`addLayersControl`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)
  purposes). Human-friendly group names are permitted–they need not be
  short, identifier-style names. Any number of layers and even different
  types of layers (e.g. markers and polygons) can share the same group
  name.

- icon:

  the icon(s) for markers; an icon is represented by an R list of the
  form `list(iconUrl = "?", iconSize = c(x, y))`, and you can use
  [`icons()`](https://rstudio.github.io/leaflet/reference/icons.html) to
  create multiple icons; note when you use an R list that contains
  images as local files, these local image files will be base64 encoded
  into the HTML page so the icon images will still be available even
  when you publish the map elsewhere

- duration:

  integer scalar: The duration of the animation in milliseconds.

- height:

  integer scalar: Height at which the marker is dropped.

- popup:

  a character vector of the HTML content for the popups (you are
  recommended to escape the text using
  [`htmlEscape()`](https://rstudio.github.io/htmltools/reference/htmlEscape.html)
  for security reasons)

- popupOptions:

  A Vector of
  [`popupOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide popups

- label:

  a character vector of the HTML content for the labels

- labelOptions:

  A Vector of
  [`labelOptions`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to provide label options for each label. Default `NULL`

- options:

  a list of extra options for tile layers, popups, paths (circles,
  rectangles, polygons, ...), or other map elements

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to `leaflet()` initially,
  but can be overridden

## See also

[GitHub:
leaflet.bouncemarker](https://github.com/maximeh/leaflet.bouncemarker)

## Author

Markus Dumke

## Examples

``` r
leaflet() %>%
  addTiles() %>%
  addBounceMarkers(49, 11)

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addBounceMarkers","args":[11,49,null,null,1000,100,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[11,11],"lng":[49,49]}},"evals":[],"jsHooks":[]}
```
