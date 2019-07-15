#' ---
#' title: "Geodesic Lines in Leaflet"
#' output:
#'   html_document:
#'     self_contained: true
#' ---
berlin <- c(52.51, 13.4)
losangeles <- c(34.05, -118.24)
santiago <- c(-33.44, -70.71)
tokio <- c(35.69, 139.69)
sydney <- c(-33.91, 151.08)
capetown <- c(-33.91, 18.41)
calgary <- c(51.05, -114.08)
hammerfest <- c(70.67, 23.68)
barrow <- c(71.29, -156.76)

df <- as.data.frame(rbind(hammerfest, calgary, losangeles, santiago, capetown, tokio, barrow))
names(df) <- c("lat", "lng")

library(leaflet.extras)
library(sp)

#' #### Example 1

leaflet(df) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addGeodesicPolylines(lng = ~lng, lat = ~lat, weight = 2, color = "red",
                       steps = 50, opacity = 1) %>%
  addCircleMarkers(df, lat = ~lat, lng = ~lng, radius = 3, stroke = FALSE, fillColor = "black", fillOpacity = 1)

#' ### Example 2

library(bsam)
library(trip)

data(ellie)
tr <- ellie
coordinates(tr) <- c("lon", "lat")
proj4string(tr) <- CRS("+init=epsg:4326")
tr <- trip(tr, c("date", "id"))
colshorten <- function(x) lapply(strsplit(x, ""), function(a) paste(a[c(1, 2, 4, 6)], collapse = ""))

trcol <- colshorten(viridis::viridis(length(unique(tr$id))))


pts <- structure(list(x = c(71, 114.3, 96.4, 70.3, 51.4, 31.7, 38.2,
                            66.7), y = c(-49.1, -64.9, -63.6, -50.1, -65.8, -68.2, -64.8,
                                         -48.2)), .Names = c("x", "y"))

leaflet() %>% addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addPolylines(data = as(tr, "SpatialLinesDataFrame"), color = trcol) %>%
  addGeodesicPolylines(lng = pts$x, lat = pts$y, weight = 2, color = c("black")) %>%
  addCircles(pts$x, pts$y, color = "black")

#' <br/><br/>Same thing as above in a polar projection.<br/>

resolutions <- c(16384, 8192, 4096, 2048, 1024, 512, 256)
zoom <- 0
maxZoom <- 7

border <- geojsonio::geojson_read(
  system.file("examples/Seamask_medium_res_polygon.kml",
              package = "leaflet"), what = "sp")
crsAntartica <-  leafletCRS(
  crsClass = "L.Proj.CRS",
  code = "EPSG:3031",
  proj4def = "+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs",
  resolutions = resolutions,
  origin = c(-4194304, 4194304),
  bounds =  list( c(-4194304, -4194304), c(4194304, 4194304) )
)

leaflet(options = leafletOptions(
  crs = crsAntartica, minZoom = zoom, maxZoom = maxZoom, worldCopyJump = FALSE)) %>%
  setView(0, -90, 0) %>%
  addPolygons(data = border, color = "#ff0000", weight = 2, fill = FALSE) %>%
  addPolylines(data = as(tr, "SpatialLinesDataFrame"), color = trcol, opacity = 0.5) %>%
  addGeodesicPolylines(lng = pts$x, lat = pts$y,
                       weight = 2, color = c("black"), opacity = 0.6) %>%
  addCircles(pts$x, pts$y, color = "black") %>%
  addGraticule(style = list(color = "#999", weight = 0.5, opacity = 0.4))

#' ### Great Circle
leaflet(df) %>% addProviderTiles(providers$CartoDB.Positron) %>%
  addGreatCircles(radius = 2000000, steps = 100, group = "circle")  %>%
  setView(0, 35, 1) %>%
  addLayersControl(overlayGroups = c("circle"))
