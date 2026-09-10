# Create a list of weather icon data see

An icon can be represented as a list of the form
`list(icon, markerColor, ...)`. This function is vectorized over its
arguments to create a list of icon data. Shorter argument values will be
re-cycled. `NULL` values for these arguments will be ignored.

## Usage

``` r
weatherIconList(...)

# S3 method for class 'leaflet_weather_icon_set'
x[i]

makeWeatherIcon(
  icon,
  markerColor = "red",
  iconColor = "white",
  extraClasses = NULL
)

weatherIcons(
  icon,
  markerColor = "red",
  iconColor = "white",
  extraClasses = NULL
)

addWeatherMarkers(
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

  icons created from `makeWeatherIcon()` iconSet\[c("hurricane",
  "tornado")\]

- x:

  icons

- i:

  offset

- icon:

  the weather icon name w/o the "wi-" prefix. For a full list see
  <https://erikflowers.github.io/weather-icons/>

- markerColor:

  color of the marker

- iconColor:

  color of the weather icon

- extraClasses:

  Character vector of extra classes.

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

iconSet <- weatherIconList(
  hurricane = makeWeatherIcon(icon = "hurricane"),
  tornado = makeWeatherIcon(icon = "tornado")
)

leaflet() %>%
  addTiles() %>%
  addWeatherMarkers(
    lng = -118.456554, lat = 34.078039,
    label = "This is a label",
    icon = makeWeatherIcon(
      icon = "hot",
      iconColor = "#ffffff77",
      markerColor = "blue"
    )
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addWeatherMarkers","args":[34.078039,-118.456554,{"icon":"hot","markerColor":"blue","iconColor":"#ffffff77"},null,null,{"interactive":true,"draggable":false,"keyboard":true,"title":"","alt":"","zIndexOffset":0,"opacity":1,"riseOnHover":false,"riseOffset":250},null,null,null,null,"This is a label",null]}],"limits":{"lat":[34.078039,34.078039],"lng":[-118.456554,-118.456554]}},"evals":[],"jsHooks":[]}
## for more examples see
# browseURL(system.file("examples/weatherIcons.R", package = "leaflet.extras"))
```
