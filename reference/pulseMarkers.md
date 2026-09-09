# Make pulse-icon set

An icon can be represented as a list of the form
`list(color, iconSize, ...)`. This function is vectorized over its
arguments to create a list of icon data. Shorter argument values will be
re-cycled. `NULL` values for these arguments will be ignored.

## Usage

``` r
pulseIconList(...)

# S3 method for class 'leaflet_pulse_icon_set'
x[i]

makePulseIcon(
  color = "#ff0000",
  fillColor = color,
  iconSize = 12,
  animate = TRUE,
  heartbeat = 1
)

pulseIcons(
  color = "#ff0000",
  fillColor = color,
  iconSize = 12,
  animate = TRUE,
  heartbeat = 1
)

addPulseMarkers(
  map,
  lng = NULL,
  lat = NULL,
  layerId = NULL,
  group = NULL,
  icon = NULL,
  popup = NULL,
  popupOptions = NULL,
  label = NULL,
  labelOptions = NULL,
  options = leaflet::markerOptions(),
  clusterOptions = NULL,
  clusterId = NULL,
  data = leaflet::getMapData(map)
)
```

## Arguments

- ...:

  icons created from `makePulseIcon()`

- x:

  icons

- i:

  offset

- color:

  Color of the icon

- fillColor:

  Fill color of the icon

- iconSize:

  Size of Icon in Pixels.

- animate:

  To animate the icon or not, defaults to TRUE.

- heartbeat:

  Interval between each pulse in seconds.

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

- clusterOptions:

  if not `NULL`, markers will be clustered using
  [Leaflet.markercluster](https://github.com/Leaflet/Leaflet.markercluster);
  you can use
  [`markerClusterOptions()`](https://rstudio.github.io/leaflet/reference/map-options.html)
  to specify marker cluster options

- clusterId:

  the id for the marker cluster layer

- data:

  the data object from which the argument values are derived; by
  default, it is the `data` object provided to
  [`leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html)
  initially, but can be overridden

## Examples

``` r

iconSet <- pulseIconList(
  red = makePulseIcon(color = "#ff0000"),
  blue = makePulseIcon(color = "#0000ff")
)

iconSet[c("red", "blue")]
#> $red
#> $color
#> [1] "#ff0000"
#> 
#> $fillColor
#> [1] "#ff0000"
#> 
#> $iconSize
#> [1] 12
#> 
#> $animate
#> [1] TRUE
#> 
#> $heartbeat
#> [1] 1
#> 
#> attr(,"class")
#> [1] "leaflet_pulse_icon"
#> 
#> $blue
#> $color
#> [1] "#0000ff"
#> 
#> $fillColor
#> [1] "#0000ff"
#> 
#> $iconSize
#> [1] 12
#> 
#> $animate
#> [1] TRUE
#> 
#> $heartbeat
#> [1] 1
#> 
#> attr(,"class")
#> [1] "leaflet_pulse_icon"
#> 
#> attr(,"class")
#> [1] "leaflet_pulse_icon_set"

leaflet() %>%
  addTiles() %>%
  addPulseMarkers(
    lng = -118.456554, lat = 34.078039,
    label = "This is a label",
    icon = makePulseIcon(heartbeat = 0.5)
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addPulseMarkers","args":[34.078039,-118.456554,{"color":"#ff0000","fillColor":"#ff0000","iconSize":12,"animate":true,"heartbeat":0.5},null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,"This is a label",null]}],"limits":{"lat":[34.078039,34.078039],"lng":[-118.456554,-118.456554]}},"evals":[],"jsHooks":[]}

## for more examples see
# browseURL(system.file("examples/pulseIcon.R", package = "leaflet.extras"))
```
