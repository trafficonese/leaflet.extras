test_that("maputils", {
  geoJson <- jsonlite::fromJSON(readr::read_file(
    paste0(
      "https://raw.githubusercontent.com/MinnPost/simple-map-d3",
      "/master/example-data/world-population.geo.json"
    )
  ))
  world <- leaflet(
    options = leafletOptions(
      maxZoom = 5,
      crs = leafletCRS(
        crsClass = "L.Proj.CRS", code = "ESRI:53009",
        proj4def = "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs",
        resolutions = c(65536, 32768, 16384, 8192, 4096, 2048)
      )
    )
  ) %>%
    addGeoJSONv2(jsonlite::toJSON(geoJson), popupProperty = "POP_DENSITY", labelProperty = "NAME") %>%
    addGraticule(style = list(color = "#999", weight = 0.5, opacity = 1, fill = NA)) %>%
    addGraticule(sphere = TRUE, style = list(color = "#777", weight = 1, opacity = 0.25, fill = NA))
  # world

  # change background to white
  ts <- world %>%
    setMapWidgetStyle(list(background = "red"))
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "map-widget-style")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "setMapWidgetStyle")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$background, "red")

  ts <- world %>% debugMap()
  expect_s3_class(ts, "leaflet")
  expect_identical(
    ts$jsHooks$render[[1]]$code[[1]],
    "function(el, x){var map=this; debugger;}"
  )


  ts <- leaflet() %>%
    addTiles() %>%
    addResetMapButton()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "ionicons")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-easybutton")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addEasyButton")
  expect_length(ts$jsHooks$render, 1)
})
