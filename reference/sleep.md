# Prevents accidental map scrolling when scrolling in a document.

Prevents accidental map scrolling when scrolling in a document.

## Usage

``` r
suspendScroll(
  map,
  sleep = TRUE,
  sleepTime = 750,
  wakeTime = 750,
  sleepNote = TRUE,
  hoverToWake = TRUE,
  wakeMessage = "Click or Hover to Wake",
  sleepOpacity = 0.7
)
```

## Arguments

- map:

  The leaflet map

- sleep:

  false if you want an unruly map

- sleepTime:

  time(ms) until map sleeps on mouseout

- wakeTime:

  time(ms) until map wakes on mouseover

- sleepNote:

  should the user receive wake instructions?

- hoverToWake:

  should hovering wake the map? (non-touch devices only)

- wakeMessage:

  a message to inform users about waking the map

- sleepOpacity:

  opacity for the sleeping map

## Examples

``` r
leaflet(width = "100%") %>%
  setView(0, 0, 1) %>%
  addTiles() %>%
  suspendScroll()

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"sleep":true,"sleepTime":750,"wakeTime":750,"sleepNote":true,"hoverToWake":true,"wakeMessage":"Click or Hover to Wake","sleepOpacity":0.7},"setView":[[0,0],1,[]],"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]}]},"evals":[],"jsHooks":[]}
```
