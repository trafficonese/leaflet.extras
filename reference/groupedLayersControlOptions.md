# Options for the GroupedLayersControl

Options for the GroupedLayersControl

## Usage

``` r
groupedLayersControlOptions(
  exclusiveGroups = NULL,
  groupCheckboxes = TRUE,
  groupsCollapsable = TRUE,
  groupsCollapsed = TRUE,
  groupsExpandedClass = "leaflet-control-layers-group-collapse-default",
  groupsCollapsedClass = "leaflet-control-layers-group-expand-default",
  sortLayers = FALSE,
  sortGroups = FALSE,
  sortBaseLayers = FALSE,
  collapsed = TRUE,
  autoZIndex = TRUE,
  ...
)
```

## Arguments

- exclusiveGroups:

  character vector of layer groups to make exclusive (use radio buttons)

- groupCheckboxes:

  Show a checkbox next to non-exclusive group labels for toggling all

- groupsCollapsable:

  Should groups be collapsible? Default is `TRUE`

- groupsCollapsed:

  A logical, character string, or character vector:

  - `TRUE` (default): Collapses all groups.

  - `FALSE`: No groups are collapsed.

  - A string: Collapses a single group (e.g., `"Group 1"`).

  - A vector of strings: Collapses multiple groups (e.g.,
    `c("Group 1", "Group 2")`).

- groupsExpandedClass:

  The CSS class of expanded groups

- groupsCollapsedClass:

  The CSS class of collapsed groups

- sortLayers:

  Sort the overlay layers alphabetically? Default is `FALSE`

- sortGroups:

  Sort the groups alphabetically? Default is `FALSE`

- sortBaseLayers:

  Sort the baselayers alphabetically? Default is `FALSE`

- collapsed:

  if `TRUE` (the default), the layers control will be rendered as an
  icon that expands when hovered over. Set to `FALSE` to have the layers
  control always appear in its expanded state.

- autoZIndex:

  if `TRUE`, the control will automatically maintain the z-order of its
  various groups as overlays are switched on and off.

- ...:

  other options for
  [`layersControlOptions()`](https://rstudio.github.io/leaflet/reference/addLayersControl.html)

## See also

Other GroupedLayersControl:
[`addGroupedLayersControl()`](https://trafficonese.github.io/leaflet.extras/reference/addGroupedLayersControl.md),
[`addGroupedOverlay()`](https://trafficonese.github.io/leaflet.extras/reference/GroupedLayersControl.md)
