# Options for editing the toolbar

Customize the toolbar for
[`addDrawToolbar`](https://trafficonese.github.io/leaflet.extras/reference/draw.md)

## Usage

``` r
toolbarOptions(
  actions = list(title = "Cancel drawing", text = "Cancel"),
  finish = list(title = "Finish drawing", text = "Finish"),
  undo = list(title = "Delete last point drawn", text = "Delete last point"),
  buttons = list(polyline = "Draw a polyline", polygon = "Draw a polygon", rectangle =
    "Draw a rectangle", circle = "Draw a circle", marker = "Draw a marker", circlemarker
    = "Draw a circlemarker")
)
```

## Arguments

- actions:

  List of options for actions toolbar button.

- finish:

  List of options for finish toolbar button.

- undo:

  List of options for undo toolbar button.

- buttons:

  List of options for buttons toolbar button.

## Examples

``` r
if (FALSE) { # \dontrun{
library(leaflet)
library(leaflet.extras)
leaflet() %>%
  addTiles() %>%
  addDrawToolbar(
    toolbar = toolbarOptions(
      actions = list(text = "STOP"),
      finish = list(text = "DONE"),
      buttons = list(
        polyline = "Draw a sexy polyline",
        rectangle = "Draw a gigantic rectangle",
        circlemarker = "Make a nice circle"
      ),
    ),
    polylineOptions = T, rectangleOptions = T, circleOptions = T,
    polygonOptions = F, markerOptions = F, circleMarkerOptions = F
  )
} # }
```
