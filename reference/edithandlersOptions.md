# Options for editing edit handlers

Customize edit handlers for
[`addDrawToolbar`](https://trafficonese.github.io/leaflet.extras/reference/draw.md)

## Usage

``` r
edithandlersOptions(
  edit = list(tooltipText = "Drag handles or markers to edit features.", tooltipSubtext =
    "Click cancel to undo changes."),
  remove = list(tooltipText = "Click on a feature to remove.")
)
```

## Arguments

- edit:

  List of options for editing tooltips.

- remove:

  List of options for removing tooltips.
