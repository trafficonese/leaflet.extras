library(leaflet.extras)
library(magrittr)

#' Just by number of quakes
#'
#'
leaflet(quakes) %>% addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addWebGLHeatmap(lng = ~long, lat = ~lat, size = 60000)


#' <br/><br/>By magnitude
#'
#'
leaflet(quakes) %>% addProviderTiles(providers$CartoDB.DarkMatter) %>%
  addWebGLHeatmap(lng = ~long, lat = ~lat, intensity = ~mag, size = 60000)

#' <br/><br/>
#' Roughly 1500 points dataset
#'
library(sp)
jsURL <- "https://rawgit.com/Norkart/Leaflet-MiniMap/master/example/local_pubs_restaurant_norway.js"
v8 <- V8::v8()
v8$source(jsURL)
geoJson <- geojsonio::as.json(v8$get("pubsGeoJSON"))
spdf <- geojsonio::geojson_sp(geoJson)

#' <br/><br/>Size in meters
#'
#'
leaflet(spdf) %>%
  addProviderTiles(providers$Thunderforest.TransportDark) %>%
  addWebGLHeatmap(size = 60000)

#' <br/><br/>Size in Pixels
#'
#'
leaflet(spdf) %>%
  addProviderTiles(providers$Thunderforest.TransportDark) %>%
  addWebGLHeatmap(size = 25, units = "px")

#' <br/><br/>10,000 points
#'
#'
jsURL <- "http://leaflet.github.io/Leaflet.markercluster/example/realworld.10000.js"
v8 <- V8::v8()
v8$source(jsURL)

df <- data.frame(v8$get("addressPoints"), stringsAsFactors = F) %>%
  set_colnames(c("lat", "lng", "intensity")) %>%
  dplyr::mutate(
    lat = as.numeric(lat),
    lng = as.numeric(lng)
  )

#' <br/><br/>Size in Meters
#'
#'
leaflet(df) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addWebGLHeatmap(lng = ~lng, lat = ~lat, size = 1000)

#' <br/><br/>Size in Pixels
#'
#'
leaflet(df) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addWebGLHeatmap(lng = ~lng, lat = ~lat, size = 20, units = "px")

#' <br/><br/>

london_crimes_files <- Sys.glob(
  paste0(system.file("examples/data/London-Crimes", package = "leaflet.extras"),
         "/*/*-city-of-london-street.csv.zip"))
london_crimes <- suppressMessages(
  purrr::map(
    london_crimes_files,
    ~readr::read_csv(.) %>%
      dplyr::select(Latitude, Longitude) %>%
      dplyr::filter(!is.na(Latitude))) %>%
  set_names(basename(Sys.glob(
    paste0(system.file("examples/data/London-Crimes", package = "leaflet.extras"),
           "/2016*")))))

leaf <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron)

purrr::walk(
  names(london_crimes),
  function(month) {
    leaf <<- leaf %>%
      addWebGLHeatmap(
        data = london_crimes[[month]],
        layerId = month, group = month,
        lng = ~Longitude, lat = ~Latitude, size = 40, units = "px",
        gradientTexture = "skyline"
        )
  })

leaf %>%
  setView(-0.094106, 51.515, 14) %>%
  addLayersControl(
    baseGroups = names(london_crimes),
    options = layersControlOptions(collapsed = FALSE)
  )
