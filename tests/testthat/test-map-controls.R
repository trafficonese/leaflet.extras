library(leaflet)
library(leaflet.extras)

test_that("map-control-plugins", {

  ## Draw ##########################
  ts <- leaflet() %>%
    setView(0, 0, 2) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addDrawToolbar(
      targetGroup = "draw",
      position = "topright",
      polylineOptions = drawPolylineOptions(),
      polygonOptions = drawPolygonOptions(),
      circleOptions = drawCircleOptions(),
      rectangleOptions = drawRectangleOptions(),
      markerOptions = drawMarkerOptions(),
      circleMarkerOptions = drawCircleMarkerOptions(),
      singleFeature = FALSE,
      editOptions = editToolbarOptions(
        selectedPathOptions = selectedPathOptions()
      )
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-draw-drag")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "lfx-draw")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addDrawToolbar")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "draw")
  ARGS <- ts$x$calls[[length(ts$x$calls)]]$args[[3]]
  expect_identical(ARGS$position, "topright")
  expect_identical(ARGS$draw$polyline, drawPolylineOptions())
  expect_identical(ARGS$draw$polygon, drawPolygonOptions())
  expect_identical(ARGS$draw$circle, drawCircleOptions())
  expect_identical(ARGS$draw$rectangle, drawRectangleOptions())
  expect_identical(ARGS$draw$marker, drawMarkerOptions())
  expect_identical(ARGS$draw$circlemarker, drawCircleMarkerOptions())
  expect_identical(ARGS$draw$singleFeature, FALSE)

  expect_identical(ARGS$edit$selectedPathOptions, selectedPathOptions())
  expect_identical(ARGS$edit$edit, TRUE)
  expect_identical(ARGS$edit$remove, TRUE)
  expect_identical(ARGS$edit$allowIntersection, TRUE)
  expect_null(ARGS$toolbar)
  expect_null(ARGS$handlers)

  ts <- ts %>%
    removeDrawToolbar()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-draw-drag")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "lfx-draw")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeDrawToolbar")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], FALSE)

  ts <- ts %>%
    removeDrawToolbar(clearFeatures = TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeDrawToolbar")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], TRUE)


  ## Other Options
  ICONURL <- "http://leafletjs.com/examples/custom-icons/leaf-green.png"
  SHADOWURL <- "http://leafletjs.com/examples/custom-icons/leaf-shadow.png"
  greenLeafIcon <- makeIcon(
    iconUrl = ICONURL,
    iconWidth = 38, iconHeight = 95,
    iconAnchorX = 22, iconAnchorY = 94,
    shadowUrl = SHADOWURL,
    shadowWidth = 50, shadowHeight = 64,
    shadowAnchorX = 4, shadowAnchorY = 62)
  drawopts <- drawPolylineOptions(allowIntersection = FALSE,
                                  nautic = TRUE, repeatMode = TRUE)
  drawpoly <- drawPolygonOptions(showArea = TRUE, metric = FALSE)
  drawcirc <- drawCircleOptions(showRadius = FALSE, metric = FALSE, repeatMode = TRUE)
  drawrect <- drawRectangleOptions(showArea = FALSE, metric = FALSE)
  drawmark <- drawMarkerOptions(zIndexOffset = 10, repeatMode = TRUE, markerIcon = greenLeafIcon)
  drawcirm <- drawCircleMarkerOptions(color = "red", fill=FALSE)
  drawrect <- drawCircleMarkerOptions(stroke = FALSE, color="orange")
  selfeats <- selectedPathOptions(dashArray = c("20, 40"),maintainColor =TRUE)
  ts <- leaflet() %>%
    setView(0, 0, 2) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addDrawToolbar(
      targetGroup = "draw",
      position = "topright",
      polylineOptions = drawopts,
      polygonOptions = drawpoly,
      circleOptions = drawcirc,
      rectangleOptions = drawrect,
      markerOptions = drawmark,
      circleMarkerOptions = drawcirm,
      singleFeature = FALSE,
      editOptions = editToolbarOptions(
        edit = FALSE, remove = FALSE, allowIntersection = FALSE,
        selectedPathOptions = selfeats
      )
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-draw-drag")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "lfx-draw")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addDrawToolbar")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "draw")
  ARGS <- ts$x$calls[[length(ts$x$calls)]]$args[[3]]
  expect_identical(ARGS$position, "topright")
  expect_identical(ARGS$draw$polyline, drawopts)
  expect_identical(ARGS$draw$polygon, drawpoly)
  expect_identical(ARGS$draw$circle, drawcirc)
  expect_identical(ARGS$draw$rectangle, drawrect)
  expect_identical(ARGS$draw$marker, drawmark)
  expect_identical(ARGS$draw$circlemarker, drawcirm)
  expect_identical(ARGS$draw$singleFeature, FALSE)

  expect_identical(ARGS$edit$selectedPathOptions, selfeats)
  expect_identical(ARGS$edit$edit, FALSE)
  expect_identical(ARGS$edit$remove, FALSE)
  expect_identical(ARGS$edit$allowIntersection, FALSE)
  expect_null(ARGS$toolbar)
  expect_null(ARGS$handlers)



  drawmark <- drawMarkerOptions(zIndexOffset = 10, repeatMode = TRUE,
                                markerIcon = greenLeafIcon)
  ts <- leaflet() %>%
    setView(0, 0, 2) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addDrawToolbar(
      targetGroup = "draw",
      position = "topright",
      markerOptions = drawmark,
      singleFeature = FALSE
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-draw-drag")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "lfx-draw")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addDrawToolbar")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "draw")

  awesomeicon <- leaflet::makeAwesomeIcon(awesomeIcons(
    icon = 'ios-close',iconColor = 'black',
    library = 'ion',markerColor = "green"))
  drawmark <- drawMarkerOptions(zIndexOffset = 10, repeatMode = TRUE,
                                markerIcon = awesomeicon)
  ts <- leaflet() %>%
    setView(0, 0, 2) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addDrawToolbar(
      targetGroup = "draw",
      position = "topright",
      markerOptions = drawmark,
      singleFeature = FALSE
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-draw-drag")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "lfx-draw")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addDrawToolbar")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "draw")


  expect_error(leaflet() %>%
                 addDrawToolbar(
                   markerOptions = drawMarkerOptions(zIndexOffset = 10, repeatMode = TRUE,
                                                     markerIcon = list("something else")),
                 ))

  ## Full Screen ##########################
  ts <- leaflet() %>%
    addTiles() %>%
    addFullscreenControl()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-fullscreen")
  expect_identical(ts$x$options$fullscreenControl$position, "topleft")
  expect_identical(ts$x$options$fullscreenControl$pseudoFullscreen, FALSE)

  ts <- leaflet(options = NULL) %>%
    addTiles() %>%
    addFullscreenControl(position = "bottomright", pseudoFullscreen = TRUE)
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-fullscreen")
  expect_identical(ts$x$options$fullscreenControl$position, "bottomright")
  expect_identical(ts$x$options$fullscreenControl$pseudoFullscreen, TRUE)


  ## Sleep ##########################
  ts <- leaflet() %>%
    suspendScroll(sleep)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-sleep")
  expect_identical(ts$x$options$sleepTime, 750)
  expect_identical(ts$x$options$wakeTime, 750)
  expect_identical(ts$x$options$sleepNote, TRUE)
  expect_identical(ts$x$options$hoverToWake, TRUE)
  expect_identical(ts$x$options$wakeMessage, "Click or Hover to Wake")
  expect_identical(ts$x$options$sleepOpacity, 0.7)
  expect_s3_class(ts, "leaflet")

  ts <- leaflet(options = NULL) %>%
    suspendScroll(sleep, sleepTime = 1000, wakeTime = 1200,
                  sleepNote = "Go to sleep", wakeMessage = "Wake Up",
                  hoverToWake = FALSE, sleepOpacity = 0.1)
  expect_identical(ts$x$options$sleepTime, 1000)
  expect_identical(ts$x$options$wakeTime, 1200)
  expect_identical(ts$x$options$sleepNote, "Go to sleep")
  expect_identical(ts$x$options$wakeMessage, "Wake Up")
  expect_identical(ts$x$options$hoverToWake, FALSE)
  expect_identical(ts$x$options$sleepOpacity, 0.1)

  ## Hash ##########################
  ts <- leaflet() %>%
    addHash()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-hash")

  ## TileLayer PouchDB ##########################
  ts <- leaflet() %>%
    enableTileCaching() %>%
    addTiles(options = tileOptions(useCache = TRUE, crossOrigin = TRUE))
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-tilelayer")


  ## GPS ##########################
  ts <- leaflet() %>%
    addTiles() %>%
    addControlGPS()
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-gps")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addControlGPS")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$position, "topleft")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$activate, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$autoCenter, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$setView, FALSE)
  expect_s3_class(ts, "leaflet")

  ts <- leaflet() %>%
    addTiles() %>%
    addControlGPS(options = gpsOptions(
      position = "bottomright",
      activate = TRUE,
      autoCenter = TRUE,
      maxZoom = 10,
      setView = TRUE
    ))
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-gps")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addControlGPS")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$position, "bottomright")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$activate, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$autoCenter, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$setView, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$maxZoom, 10)

  ts <- ts %>%
    activateGPS()
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "activateGPS")

  ts <- ts %>%
    deactivateGPS()
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "deactivateGPS")

  ts <- ts %>%
    removeControlGPS()
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeControlGPS")

})
