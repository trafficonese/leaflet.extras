library(leaflet.extras)


#' ### Add shapes with measurements enabled

fName <- "https://rawgit.com/benbalter/dc-maps/master/maps/ward-2012.geojson"

geoJson <- readr::read_file(fName)

leaflet() %>% addTiles() %>% setView(-77.0369, 38.9072, 11) %>%
  addBootstrapDependency() %>%
  enableMeasurePath() %>%
  addGeoJSONChoropleth(
    geoJson,
    valueProperty = "AREASQMI",
    scale = c("white", "red"), mode = "q", steps = 4, padding = c(0.2, 0),
    labelProperty = "NAME",
    popupProperty = propstoHTMLTable(
      props = c("NAME", "AREASQMI", "REP_NAME", "WEB_URL", "REP_PHONE", "REP_EMAIL", "REP_OFFICE"),
      table.attrs = list(class = "table table-striped table-bordered"), drop.na = T),
    color = "#ffffff", weight = 1, fillOpacity = 0.7,
    highlightOptions = highlightOptions(
      weight = 2, color = "#000000",
      fillOpacity = 1, opacity = 1,
      bringToFront = TRUE, sendToBack = TRUE),
    pathOptions = pathOptions(
      showMeasurements = TRUE,
      measurementOptions = measurePathOptions(imperial = TRUE)))


#' ### Dynamically show/hide measurements

leaflet() %>% addTiles() %>% setView(-77.0369, 38.9072, 11) %>%
  addBootstrapDependency() %>%
  addGeoJSONChoropleth(
    geoJson,
    valueProperty = "AREASQMI",
    scale = c("white", "red"), mode = "q", steps = 4, padding = c(0.2, 0),
    labelProperty = "NAME",
    popupProperty = propstoHTMLTable(
      props = c("NAME", "AREASQMI", "REP_NAME", "WEB_URL", "REP_PHONE", "REP_EMAIL", "REP_OFFICE"),
      table.attrs = list(class = "table table-striped table-bordered"), drop.na = T),
    color = "#ffffff", weight = 1, fillOpacity = 0.7,
    highlightOptions = highlightOptions(
      weight = 2, color = "#000000",
      fillOpacity = 1, opacity = 1,
      bringToFront = TRUE, sendToBack = TRUE)) %>%
  addMeasurePathToolbar(options = measurePathOptions(imperial = TRUE, showDistances = FALSE))

#' ### With Draw
#' You can update the measurements after editing by clicking on the refresh button of the measure path toolbar.
library(rbgm)
set.seed(2)
## pick one of the available model files
fs <- sample(bgmfiles::bgmfiles(), 1)

## read the model, and convert to Spatial (box for polygons, face for boundary lines)
model <- boxSpatial(bgmfile(fs))
## most of the BGM models will be in a local map projection
model <- spTransform(model, "+init=epsg:4326")

#+ fig.width=10, fig.height=8
leaflet() %>% addTiles() %>%
  addPolygons(data = model, group = "model") %>%
  addDrawToolbar(targetGroup = "model",
    editOptions = editToolbarOptions(
      selectedPathOptions = selectedPathOptions())) %>%
  addLayersControl(overlayGroups = c("model"), options =
                     layersControlOptions(collapsed = FALSE)) %>%
  addMeasurePathToolbar(options =
                          measurePathOptions(imperial = TRUE,
                                             minPixelDistance = 100,
                                             showDistances = FALSE))
