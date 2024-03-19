## Data ##############
lng <- 49
lat <- 11
cities <- read.csv(textConnection("City,Lat,Long,Pop
Boston,42.3601,-71.0589,645966
Hartford,41.7627,-72.6743,125017
New York City,40.7127,-74.0059,8406000
Philadelphia,39.9500,-75.1667,1553000
Pittsburgh,40.4397,-79.9764,305841
Providence,41.8236,-71.4222,177994"))
cities$PopCat <- ifelse(cities$Pop < 500000, "blue", "red")

ICONURL <- "http://leafletjs.com/examples/custom-icons/leaf-green.png"
SHADOWURL <- "http://leafletjs.com/examples/custom-icons/leaf-shadow.png"
greenLeafIcon <- makeIcon(
  iconUrl = ICONURL,
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = SHADOWURL,
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

myIconSet <- iconList(
  greencol  = makeIcon(iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png"),
  redcol    = makeIcon(iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-red.png"),
  orangecol = makeIcon(iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-orange.png")
)
myIconSetDiffSize <- iconList(
  greencol = makeIcon(
    iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
    iconWidth = 20, iconHeight = 35
  ),
  redcol = makeIcon(
    iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-red.png",
    iconWidth = 40
  ),
  orangecol = makeIcon(
    iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-orange.png",
    iconWidth = 30, iconHeight = 50
  )
)
mycustomicon <- makeIcon(
  iconUrl = system.file("examples/shiny/marker.png",
    package = "leaflet.extras"
  ),
  iconWidth = 30
)


## Tests ###############
test_that("markers", {
  ## Bouncing Markers #########################
  ts <- leaflet() %>%
    addBounceMarkers(lng = lng, lat = lat)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-bouncemarker")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBounceMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], lng)

  ts <- leaflet() %>%
    addTiles() %>%
    addBounceMarkers(lng = lng, lat = lat, icon = greenLeafIcon)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBounceMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$iconUrl$data, ICONURL)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$shadowUrl$data, SHADOWURL)

  ts <- leaflet() %>%
    addTiles() %>%
    addBounceMarkers(lng = lng, lat = lat, icon = mycustomicon)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBounceMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], lng)
  expect_type(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$iconUrl$data, "character")

  ts <- leaflet() %>%
    addTiles() %>%
    addBounceMarkers(lng = lng, lat = lat, icon = list(
      iconUrl = ICONURL, iconSize = c(10, 40)
    ))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBounceMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$iconUrl$data, ICONURL)


  ts <- leaflet(cities) %>%
    addTiles() %>%
    addBounceMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBounceMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[13]], cities$City)

  cities$color <- sample(c("greencol", "redcol", "orangecol"), nrow(cities), replace = TRUE)
  ts <- leaflet(cities) %>%
    addTiles() %>%
    addBounceMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~ paste0(City, " - ", color),
      icon = ~ myIconSet[color]
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBounceMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[13]], paste0(cities$City, " - ", cities$color))

  ts <- leaflet(cities) %>%
    addTiles() %>%
    addBounceMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~ paste0(City, " - ", color),
      icon = ~ myIconSetDiffSize[color]
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBounceMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[13]], paste0(cities$City, " - ", cities$color))

  ## Weather Markers #########################
  iconSet <- weatherIconList(
    hurricane = makeWeatherIcon(icon = "hurricane"),
    tornado = makeWeatherIcon(icon = "tornado")
  )
  expect_s3_class(iconSet[as.factor("hurricane")], "leaflet_weather_icon_set")
  expect_s3_class(iconSet[as.factor("tornado")], "leaflet_weather_icon_set")
  expect_s3_class(iconSet["hurricane"], "leaflet_weather_icon_set")
  expect_s3_class(iconSet["tornado"], "leaflet_weather_icon_set")
  expect_s3_class(iconSet[1], "leaflet_weather_icon_set")
  expect_s3_class(iconSet[2], "leaflet_weather_icon_set")
  expect_error(iconSet[list(1, 2)], "Invalid subscript type")
  expect_error(weatherIconList("asd"))
  expect_error(weatherIconList(list(makeWeatherIcon(icon = "hurricane"))))
  expect_s3_class(iconSet, "leaflet_weather_icon_set")
  expect_length(iconSet, 2)
  expect_s3_class(iconSet[[1]], "leaflet_weather_icon")
  expect_s3_class(iconSet[[2]], "leaflet_weather_icon")
  expect_identical(iconSet[1]$hurricane$icon, "hurricane")
  expect_identical(iconSet[2]$tornado$icon, "tornado")

  tsi <- weatherIcons(icon = "sunny")
  expect_type(tsi, "list")
  expect_error(weatherIcons(icon = "sunny", markerColor = "transparent"))
  expect_error(weatherIcons(icon = "sunny", markerColor = "purple12"))

  lng <- -118.456554
  lat <- 34.078039
  ALABEL <- "This is a label"
  ts <- leaflet() %>%
    addTiles() %>%
    addWeatherMarkers(
      lng = lng, lat = lat, label = ALABEL,
      icon = makeWeatherIcon(
        icon = "hot",
        iconColor = "#ffffff77",
        markerColor = "blue"
      )
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-weather-markers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWeatherMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], ALABEL)


  ts <- leaflet(cities) %>%
    addTiles() %>%
    addWeatherMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      icon = makeWeatherIcon(
        icon = "hot",
        iconColor = "#ffffff77",
        markerColor = "blue"
      )
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWeatherMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], cities$City)

  expect_error(makeWeatherIcon(
    icon = "day-sunny",
    markerColor = "yellow"
  ))
  iconSet <- weatherIconList(
    sunny = makeWeatherIcon(
      icon = "day-sunny",
      markerColor = "orange"
    ),
    rain = makeWeatherIcon(
      icon = "rain",
      markerColor = "blue"
    ),
    wind = makeWeatherIcon(
      icon = "wind",
      markerColor = "lightblue"
    ),
    cloudy = makeWeatherIcon(
      icon = "cloudy",
      markerColor = "gray"
    )
  )
  cities$weather <- sample(c("sunny", "rain", "wind", "cloudy"), nrow(cities), replace = TRUE)
  ts <- leaflet(cities) %>%
    addTiles() %>%
    addWeatherMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~ paste0(City, " - ", weather),
      icon = ~ iconSet[weather]
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWeatherMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], paste0(cities$City, " - ", cities$weather))
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[3]]$icon,
    as.character(unlist(lapply(iconSet[cities$weather], function(x) x$icon)))
  )

  ts <- leaflet(cities) %>%
    addTiles() %>%
    addWeatherMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~ paste0(City, " - ", weather),
      clusterOptions = markerClusterOptions(),
      icon = ~ iconSet[weather]
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWeatherMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], paste0(cities$City, " - ", cities$weather))
  expect_identical(
    ts$x$calls[[length(ts$x$calls)]]$args[[3]]$icon,
    as.character(unlist(lapply(iconSet[cities$weather], function(x) x$icon)))
  )


  ## Pulse Markers #########################
  COL1 <- "#ff0000"
  COL2 <- "#0000ff"
  iconSet <- pulseIconList(
    redcol = makePulseIcon(color = COL1),
    bluecol = makePulseIcon(color = COL2)
  )
  expect_s3_class(iconSet[as.factor("redcol")], "leaflet_pulse_icon_set")
  expect_s3_class(iconSet[as.factor("bluecol")], "leaflet_pulse_icon_set")
  expect_s3_class(iconSet["redcol"], "leaflet_pulse_icon_set")
  expect_s3_class(iconSet["bluecol"], "leaflet_pulse_icon_set")
  expect_s3_class(iconSet[1], "leaflet_pulse_icon_set")
  expect_s3_class(iconSet[2], "leaflet_pulse_icon_set")
  expect_error(iconSet[list(1, 2)], "Invalid subscript type")

  expect_error(pulseIconList("asd"))
  expect_s3_class(iconSet, "leaflet_pulse_icon_set")
  expect_length(iconSet, 2)
  expect_s3_class(iconSet[[1]], "leaflet_pulse_icon")
  expect_s3_class(iconSet[[2]], "leaflet_pulse_icon")
  expect_identical(iconSet[1]$red$color, COL1)
  expect_identical(iconSet[2]$blue$color, COL2)

  cities$color <- sample(c("redcol", "bluecol"), nrow(cities), replace = TRUE)
  ts <- leaflet(cities) %>%
    addTiles() %>%
    addPulseMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~ paste0(City, " - ", color),
      icon = ~ iconSet[color]
    )

  lng <- -118.456554
  lat <- 34.078039
  ALABEL <- "This is a label"
  ts <- leaflet() %>%
    addPulseMarkers(
      lng = lng, lat = lat, label = ALABEL,
      icon = makePulseIcon(heartbeat = 0.5)
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-pulse-icon")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addPulseMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], lng)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], ALABEL)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$heartbeat, 0.5)


  ts <- leaflet(cities) %>%
    addTiles() %>%
    addPulseMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      icon = makePulseIcon()
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addPulseMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], cities$City)

  COLORDER <- c("red", "blue", "red", "red", "blue", "blue")
  HEARTORDER <- c("0.4", "0.8", "0.4", "0.4", "0.8", "0.8")
  icon.pop <- pulseIcons(
    color = ifelse(cities$Pop < 500000, "blue", "red"),
    heartbeat = ifelse(cities$Pop < 500000, "0.8", "0.4")
  )
  expect_identical(icon.pop$color, COLORDER)
  expect_identical(icon.pop$heartbeat, HEARTORDER)

  ts <- leaflet(cities) %>%
    addTiles() %>%
    addPulseMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      icon = icon.pop
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addPulseMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], cities$City)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$color, COLORDER)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$heartbeat, HEARTORDER)


  COLORDER <- c("red", "blue", "red", "red", "blue", "blue")
  HEARTORDER <- c("0.4", "0.8", "0.4", "0.4", "0.8", "0.8")
  icon.pop <- pulseIcons(
    color = ifelse(cities$PopCat == "blue", "blue", "red"),
    heartbeat = ifelse(cities$PopCat == "blue", "0.8", "0.4")
  )
  expect_identical(icon.pop$color, COLORDER)
  expect_identical(icon.pop$heartbeat, HEARTORDER)
  ts <- leaflet(cities) %>%
    addTiles() %>%
    addPulseMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      icon = icon.pop
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addPulseMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], cities$City)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$color, COLORDER)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$heartbeat, HEARTORDER)


  ts <- leaflet(cities) %>%
    addTiles() %>%
    addPulseMarkers(
      lng = ~Long, lat = ~Lat,
      label = ~City,
      clusterOptions = markerClusterOptions(),
      icon = icon.pop
    )
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addPulseMarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], cities$Lat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], cities$Long)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[11]], cities$City)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$color, COLORDER)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$heartbeat, HEARTORDER)


  # Make a list of icons (from two different icon libraries).
  # We'll index into it based on name.
  # popIcons <- pulseIconList(
  #   blue = makePulseIcon(color = "blue"),
  #   red = makePulseIcon(color = "red")
  # )
  #
  # leaflet(cities) %>% addTiles() %>%
  #   addPulseMarkers(lng = ~Long, lat = ~Lat,
  #                   label = ~City,
  #                   labelOptions = rep(labelOptions(noHide = T), nrow(cities)),
  #                   icon = ~popIcons[PopCat] )
})
