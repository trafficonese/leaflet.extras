# Options for search control.

Options for search control.

Customized searchOptions for Feature Search

## Usage

``` r
searchOptions(
  url = NULL,
  sourceData = NULL,
  jsonpParam = NULL,
  propertyLoc = NULL,
  propertyName = NULL,
  formatData = NULL,
  filterData = NULL,
  filtersearch = NULL,
  moveToLocation = TRUE,
  zoom = 17,
  buildTip = NULL,
  container = "",
  minLength = 1,
  initial = TRUE,
  casesensitive = FALSE,
  autoType = TRUE,
  delayType = 400,
  tooltipLimit = -1,
  tipAutoSubmit = TRUE,
  firstTipSubmit = FALSE,
  autoResize = TRUE,
  collapsed = TRUE,
  autoCollapse = FALSE,
  autoCollapseTime = 1200,
  textErr = "Location Not Found",
  textCancel = "Cancel",
  textPlaceholder = "Search...",
  position = "topleft",
  hideMarkerOnCollapse = FALSE,
  marker = list(icon = NULL, animate = TRUE, circle = list(radius = 10, weight = 3, color
    = "#e03", stroke = TRUE, fill = FALSE))
)

searchFeaturesOptions(
  propertyName = "label",
  initial = FALSE,
  openPopup = FALSE,
  ...
)
```

## Arguments

- url:

  url for search by ajax request, ex: \`search.php?q={s}\`. Can be
  function that returns string for dynamic parameter setting.

- sourceData:

  function that fill \_recordsCache, passed searching text by first
  param and callback in second.

- jsonpParam:

  jsonp param name for search by jsonp service, ex: "callback".

- propertyLoc:

  field for remapping location, using array: \["latname","lonname"\] for
  select double fields(ex. \["lat","lon"\] ) support dotted format:
  "prop.subprop.title".

- propertyName:

  property in marker.options(or feature.properties for vector layer)
  trough filter elements in layer,.

- formatData:

  callback for reformat all data from source to indexed data object.

- filterData:

  callback for filtering data from text searched, params: textSearch,
  allRecords.

- filtersearch:

  Optional comma-separated string to prepend to the search text

- moveToLocation:

  whether to move to the found location

- zoom:

  zoom to this level when moving to location

- buildTip:

  function that return row tip html node(or html string), receive text
  tooltip in first param.

- container:

  container id to insert Search Control

- minLength:

  minimal text length for autocomplete

- initial:

  search elements only by initial text

- casesensitive:

  search elements in case sensitive text

- autoType:

  complete input with first suggested result and select this filled-in
  text

- delayType:

  delay while typing for show tooltip.

- tooltipLimit:

  limit max results to show in tooltip. -1 for no limit

- tipAutoSubmit:

  auto map panTo when click on tooltip

- firstTipSubmit:

  auto select first result con enter click

- autoResize:

  autoresize on input change

- collapsed:

  collapse search control at startup

- autoCollapse:

  collapse search control after submit(on button or on tips if enabled
  tipAutoSubmit).

- autoCollapseTime:

  delay for autoclosing alert and collapse after blur.

- textErr:

  Error message

- textCancel:

  title in cancel button

- textPlaceholder:

  placeholder value

- position:

  position of the search input. Default is "topleft".

- hideMarkerOnCollapse:

  remove circle and marker on search control collapsed.

- marker:

  Let's you set the icon. Can be an icon made by
  [`makeIcon`](https://rstudio.github.io/leaflet/reference/makeIcon.html)
  or
  [`makeAwesomeIcon`](https://rstudio.github.io/leaflet/reference/makeAwesomeIcon.html)

- openPopup:

  whether to open the popup associated with the feature when the feature
  is searched for

- ...:

  Other options to pass to `searchOptions()` function.
