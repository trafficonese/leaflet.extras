#' test_that("geojsonv2 examples", {
#'   testthat::skip()
#'   testthat::skip_on_ci()
#'   testthat::skip_on_cran()
#'   testthat::skip_if_not_installed("readr")
#'   testthat::skip_if_not_installed("dplyr")
#'   testthat::skip_if_not_installed("purrr")
#'   testthat::skip_if_not_installed("colormap")
#'   testthat::skip_if_not_installed("rmapshaper")
#'   testthat::skip_if_not_installed("V8")
#'   testthat::skip_if_not_installed("geojsonio")
#'   testthat::skip_if_not_installed("htmlTable")
#'
#'
#'   leaf <- leaflet() %>%
#'     addProviderTiles(providers$CartoDB.Positron)
#'
#'   # Read as a R list
#'   fName <- "https://rawgit.com/benbalter/dc-maps/master/maps/ward-2012.geojson"
#'   geoJson <- jsonlite::fromJSON(readr::read_file(fName))
#'
#'   factpal <- colorFactor(
#'     topo.colors(nrow(geoJson$features$properties)),
#'     geoJson$features$properties$NAME
#'   )
#'
#'   # Generate one HTML Table per feature with all properties of a feature.
#'   geoJson$features$properties <-
#'     dplyr::rowwise(geoJson$features$properties) %>%
#'     dplyr::do({
#'       result <- dplyr::as_tibble(.)
#'       result$popup <- purrr::map_chr(
#'         htmlTable::htmlTable(
#'           t(result),
#'           caption = "Ward Details",
#'           align = "left",
#'           align.header = "left",
#'           col.rgroup = c("#ffffff", "#eeeeee")
#'         ), ~ as.character(.)
#'       )
#'       result
#'     })
#'   geoJson$features$properties$style <- purrr::map(factpal(geoJson$features$properties$NAME), ~ list(fillColor = ., color = .))
#'
#'   ts <- leaf %>%
#'     setView(-77.0369, 38.9072, 11) %>%
#'     addGeoJSONv2(
#'       jsonlite::toJSON(geoJson),
#'       weight = 1, fillOpacity = 0.6,
#'       popupProperty = "popup", labelProperty = "NAME",
#'       highlightOptions = highlightOptions(
#'         weight = 2, color = "#000000",
#'         fillOpacity = 1, opacity = 1,
#'         bringToFront = TRUE, sendToBack = TRUE
#'       )
#'     )
#'   expect_s3_class(ts, "leaflet")
#'   expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
#'   expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
#'
#'   #' ### Examples 2.1 and 2.2
#'   #'
#'   #' Here we show two different approaches to styling polygons. In 2.1 we style the polygons similar to example 1 i.e. read data in R and do the styling in R. In example 2.2 we show an alternate way by using `addGeoJSONChoropleth` and doing the styling entirely in the browser. Example 2.2 shows how easy it is to customize and plot GeoJSON data.
#'   #'
#'   fName <- "https://raw.githubusercontent.com/MinnPost/simple-map-d3/master/example-data/world-population.geo.json"
#'
#'   geoJson <- jsonlite::fromJSON(readr::read_file(fName))
#'
#'   leaf.world <- leaflet(
#'     options = leafletOptions(
#'       maxZoom = 5,
#'       crs = leafletCRS(
#'         crsClass = "L.Proj.CRS", code = "ESRI:53009",
#'         proj4def = "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs",
#'         resolutions = c(65536, 32768, 16384, 8192, 4096, 2048)
#'       )
#'     )
#'   ) %>%
#'     addGraticule(style = list(color = "#999", weight = 0.5, opacity = 1, fill = NA)) %>%
#'     addGraticule(sphere = TRUE, style = list(color = "#777", weight = 1, opacity = 0.25, fill = NA)) %>%
#'     addEasyButton(easyButton(
#'       icon = "ion-arrow-shrink",
#'       title = "Reset View",
#'       onClick = JS("function(btn, map){ map.setView([0,0],0); }")
#'     )) %>%
#'     setMapWidgetStyle(list(background = "white"))
#'
#'   #' #### Example 2.1: Pre-processing in R
#'   #'
#'   #' Similar example to the example 1, but with a custom projection.
#'
#'
#'   geoJson$features$properties$POP_DENSITY <-
#'     as.numeric(geoJson$features$properties$POP2005) /
#'       max(as.numeric(geoJson$features$properties$AREA), 1)
#'
#'   pal <- colorNumeric(
#'     colormap::colormap(colormap::colormaps$copper, nshades = 256, reverse = TRUE),
#'     geoJson$features$properties$POP_DENSITY
#'   )
#'
#'   # Generate one HTML Table per feature with all properties of a feature.
#'   geoJson$features$properties <-
#'     dplyr::rowwise(geoJson$features$properties) %>%
#'     dplyr::do({
#'       result <- dplyr::as_data_frame(.)
#'       result$popup <- purrr::map_chr(
#'         htmlTable::htmlTable(
#'           t(result),
#'           caption = "Ward Details",
#'           align = "left",
#'           align.header = "left",
#'           col.rgroup = c("#ffffff", "#eeeeee")
#'         ), ~ as.character(.)
#'       )
#'       result
#'     })
#'
#'   geoJson$features$properties$style <- purrr::map(pal(geoJson$features$properties$POP_DENSITY), ~ list(fillColor = .))
#'
#'   ts <- leaf.world %>%
#'     addGeoJSONv2(
#'       rmapshaper::ms_simplify(geojsonio::as.json(geoJson)),
#'       weight = 1, fillOpacity = 0.8, color = "#ffffff",
#'       popupProperty = "popup", labelProperty = "NAME",
#'       highlightOptions = highlightOptions(
#'         weight = 2, color = "#000000",
#'         fillOpacity = 1, opacity = 1,
#'         bringToFront = TRUE, sendToBack = TRUE
#'       )
#'     )
#'   expect_s3_class(ts, "leaflet")
#'   expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
#'   expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
#'
#'   #' #### Example 2.2: Processing in the Browser
#'   #' This is the same data and same visualization as example 2.1, but here we use `addGeoJSONChoropleth` instead of `addGeoJSONv2`. This allows us to generate our polygon style on the fly in the browser, with no pre processing required on the R side.
#'
#'   # The geojson in question has some invalid geometry which needs to be fixed before we can use it in a custom projection.
#'   geoJson <- geojsonio::as.json(geoJson) %>%
#'     rmapshaper::ms_simplify()
#'
#'   #' The options `valueProperty`, `scale`, `mode`, `steps` are for the choropleth generation.
#'   #' `valueProperty` can be a simple property or a JS function that computes a value as shown below.<br/>
#'   #' In addition you can specify `labelProperty` & `popupProperty` both of which can be simple property names or functions that generate string/HTML.
#'
#'   ts <- leaf.world %>%
#'     addBootstrapDependency() %>%
#'     addGeoJSONChoropleth(
#'       geoJson,
#'       # Calculate the Population Density of each country
#'       valueProperty =
#'         JS("function(feature) {
#'            return feature.properties.POP2005/Math.max(feature.properties.AREA,1);
#'          }"),
#'       scale = c("#ffc77fff", "#000000ff"), mode = "q", steps = 5,
#'       # Select the data attributes to show in the popup.
#'       popupProperty = propstoHTMLTable(
#'         props = c("NAME", "REGION", "ISO_3_CODE", "ISO_2_CODE", "AREA", "POP2005"),
#'         table.attrs = list(class = "table table-striped table-bordered"), drop.na = T
#'       ),
#'       labelProperty = "NAME",
#'       color = "#ffffff", weight = 1, fillOpacity = 0.9,
#'       highlightOptions = highlightOptions(
#'         fillOpacity = 1, weight = 2, opacity = 1, color = "#ff0000",
#'         bringToFront = TRUE, sendToBack = TRUE
#'       ),
#'       legendOptions = legendOptions(title = "Pop. Density")
#'     )
#'   expect_s3_class(ts, "leaflet")
#'   expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-choropleth")
#'   expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONChoropleth")
#'
#'   #' ### Example 3: Processing in the Browser
#'   #'
#'   #' Here again we don't do any pre-processing in R, everything is done on the browser side.
#'
#'   fName <- "https://rawgit.com/benbalter/dc-maps/master/maps/ward-2012.geojson"
#'
#'   geoJson <- readr::read_file(fName)
#'
#'   ts <- leaf %>%
#'     setView(-77.0369, 38.9072, 11) %>%
#'     addBootstrapDependency() %>%
#'     addGeoJSONChoropleth(
#'       geoJson,
#'       valueProperty = "AREASQMI",
#'       scale = c("white", "red"), mode = "q", steps = 4, padding = c(0.2, 0),
#'       labelProperty = "NAME",
#'       popupProperty = propstoHTMLTable(
#'         props = c("NAME", "AREASQMI", "REP_NAME", "WEB_URL", "REP_PHONE", "REP_EMAIL", "REP_OFFICE"),
#'         table.attrs = list(class = "table table-striped table-bordered"), drop.na = T
#'       ),
#'       color = "#ffffff", weight = 1, fillOpacity = 0.7,
#'       highlightOptions = highlightOptions(
#'         weight = 2, color = "#000000",
#'         fillOpacity = 1, opacity = 1,
#'         bringToFront = TRUE, sendToBack = TRUE
#'       ),
#'       legendOptions = legendOptions(title = "Area in Sq. Miles"),
#'       group = "reds"
#'     ) %>%
#'     addGeoJSONChoropleth(
#'       geoJson,
#'       valueProperty = "AREASQMI",
#'       scale = c("yellow", "red", "black"), mode = "q", steps = 4,
#'       bezierInterpolate = TRUE,
#'       labelProperty = "NAME",
#'       popupProperty = propstoHTMLTable(
#'         props = c("NAME", "AREASQMI", "REP_NAME", "WEB_URL", "REP_PHONE", "REP_EMAIL", "REP_OFFICE"),
#'         table.attrs = list(class = "table table-striped table-bordered"), drop.na = T
#'       ),
#'       color = "#ffffff", weight = 1, fillOpacity = 0.7,
#'       highlightOptions = highlightOptions(
#'         weight = 2, color = "#000000",
#'         fillOpacity = 1, opacity = 1,
#'         bringToFront = TRUE, sendToBack = TRUE
#'       ),
#'       legendOptions = legendOptions(title = "Area in Sq. Miles"),
#'       group = "yellow-black"
#'     ) %>%
#'     addLayersControl(
#'       baseGroups = c("reds", "yellow-black"),
#'       options = layersControlOptions(collapsed = FALSE)
#'     )
#'   expect_s3_class(ts, "leaflet")
#'   expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-choropleth")
#'   expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$method, "addGeoJSONChoropleth")
#'   expect_identical(ts$x$calls[[length(ts$x$calls) - 2]]$method, "addGeoJSONChoropleth")
#'
#'   #' ## Plot Points
#'   #'
#'   #' ### Example 1
#'   #' Here we plot GeoJSON with Point data using customized markers
#'   jsURL <- "https://rawgit.com/Norkart/Leaflet-MiniMap/master/example/local_pubs_restaurant_norway.js"
#'   v8 <- V8::v8()
#'   v8$source(jsURL)
#'   geoJson <- v8$get("pubsGeoJSON")
#'
#'   # Is it a pub or a restaurant?
#'   icons <- awesomeIconList(
#'     pub = makeAwesomeIcon(icon = "glass", library = "fa", markerColor = "red"),
#'     restaurant = makeAwesomeIcon(icon = "cutlery", library = "fa", markerColor = "blue")
#'   )
#'
#'   ts <- leaf %>%
#'     setView(15, 65, 5) %>%
#'     addGeoJSONv2(
#'       jsonlite::toJSON(geoJson),
#'       labelProperty = "name",
#'       markerIcons = icons, markerIconProperty = "amenity",
#'       markerOptions = markerOptions(riseOnHover = TRUE, opacity = 0.75),
#'       clusterOptions = markerClusterOptions()
#'     )
#'   # ts
#'   expect_s3_class(ts, "leaflet")
#'   expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "fontawesome")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "leaflet-markercluster")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 3]]$name, "lfx-omnivore")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 4]]$name, "topojson")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 5]]$name, "togeojson")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 6]]$name, "csv2geojson")
#'   expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
#'
#'   #' ### Example 2
#'   #' Here we plot arts/cultural places and historic places in Washington DC. Notice that we are not loading the GeoJSONs in R, but directly downloading them and parsing them int the browser. We are also specifying popups content to be generated from the feature properties. We are also using marker clustering to cluster our points.
#'
#'   artsAndCultures <- "https://rawgit.com/benbalter/dc-maps/master/maps/arts-and-culture-organizations-as-501-c-3.geojson"
#'   historicLandmarks <- "https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson"
#'
#'   artsAndCulture <- makeAwesomeIcon(icon = "paintbrush", library = "ion", markerColor = "red", iconColor = "black")
#'   historicLandmark <- makeAwesomeIcon(icon = "flag", library = "ion", markerColor = "green", iconColor = "black")
#'
#'   ts <- leaf %>%
#'     setView(-77.0369, 38.9072, 12) %>%
#'     addBootstrapDependency() %>%
#'     addGeoJSONv2(
#'       artsAndCultures,
#'       labelProperty = "NAME",
#'       popupProperty = propstoHTMLTable(
#'         table.attrs = list(class = "table table-striped table-bordered"), drop.na = T
#'       ),
#'       labelOptions = labelOptions(textsize = "12px", direction = "auto"),
#'       markerIcons = artsAndCulture,
#'       markerOptions = markerOptions(riseOnHover = TRUE, opacity = 1),
#'       clusterOptions = markerClusterOptions(), group = "Arts/Culture"
#'     ) %>%
#'     addGeoJSONv2(
#'       historicLandmarks,
#'       labelProperty = "LABEL",
#'       popupProperty = propstoHTMLTable(
#'         table.attrs = list(class = "table table-striped table-bordered"), drop.na = T
#'       ),
#'       labelOptions = labelOptions(textsize = "12px", direction = "auto"),
#'       markerIcons = historicLandmark,
#'       markerOptions = markerOptions(riseOnHover = TRUE, opacity = 1),
#'       clusterOptions = markerClusterOptions(), group = "Historic Landmarks"
#'     ) %>%
#'     addLayersControl(
#'       overlayGroups = c("Arts/Culture", "Historic Landmarks"),
#'       options = layersControlOptions(collapsed = F)
#'     )
#'   expect_s3_class(ts, "leaflet")
#'   expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "ionicons")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "leaflet-markercluster")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 3]]$name, "lfx-omnivore")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 4]]$name, "topojson")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 5]]$name, "togeojson")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 6]]$name, "csv2geojson")
#'   expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$method, "addGeoJSONv2")
#'   expect_identical(ts$x$calls[[length(ts$x$calls) - 2]]$method, "addGeoJSONv2")
#'
#'   #' ### Example 3
#'   #'
#'   #' This time in addition to the points we also plot the heatmap
#'   fName <- "https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson"
#'
#'   geoJson <- readr::read_file(fName)
#'
#'   ts <- leaflet() %>%
#'     setView(-77.0369, 38.9072, 12) %>%
#'     addProviderTiles(providers$CartoDB.Positron) %>%
#'     addWebGLGeoJSONHeatmap(
#'       geoJson,
#'       size = 30, units = "px"
#'     ) %>%
#'     addGeoJSONv2(
#'       geoJson,
#'       markerType = "circleMarker",
#'       stroke = FALSE, fillColor = "black", fillOpacity = 0.7,
#'       markerOptions = markerOptions(radius = 2)
#'     )
#'   expect_s3_class(ts, "leaflet")
#'   expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "topojson")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "togeojson")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 3]]$name, "csv2geojson")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 4]]$name, "lfx-webgl-heatmap")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 5]]$name, "lfx-omnivore")
#'   expect_identical(ts$dependencies[[length(ts$dependencies) - 6]]$name, "topojson")
#'   expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
#'   expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$method, "addWebGLGeoJSONHeatmap")
#' })
