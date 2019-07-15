library(leaflet.extras)

#' ### Draw features on a blank slate

#+ fig.width=10, fig.height=8
leaflet() %>%
  setView(0, 0, 2) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addDrawToolbar(
    targetGroup = "draw",
    editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))  %>%
  addLayersControl(overlayGroups = c("draw"), options =
                     layersControlOptions(collapsed = FALSE)) %>%
  addStyleEditor()

#' <br/><br/>
#' ### Add Circles and enable editing.
#' The `group` param of `add*` methods has to match the `targetGroup` param of `addDrawToolbar`.

cities <- read.csv(textConnection("
City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994
"))

#+ fig.width=10, fig.height=8
leaflet(cities) %>% addTiles() %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1,
             radius = ~sqrt(Pop) * 30, label = ~City, group = "cities") %>%
  addDrawToolbar(
    targetGroup = "cities",
    editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))  %>%
  addLayersControl(overlayGroups = c("cities"), options =
                     layersControlOptions(collapsed = FALSE)) %>%
  addStyleEditor()

#' <br/><br/>
#' ### Add polygons and enable editing.
#' The `group` param of `add*` methods has to match the `targetGroup` param of `addDrawToolbar`.

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
  addStyleEditor()


#' <br/><br/><br/>
#' ### Add GeoJSON and then edit it
#' The layerId of the GeoJSON has to match the targetLayerId of `addDrawToolbar`. Also notice that we have to simplify the geometry quite a bit using `rmapshaper::ms_simplify`, otherwise the edit feature is very slow and will even hang the browser.

fName <- "https://rawgit.com/benbalter/dc-maps/master/maps/ward-2012.geojson"

geoJson <- readr::read_file(fName)
geoJson2 <- rmapshaper::ms_simplify(geoJson, keep = 0.01)

#+ fig.width=10, fig.height=8
leaflet() %>% addTiles() %>% setView(-77.0369, 38.9072, 12) %>%
  addGeoJSONv2(geoJson2,
    group = "wards", layerId = "dc-wards") %>%
  addDrawToolbar(
    targetLayerId = "dc-wards",
    editOptions = editToolbarOptions(
      selectedPathOptions = selectedPathOptions()))  %>%
  addLayersControl(overlayGroups = c("wards"),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addStyleEditor()
