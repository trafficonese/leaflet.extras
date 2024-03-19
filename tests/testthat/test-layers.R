test_that("layers", {
  expect_error(leaflet() %>% addBingTiles())

  ts <- leaflet() %>%
    addBingTiles(apikey = "somekey")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "tile-bing")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBingTiles")
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[1]])
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[2]])
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$apikey, "somekey")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$type, "Aerial")

  ts <- leaflet() %>%
    addBingTiles(apikey = "somekey", layerId = "somelayerid", group = "group")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "tile-bing")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBingTiles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], "somelayerid")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "group")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$apikey, "somekey")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$type, "Aerial")

  ts <- leaflet() %>%
    addBingTiles(apikey = "somekey", layerId = "somelayerid", group = "group")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "tile-bing")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addBingTiles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], "somelayerid")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "group")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$apikey, "somekey")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$type, "Aerial")

  expect_warning(leaflet() %>%
    addBingTiles(
      apikey = "somekey", layerId = "somelayerid", group = "group",
      imagerySet = "AerialWithLabels"
    ))
  expect_warning(leaflet() %>%
    addBingTiles(
      apikey = "somekey", layerId = "somelayerid", group = "group",
      imagerySet = "Road"
    ))
})
