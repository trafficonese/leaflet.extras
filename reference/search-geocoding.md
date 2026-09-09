# Add a OSM search control to the map.

Add a OSM search control to the map.

Add a OSM search control to the map.

Removes the OSM search control from the map.

Clears the search marker

Add a Google search control to the map.

Removes the Google search control from the map.

Add a US Census Bureau search control to the map.

Removes the US Census Bureau search control from the map.

## Usage

``` r
addSearchOSM(map, options = searchOptions(autoCollapse = TRUE, minLength = 2))

searchOSMText(map, text = "")

removeSearchOSM(map)

clearSearchOSM(map)

addReverseSearchOSM(
  map,
  showSearchLocation = TRUE,
  showBounds = FALSE,
  showFeature = TRUE,
  fitBounds = TRUE,
  displayText = TRUE,
  group = NULL,
  marker = list(icon = NULL),
  showFeatureOptions = list(weight = 2, color = "red", dashArray = "5,10", fillOpacity =
    0.2, opacity = 0.5),
  showBoundsOptions = list(weight = 2, color = "#444444", dashArray = "5,10", fillOpacity
    = 0.2, opacity = 0.5),
  showHighlightOptions = list(opacity = 0.8, fillOpacity = 0.5, weight = 5)
)

addSearchGoogle(
  map,
  apikey = Sys.getenv("GOOGLE_MAP_GEOCODING_KEY"),
  options = searchOptions(autoCollapse = TRUE, minLength = 2)
)

removeSearchGoogle(map)

addReverseSearchGoogle(
  map,
  apikey = Sys.getenv("GOOGLE_MAP_GEOCODING_KEY"),
  showSearchLocation = TRUE,
  showBounds = FALSE,
  showFeature = TRUE,
  fitBounds = TRUE,
  displayText = TRUE,
  group = NULL
)

addSearchUSCensusBureau(
  map,
  options = searchOptions(autoCollapse = TRUE, minLength = 20)
)

removeSearchUSCensusBureau(map)
```

## Arguments

- map:

  a map widget object

- options:

  Search Options

- text:

  The search text

- showSearchLocation:

  Boolean. If TRUE displays a Marker on the searched location's
  coordinates.

- showBounds:

  Boolean. If TRUE show the bounding box of the found feature.

- showFeature:

  Boolean. If TRUE show the found feature. Depending upon the feature
  found this can be a marker, a line or a polygon.

- fitBounds:

  Boolean. If TRUE set maps bounds to queried and found location. For
  this to be effective one of `showSearchLocation`, `showBounds`,
  `showFeature` shoule also be TRUE.

- displayText:

  Boolean. If TRUE show a text box with found location's name on the
  map.

- group:

  String. An optional group to hold all the searched locations and their
  results.

- marker:

  Let's you set the icon. Can be an icon made by
  [`makeIcon`](https://rstudio.github.io/leaflet/reference/makeIcon.html)
  or
  [`makeAwesomeIcon`](https://rstudio.github.io/leaflet/reference/makeAwesomeIcon.html)

- showFeatureOptions:

  A list of styling options for the found feature

- showBoundsOptions:

  A list of styling options for the bounds of the found feature

- showHighlightOptions:

  A list of styling options for the hover effect of a found feature

- apikey:

  String. API Key for Google GeoCoding Service.

## Value

modified map

modified map

modified map

modified map

modified map

modified map

modified map

modified map

modified map

modified map

## Examples

``` r
leaflet() %>%
  addProviderTiles(providers$Esri.WorldStreetMap) %>%
  addResetMapButton() %>%
  addSearchGoogle()
#> Warning: Google Geocoding works best with an apikey

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["Esri.WorldStreetMap",null,null,{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addEasyButton","args":[{"icon":"ion-arrow-shrink","title":"Reset View","onClick":"function(btn, map){ map.setView(map._initialCenter, map._initialZoom); }","position":"topleft"}]},{"method":"addSearchGoogle","args":[{"moveToLocation":true,"zoom":17,"container":"","minLength":2,"initial":true,"casesensitive":false,"autoType":true,"delayType":400,"tooltipLimit":-1,"tipAutoSubmit":true,"firstTipSubmit":false,"autoResize":true,"collapsed":true,"autoCollapse":true,"autoCollapseTime":1200,"textErr":"Location Not Found","textCancel":"Cancel","textPlaceholder":"Search...","position":"topleft","hideMarkerOnCollapse":false,"marker":{"icon":null,"animate":true,"circle":{"radius":10,"weight":3,"color":"#e03","stroke":true,"fill":false}}}]}]},"evals":["calls.1.args.0.onClick"],"jsHooks":{"render":[{"code":"function(el, x, data) {\n  return (\nfunction(el, x){\n  var map = this;\n  map.whenReady(function(){\n    map._initialCenter = map.getCenter();\n    map._initialZoom = map.getZoom();\n  });\n}).call(this.getMap(), el, x, data);\n}","data":null}]}}
## for more examples see
# browseURL(system.file("examples/search.R", package = "leaflet.extras"))
```
