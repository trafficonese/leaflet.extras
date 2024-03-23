library(sf)

## Data ##################
cities_df_all <- data.frame(
  city = c("Hammerfest", "Calgary", "Los Angeles", "Santiago", "Cape Town", "Tokio", "Barrow"),
  lat = c(70.67, 51.05, 34.05, -33.44, -33.91, 35.69, 71.29),
  lng = c(23.68, -114.08, -118.24, -70.71, 18.41, 139.69, -156.76)
)
cities_df_all$radius <- runif(nrow(cities_df_all), 4000, 900000)
cities_df_all$weight <- runif(nrow(cities_df_all), 1, 20)
cities_df_all$opacity <- runif(nrow(cities_df_all), 0.1, 1)
cities_df_all$steps <- runif(nrow(cities_df_all), 5, 400)
cities_df_all$color <- sample(c("green", "red", "blue", "orange", "black"), nrow(cities_df_all), replace = TRUE)
# cities_df_all <- list(cities_df_all[1:4,],cities_df_all[5:7,])
cities_df <- cities_df_all[1:4, ]


berlin <- c(52.51, 13.4)
losangeles <- c(34.05, -118.24)
santiago <- c(-33.44, -70.71)
df <- as.data.frame(rbind(berlin, losangeles, santiago))
names(df) <- c("lat", "lng")

sflines <- sf::st_read(system.file("examples/data/geodesic_lines.shp", package = "leaflet.extras"))
sflines$id <- 1:nrow(sflines)
sflines$color <- sample(c("green", "red", "orange", "black"), nrow(sflines), replace = TRUE)
sflines$icon <- c("red", "green")

mycustomicon <- makeIcon(
  iconUrl = system.file("examples/shiny/marker.png",
    package = "leaflet.extras"
  ),
  iconWidth = 30
)
mycustomicon_size <- list(
  iconUrl = system.file("examples/shiny/marker.png",
    package = "leaflet.extras"
  ),
  iconSize = c(30, 50)
)
greenLeafIcon <- makeIcon(
  iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)
iconlist <- leaflet::iconList(
  green = makeIcon(
    iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
    iconWidth = 38, iconHeight = 95, iconAnchorX = 22, iconAnchorY = 94
  ),
  red = makeIcon(
    iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-red.png",
    iconWidth = 38, iconHeight = 95, iconAnchorX = 22, iconAnchorY = 94
  )
)
simpleawesome <- makeAwesomeIcon(icon = "glass", library = "fa", markerColor = "green")
awesomeicons <- awesomeIconList(
  green = makeAwesomeIcon(icon = "glass", library = "fa", markerColor = "green"),
  red = makeAwesomeIcon(icon = "cutlery", library = "fa", markerColor = "red", squareMarker = TRUE, iconRotate = 10)
)
awesomeicons_glyph <- awesomeIconList(
  green = makeAwesomeIcon(icon = "glass", library = "glyphicon", markerColor = "green"),
  red = makeAwesomeIcon(icon = "cutlery", library = "glyphicon", markerColor = "red", squareMarker = TRUE, iconRotate = 10)
)
awesomeicons_ion <- awesomeIconList(
  green = makeAwesomeIcon(icon = "home", library = "ion", markerColor = "green"),
  red = makeAwesomeIcon(icon = "planet", library = "ion", markerColor = "red", squareMarker = TRUE, iconRotate = 10)
)

