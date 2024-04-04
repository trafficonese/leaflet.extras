greenLeafIcon <- makeIcon(
  iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62)
customIcon <- list(
  iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconSize = c(38, 90))
awesomeicon <- leaflet::makeAwesomeIcon(
  icon = "ios-close", iconColor = "black",
  library = "ion", markerColor = "green")


test_that("map-control-plugins", {
  ## Measure ###################
  ts <- leaflet() %>%
    addMeasurePathToolbar()
  expect_s3_class(ts, "leaflet")
  # expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-styleeditor")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "setMeasurementOptions")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showOnHover, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$minPixelDistance, 30)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showDistances, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showArea, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$imperial, FALSE)

  ts <- leaflet() %>%
    addMeasurePathToolbar(options = measurePathOptions(
      showOnHover = TRUE,
      minPixelDistance = 10,
      showDistances = FALSE,
      showArea = FALSE,
      imperial = TRUE
    ))
  expect_s3_class(ts, "leaflet")
  # expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-styleeditor")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "setMeasurementOptions")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showOnHover, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$minPixelDistance, 10)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showDistances, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showArea, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$imperial, TRUE)


  ## Style-Editor ##########################
  ts <- leaflet() %>%
    addStyleEditor()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-styleeditor")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addStyleEditor")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$openOnLeafletDraw, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$position, "topleft")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$useGrouping, FALSE)

  ts <- leaflet() %>%
    addStyleEditor(position = "bottomright", openOnLeafletDraw = FALSE, useGrouping = TRUE)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-styleeditor")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addStyleEditor")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$openOnLeafletDraw, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$position, "bottomright")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$useGrouping, TRUE)

  ts <- leaflet() %>%
    removeStyleEditor()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeStyleEditor")


  ## WMS-Legend ##########################
  ts <- leaflet() %>%
    addWMSLegend(uri = "someuri")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-wms-legend")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWMSLegend")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$options$uri, "someuri")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$options$position, "topright")

  url <- "http://www.someuri.com/geovser"
  ts <- leaflet() %>%
    addWMSLegend(uri = url, position = "bottomright", layerId = "somelayerid")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-wms-legend")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWMSLegend")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$options$uri, url)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$options$position, "bottomright")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$layerId, "somelayerid")


  ## Search OSM ##########################
  opts <- searchOptions(autoCollapse = TRUE, minLength = 2)
  ts <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addSearchOSM(options = opts)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addSearchOSM")
  opts$marker$icon = NULL
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], opts)

  txt <- "some text"
  ts <- leaflet() %>%
    searchOSMText(txt)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "searchOSMText")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], txt)

  ts <- leaflet() %>%
    removeSearchOSM()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeSearchOSM")


  ts <- leaflet() %>% addTiles() %>%
    addReverseSearchOSM(displayText = TRUE)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchOSM")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, TRUE)

  ts <- leaflet() %>% addTiles() %>%
    addReverseSearchOSM(displayText = FALSE)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchOSM")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, TRUE)

  ts <- leaflet() %>%
    clearSearchOSM()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "clearSearchOSM")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args, list())

  showfeat <- list(weight = 2,color = "red",dashArray = '5,10',fillOpacity = 0.2,opacity = 0.5)
  showbound <- list(weight = 2,color = "#444444",dashArray = '5,10',fillOpacity = 0.2,opacity = 0.5)
  showhigh <- list(opacity = 0.8,fillOpacity = 0.5,weight = 5)
  ts <- leaflet() %>% addTiles() %>%
    addReverseSearchOSM(
      displayText = FALSE, showSearchLocation = FALSE, group = "mygroup",
      showBounds = TRUE, fitBounds = FALSE, showFeature = FALSE
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchOSM")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "mygroup")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeatureOptions, showfeat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBoundsOptions, showbound)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showHighlightOptions, showhigh)


  showfeat <- list(weight = 7, color = "purple", dashArray = '2,5', fillOpacity = 0.8, opacity = 1)
  showbound <- list(weight = 4, color = "orange", dashArray = '10,20', fillOpacity = 0.1, opacity = 1)
  showhigh <- list(opacity = 1, fillOpacity = 0.8, weight = 9)
  ts <- leaflet() %>% addTiles() %>%
    addReverseSearchOSM(
      displayText = FALSE, showSearchLocation = FALSE, group = "mygroup",
      showBounds = TRUE, fitBounds = FALSE, showFeature = TRUE,
      marker = list(icon = greenLeafIcon),
      showFeatureOptions = showfeat,
      showBoundsOptions = showbound,
      showHighlightOptions = showhigh
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchOSM")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "mygroup")
  expect_type(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$marker, "list")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$marker$icon$iconUrl$data, greenLeafIcon$iconUrl)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeatureOptions, showfeat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBoundsOptions, showbound)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showHighlightOptions, showhigh)

  showfeat <- list(weight = 7, color = "#335423", dashArray = '2,5', fillOpacity = 0.8, opacity = 1)
  showbound <- list(weight = 4, color = "#987655", dashArray = '10,20', fillOpacity = 0.1, opacity = 1)
  showhigh <- list(opacity = 1, fillOpacity = 0.8, weight = 9)
  ts <- leaflet() %>% addTiles() %>%
    addReverseSearchOSM(
      displayText = FALSE, showSearchLocation = FALSE, group = "mygroup",
      showBounds = TRUE, fitBounds = FALSE, showFeature = FALSE,
      marker = list(icon = awesomeicon),
      showFeatureOptions = showfeat,
      showBoundsOptions = showbound,
      showHighlightOptions = showhigh
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "ionicons")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchOSM")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "mygroup")
  expect_type(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$marker, "list")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$marker$icon, c(awesomeicon, awesomemarker = TRUE))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeatureOptions, showfeat)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBoundsOptions, showbound)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showHighlightOptions, showhigh)

  ts <- leaflet() %>% addTiles() %>%
    addReverseSearchOSM(
      displayText = TRUE, showSearchLocation = TRUE, group = "mygroup",
      showBounds = TRUE, fitBounds = TRUE, showFeature = TRUE,
      marker = list(icon = customIcon)
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchOSM")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "mygroup")
  expect_type(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$marker, "list")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$marker$icon$iconUrl$data, customIcon$iconUrl)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$marker$icon$iconSize, list(customIcon$iconSize))

  ## Search Google ##########################
  opts <- searchOptions(autoCollapse = TRUE, minLength = 2)
  expect_warning({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addSearchGoogle(options = opts)
  })
  ts <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addSearchGoogle(options = opts, apikey = "something")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addSearchGoogle")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], opts)

  ts <- leaflet() %>%
    removeSearchGoogle()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeSearchGoogle")


  expect_warning(leaflet() %>% addReverseSearchGoogle())
  ts <- leaflet() %>%
    addReverseSearchGoogle(apikey = "something")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchGoogle")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, TRUE)

  ts <- leaflet() %>%
    addReverseSearchGoogle(displayText = FALSE, apikey = "something")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchGoogle")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, TRUE)

  ts <- leaflet() %>%
    addReverseSearchGoogle(
      displayText = FALSE, apikey = "something",
      showSearchLocation = FALSE, group = "mygroup",
      showBounds = TRUE, fitBounds = FALSE, showFeature = FALSE
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addReverseSearchGoogle")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showSearchLocation, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$fitBounds, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showBounds, TRUE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]]$showFeature, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "mygroup")


  ## Search addSearchUSCensusBureau  ##########################
  opts <- searchOptions(autoCollapse = TRUE, minLength = 2)
  ts <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addSearchUSCensusBureau(options = opts)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addSearchUSCensusBureau")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], opts)

  ts <- leaflet() %>%
    removeSearchUSCensusBureau()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeSearchUSCensusBureau")


  ## Search Features  ##########################
  opts <- searchFeaturesOptions()
  ts <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addSearchFeatures(
      targetGroups = "group",
      options = opts
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addSearchFeatures")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], "group")
  opts$marker$icon <- NULL
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], opts)

  opts <- searchFeaturesOptions(
    propertyName = "popup",
    initial = TRUE,
    openPopup = TRUE
  )
  ts <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addSearchFeatures(
      targetGroups = "group",
      options = opts
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addSearchFeatures")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], "group")
  opts$marker$icon <- NULL
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], opts)

  ts <- leaflet() %>%
    removeSearchFeatures()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeSearchFeatures")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], FALSE)

  ts <- leaflet() %>%
    removeSearchFeatures(clearFeatures = TRUE)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-search")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeSearchFeatures")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], TRUE)

  ts <- leaflet() %>%
    clearSearchFeatures()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "clearSearchFeatures")

  ## Draw ##########################
  expect_error(leaflet() %>% addDrawToolbar(targetLayerId = "something", targetGroup = "asdf"))
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


  drawshape <- drawShapeOptions(
    stroke = FALSE, color = "blue", weight = 3, opacity = 0.7, fill = FALSE, fillColor = "blue", fillOpacity = 0.2,
    dashArray = c(10, 16), lineCap = TRUE, lineJoin = TRUE, clickable = FALSE, pointerEvents = NULL, smoothFactor = 3, noClip = FALSE
  )
  drawopts <- drawPolylineOptions(
    allowIntersection = FALSE, drawError = list(color = "red", timeout = 200),
    guidelineDistance = 500, maxGuideLineLength = 2000,
    showLength = FALSE, metric = FALSE, feet = FALSE, nautic = TRUE,
    zIndexOffset = 4000, shapeOptions = drawshape, repeatMode = TRUE
  )
  drawpolyg <- drawPolygonOptions(
    showArea = TRUE, metric = FALSE, shapeOptions = drawshape, repeatMode = TRUE
  )
  drawcircl <- drawCircleOptions(
    showRadius = FALSE, metric = FALSE, feet = FALSE, nautic = TRUE, shapeOptions = drawshape, repeatMode = TRUE
  )
  drawrect <- drawRectangleOptions(
    showArea = FALSE, metric = FALSE, shapeOptions = drawshape, repeatMode = TRUE
  )
  drawmark <- drawMarkerOptions(markerIcon = NULL, zIndexOffset = 4000, repeatMode = TRUE)
  drawcirc <- drawCircleMarkerOptions(
    stroke = TRUE, color = "blue", weight = 8, opacity = 1, fill = FALSE, fillColor = "red",
    fillOpacity = 0.5, clickable = FALSE, zIndexOffset = 4000, repeatMode = TRUE
  )
  selpath <- selectedPathOptions(
    dashArray = c("30, 40"), weight = 5, color = "orange", fill = FALSE,
    fillColor = "yellow", fillOpacity = 0.9, maintainColor = TRUE
  )
  ts <- leaflet() %>%
    setView(0, 0, 2) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addDrawToolbar(
      targetGroup = "draw",
      position = "topright",
      polylineOptions = drawopts,
      polygonOptions = drawpolyg,
      circleOptions = drawcircl,
      rectangleOptions = drawrect,
      markerOptions = drawmark,
      circleMarkerOptions = drawcirc,
      singleFeature = FALSE,
      editOptions = editToolbarOptions(
        selectedPathOptions = selpath
      ),
      drag = FALSE
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-draw")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addDrawToolbar")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "draw")
  ARGS <- ts$x$calls[[length(ts$x$calls)]]$args[[3]]
  expect_identical(ARGS$position, "topright")
  expect_identical(ARGS$draw$polyline, drawopts)
  expect_identical(ARGS$draw$polygon, drawpolyg)
  expect_identical(ARGS$draw$circle, drawcircl)
  expect_identical(ARGS$draw$rectangle, drawrect)
  expect_identical(ARGS$draw$marker, drawmark)
  expect_identical(ARGS$draw$circlemarker, drawcirc)
  expect_identical(ARGS$draw$singleFeature, FALSE)
  expect_identical(ARGS$edit$selectedPathOptions, selpath)
  expect_identical(ARGS$edit$edit, TRUE)
  expect_identical(ARGS$edit$remove, TRUE)
  expect_identical(ARGS$edit$allowIntersection, TRUE)
  expect_null(ARGS$toolbar)
  expect_null(ARGS$handlers)

  ts <- ts %>%
    removeDrawToolbar()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-draw")
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
    shadowAnchorX = 4, shadowAnchorY = 62
  )
  drawopts <- drawPolylineOptions(
    allowIntersection = FALSE,
    nautic = TRUE, repeatMode = TRUE
  )
  drawpoly <- drawPolygonOptions(showArea = TRUE, metric = FALSE)
  drawcirc <- drawCircleOptions(showRadius = FALSE, metric = FALSE, repeatMode = TRUE)
  drawrect <- drawRectangleOptions(showArea = FALSE, metric = FALSE)
  drawmark <- drawMarkerOptions(zIndexOffset = 10, repeatMode = TRUE, markerIcon = greenLeafIcon)
  drawcirm <- drawCircleMarkerOptions(color = "red", fill = FALSE)
  drawrect <- drawCircleMarkerOptions(stroke = FALSE, color = "orange")
  selfeats <- selectedPathOptions(dashArray = c("20, 40"), maintainColor = TRUE)
  hndl <- handlersOptions(
    polyline = list(
      tooltipStart = "Click It",
      tooltipCont = "Keep going",
      tooltipEnd = "Make it stop"
    )
  )
  toolbr <- toolbarOptions(
    actions = list(text = "STOP"),
    finish = list(text = "DONE"),
    buttons = list(
      polyline = "Draw a sexy polyline",
      rectangle = "Draw a gigantic rectangle",
      circlemarker = "Make a nice circle"
    )
  )

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
      ),
      handlers = hndl,
      toolbar = toolbr
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
  # expect_identical(ARGS$draw$marker, drawmark)
  expect_identical(ARGS$draw$circlemarker, drawcirm)
  expect_identical(ARGS$draw$singleFeature, FALSE)

  expect_identical(ARGS$edit$selectedPathOptions, selfeats)
  expect_identical(ARGS$edit$edit, FALSE)
  expect_identical(ARGS$edit$remove, FALSE)
  expect_identical(ARGS$edit$allowIntersection, FALSE)

  expect_identical(ARGS$toolbar, toolbr)
  expect_identical(ARGS$handlers, hndl)



  drawmark <- drawMarkerOptions(
    zIndexOffset = 10, repeatMode = TRUE,
    markerIcon = greenLeafIcon
  )
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

  awesomeicon <- leaflet::makeAwesomeIcon(
    icon = "ios-close", iconColor = "black",
    library = "ion", markerColor = "green"
  )
  drawmark <- drawMarkerOptions(
    zIndexOffset = 10, repeatMode = TRUE,
    markerIcon = awesomeicon
  )
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
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addDrawToolbar")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "draw")


  expect_error(leaflet() %>%
    addDrawToolbar(
      markerOptions = drawMarkerOptions(
        zIndexOffset = 10, repeatMode = TRUE,
        markerIcon = list("something else")
      )
    ))


  ## This doesnt throw an error but it doesnt work. Console-errors.. Should we emit a warning?
  # drawmark <- drawMarkerOptions(
  #   markerIcon = leaflet::makeAwesomeIcon(awesomeIcons(
  #     icon = "ios-close", iconColor = "black",
  #     library = "ion", markerColor = "green"
  #   ))
  # )
  # ts <- leaflet() %>%
  #   setView(0, 0, 2) %>%
  #   addProviderTiles(providers$CartoDB.Positron) %>%
  #   addDrawToolbar(markerOptions = drawmark)

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
    suspendScroll(sleep,
      sleepTime = 1000, wakeTime = 1200,
      sleepNote = "Go to sleep", wakeMessage = "Wake Up",
      hoverToWake = FALSE, sleepOpacity = 0.1
    )
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