## Tests #################
test_that("Geodesic", {
  ## Lines ###################
  ts <- leaflet(cities_df) %>%
    addGeodesicPolylines(lng = ~lng, lat = ~lat)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2, 3, 5:12)]))
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$interactive == TRUE)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$className == "")
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$steps == 10)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$wrap == TRUE)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$stroke == TRUE)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$color == "#03F")
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$weight == 5)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$opacity == 0.5)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$dashArray)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$smoothFactor == 1)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$noClip == FALSE)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$showStats == FALSE)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$statsFunction)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$showMarker == FALSE)

  ts <- leaflet() %>%
    addLatLng(lng = 100, lat = 40, layerId = "someid")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addLatLng")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], 40)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], 100)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "someid")


  ts <- leaflet(df) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addGeodesicPolylines(
      lng = ~lng, lat = ~lat,
      weight = 2, steps = 50,
      opacity = 1, wrap = FALSE,
      dashArray = c(10, 30),
      color = "green", popup = "some popup", group = "mygroup",
      label = "somelabel"
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2, 5, 7, 9:12)]))
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$steps == 50)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$wrap == FALSE)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$color == "green")
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$weight == 2)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$opacity == 1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$dashArray, c(10, 30))
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$smoothFactor == 1)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$noClip == FALSE)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$showStats == FALSE)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$statsFunction)
  expect_true(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$showMarker == FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[6]], "some popup")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[8]], "somelabel")
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[1]][[1]][[1]][[1]],
    data.frame(lng = df$lng, lat = df$lat)
  )


  ts <- leaflet(df) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addGeodesicPolylines(
      lng = ~lng, lat = ~lat,
      icon = greenLeafIcon
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2, 3, 7, 9:12)]))
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[5]]$iconUrl$data,
    "https://leafletjs.com/examples/custom-icons/leaf-green.png"
  )

  ts <- leaflet(df) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addGeodesicPolylines(
      lng = ~lng, lat = ~lat,
      icon = mycustomicon
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2, 3, 7, 9:12)]))
  expect_type(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$iconUrl$data, "character")

  ts <- leaflet(df) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addGeodesicPolylines(
      lng = ~lng, lat = ~lat,
      icon = mycustomicon_size
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2, 3, 7, 9:12)]))
  expect_type(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$iconUrl$data, "character")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$iconSize[[1]], c(30, 50))





  ts <- leaflet(cities_df) %>%
    # addMeasure(primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters") %>%
    # addPolylines(data = sf::st_cast(sflines, "LINESTRING"), color="blue", opacity = 1) %>%
    addGeodesicPolylines(
      data = sflines, layerId = ~ paste0("ID_", id),
      weight = 7, color = ~color, showStats = TRUE,
      markerOptions = markerOptions(draggable = TRUE, title = "some special Title"),
      statsFunction = JS("function(stats) {
                                           return('<h4>Custom Stats Info</h4>' +
                                              '<div>Distance:  ' + stats.totalDistance + '</div>')
                                         }"),
      icon = ~ iconlist[icon],
      # icon = iconlist,
      # icon = ~awesomeicons[icon],
      label = ~ paste0(id), labelOptions = labelOptions(textsize = "22px"),
      popup = ~ paste0("<h4>", id, "</h4>
                   <div>color = ", color, "</div>
                   <div>icon = ", icon, "</div>
                   <div>X_lflt_d = ", X_lflt_d, "</div>
                   ")
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(3, 7, 10, 12)]))
  expect_identical(length(ts$x$calls[[length(ts$x$calls)]]$args[[1]]), 2L)
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[5]]$iconUrl,
    c(
      "https://leafletjs.com/examples/custom-icons/leaf-red.png",
      "https://leafletjs.com/examples/custom-icons/leaf-green.png"
    )
  )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$statsFunction, JS("function(stats) {
                                           return('<h4>Custom Stats Info</h4>' +
                                              '<div>Distance:  ' + stats.totalDistance + '</div>')
                                         }"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[8]], as.character(sflines$id))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], paste0("ID_", sflines$id))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[9]], labelOptions(textsize = "22px"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], markerOptions(draggable = TRUE, title = "some special Title"))



  ## Lines with Awesome Icons ###################
  ts <- leaflet(cities_df) %>%
    # addAwesomeMarkers(data = sf::st_cast(sflines, "POINT"), icon = ~awesomeicons[icon]) %>%
    addGeodesicPolylines(
      data = sflines, layerId = ~ paste0("ID_", id),
      weight = 7, color = ~color, showStats = TRUE,
      markerOptions = markerOptions(draggable = TRUE, title = "some special Title"),
      statsFunction = JS("function(stats) {
                                           return('<h4>Custom Stats Info</h4>' +
                                              '<div>Distance:  ' + stats.totalDistance + '</div>')
                                         }"),
      icon = ~ awesomeicons[icon],
      label = ~ paste0(id), labelOptions = labelOptions(textsize = "22px"),
      popup = ~ paste0("<h4>", id, "</h4>
                   <div>color = ", color, "</div>
                   <div>icon = ", icon, "</div>
                   <div>X_lflt_d = ", X_lflt_d, "</div>
                   ")
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "fontawesome")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(3, 7, 10, 12)]))
  expect_identical(length(ts$x$calls[[length(ts$x$calls)]]$args[[1]]), 2L)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$icon, c("cutlery", "glass"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$library, c("fa"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$markerColor, c("red", "green"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$squareMarker, c(T, F))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$statsFunction, JS("function(stats) {
                                           return('<h4>Custom Stats Info</h4>' +
                                              '<div>Distance:  ' + stats.totalDistance + '</div>')
                                         }"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[8]], as.character(sflines$id))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], paste0("ID_", sflines$id))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[9]], labelOptions(textsize = "22px"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], markerOptions(draggable = TRUE, title = "some special Title"))

  ts <- leaflet(cities_df) %>%
    # addAwesomeMarkers(data = sf::st_cast(sflines, "POINT"), icon = ~awesomeicons[icon]) %>%
    addGeodesicPolylines(
      data = sflines, layerId = ~ paste0("ID_", id),
      weight = 7, color = ~color, showStats = TRUE,
      markerOptions = markerOptions(draggable = TRUE, title = "some special Title"),
      statsFunction = JS("function(stats) {
                                           return('<h4>Custom Stats Info</h4>' +
                                              '<div>Distance:  ' + stats.totalDistance + '</div>')
                                         }"),
      icon = simpleawesome,
      label = ~ paste0(id), labelOptions = labelOptions(textsize = "22px"),
      popup = ~ paste0("<h4>", id, "</h4>
                   <div>color = ", color, "</div>
                   <div>icon = ", icon, "</div>
                   <div>X_lflt_d = ", X_lflt_d, "</div>
                   ")
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "fontawesome")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(3, 7, 10, 12)]))
  expect_identical(length(ts$x$calls[[length(ts$x$calls)]]$args[[1]]), 2L)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$icon, c("glass"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$library, c("fa"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$markerColor, c("green"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$squareMarker, FALSE)

  ts <- leaflet(cities_df) %>%
    # addAwesomeMarkers(data = sf::st_cast(sflines, "POINT"), icon = ~awesomeicons[icon]) %>%
    addGeodesicPolylines(
      data = sflines, layerId = ~ paste0("ID_", id),
      weight = 7, color = ~color, showStats = TRUE,
      markerOptions = markerOptions(draggable = TRUE, title = "some special Title"),
      statsFunction = JS("function(stats) {
                                           return('<h4>Custom Stats Info</h4>' +
                                              '<div>Distance:  ' + stats.totalDistance + '</div>')
                                         }"),
      icon = ~ awesomeicons_glyph[icon],
      label = ~ paste0(id), labelOptions = labelOptions(textsize = "22px"),
      popup = ~ paste0("<h4>", id, "</h4>
                   <div>color = ", color, "</div>
                   <div>icon = ", icon, "</div>
                   <div>X_lflt_d = ", X_lflt_d, "</div>
                   ")
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "bootstrap")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(3, 7, 10, 12)]))
  expect_identical(length(ts$x$calls[[length(ts$x$calls)]]$args[[1]]), 2L)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$icon, c("cutlery", "glass"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$library, c("glyphicon"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$markerColor, c("red", "green"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$squareMarker, c(T, F))


  ts <- leaflet(cities_df) %>%
    # addAwesomeMarkers(data = sf::st_cast(sflines, "POINT"), icon = ~awesomeicons[icon]) %>%
    addGeodesicPolylines(
      data = sflines, layerId = ~ paste0("ID_", id),
      weight = 7, color = ~color, showStats = TRUE,
      markerOptions = markerOptions(draggable = TRUE, title = "some special Title"),
      statsFunction = JS("function(stats) {
                                           return('<h4>Custom Stats Info</h4>' +
                                              '<div>Distance:  ' + stats.totalDistance + '</div>')
                                         }"),
      icon = ~ awesomeicons_ion[icon],
      label = ~ paste0(id), labelOptions = labelOptions(textsize = "22px"),
      popup = ~ paste0("<h4>", id, "</h4>
                   <div>color = ", color, "</div>
                   <div>icon = ", icon, "</div>
                   <div>X_lflt_d = ", X_lflt_d, "</div>
                   ")
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "ionicons")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(3, 7, 10, 12)]))
  expect_identical(length(ts$x$calls[[length(ts$x$calls)]]$args[[1]]), 2L)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$icon, c("planet", "home"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$library, c("ion"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$markerColor, c("red", "green"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$squareMarker, c(T, F))

  ## Circles ###################
  ts <- leaflet(cities_df) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addMeasure(primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters") %>%
    addGreatCircles(lng_center = ~lng, lat_center = ~lat, radius = 100)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 100)
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 7:13)]))


  ts <- leaflet(cities_df) %>%
    addTiles() %>%
    addGreatCircles(
      lng_center = ~lng, lat_center = ~lat, radius = 1220000,
      icon = greenLeafIcon
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 1220000)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[7]]$iconUrl$data, greenLeafIcon$iconUrl)
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 8:13)]))


  ts <- leaflet(cities_df) %>%
    addTiles() %>%
    addGreatCircles(
      lng_center = ~lng, lat_center = ~lat, radius = 1220000,
      icon = iconlist
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 1220000)
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[7]]$iconUrl,
    as.character(unlist(lapply(iconlist, function(x) x$iconUrl)))
  )
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 8:13)]))


  ts <- leaflet(cities_df) %>%
    addTiles() %>%
    addGreatCircles(
      lng_center = ~lng, lat_center = ~lat, radius = 1220000,
      icon = mycustomicon
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 1220000)
  expect_type(ts$x$calls[[length(ts$x$calls)]]$args[[7]]$iconUrl$data, "character")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 8:13)]))


  ts <- leaflet(cities_df) %>%
    addTiles() %>%
    addGreatCircles(
      lng_center = ~lng, lat_center = ~lat, radius = 1220000,
      icon = mycustomicon_size
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 1220000)
  expect_type(ts$x$calls[[length(ts$x$calls)]]$args[[7]]$iconUrl$data, "character")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[7]]$iconSize[[1]], c(30, 50))
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 8:13)]))


  ts <- leaflet(cities_df) %>%
    addTiles() %>%
    addGreatCircles(
      lng_center = ~lng, lat_center = ~lat, radius = 500,
      icon = simpleawesome
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "fontawesome")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 500)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[7]], c(unclass(simpleawesome), awesomemarker = TRUE))
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 8:13)]))

  ts <- leaflet(cities_df) %>%
    addTiles() %>%
    addGreatCircles(
      lng_center = ~lng, lat_center = ~lat, radius = 500,
      icon = awesomeicons
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "fontawesome")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 500)
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[7]]$icon,
    as.character(unlist(lapply(awesomeicons, function(x) x$icon)))
  )
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[7]]$markerColor,
    as.character(unlist(lapply(awesomeicons, function(x) x$markerColor)))
  )
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 8:13)]))


  ts <- leaflet(cities_df) %>%
    addTiles() %>%
    addGreatCircles(
      lng_center = ~lng, lat_center = ~lat, radius = 500,
      icon = awesomeicons_glyph
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "bootstrap")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 500)
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[7]]$icon,
    as.character(unlist(lapply(awesomeicons_glyph, function(x) x$icon)))
  )
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[7]]$markerColor,
    as.character(unlist(lapply(awesomeicons_glyph, function(x) x$markerColor)))
  )
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 8:13)]))


  ts <- leaflet(cities_df) %>%
    addTiles() %>%
    addGreatCircles(
      lng_center = ~lng, lat_center = ~lat, radius = 500,
      icon = awesomeicons_ion
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "ionicons")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities_df$lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities_df$lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], 500)
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[7]]$icon,
    as.character(unlist(lapply(awesomeicons_ion, function(x) x$icon)))
  )
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[7]]$markerColor,
    as.character(unlist(lapply(awesomeicons_ion, function(x) x$markerColor)))
  )
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4, 5, 8:13)]))
})
