## Data ##############
geoJson <- readr::read_file(
  "https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson"
)
kml <- readr::read_file(
  system.file("examples/data/kml/crimes.kml.zip", package = "leaflet.extras")
)
csv <- readr::read_file(
  system.file("examples/data/csv/world_airports.csv.zip", package = "leaflet.extras")
)
airports <- readr::read_file(
  system.file("examples/data/gpx/md-airports.gpx.zip", package = "leaflet.extras")
)

## Tests ###################
test_that("heatmaps", {
  ## WebGL Heatmap #########################
  ts <- leaflet(quakes) %>%
    addProviderTiles(providers$CartoDB.DarkMatter) %>%
    addWebGLHeatmap(lng = ~long, lat = ~lat)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$size, "30000")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$units, "m")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$opacity, 1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$alphaRange, 1)

  expect_error({
    leaflet(quakes) %>%
      addWebGLHeatmap(
        lng = ~long, lat = ~lat,
        gradientTexture = "skyline1"
      )
  })
  ts <- leaflet(quakes) %>%
    addWebGLHeatmap(
      lng = ~long, lat = ~lat, intensity = ~mag,
      gradientTexture = "skyline"
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][, "intensity"], quakes$mag)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$size, "30000")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$units, "m")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$opacity, 1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$gradientTexture, "skyline")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$alphaRange, 1)

  ts <- leaflet(quakes) %>%
    addWebGLHeatmap(
      lng = ~long, lat = ~lat, intensity = ~mag,
      size = 20000, group = "somegroup", opacity = 0.1, alphaRange = 0.8,
      units = "px",
      gradientTexture = "deep-sea"
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][, "intensity"], quakes$mag)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$size, 20000)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$units, "px")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$opacity, 0.1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$gradientTexture, "deep-sea")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$alphaRange, 0.8)

  ts <- leaflet(quakes) %>%
    removeWebGLHeatmap(layerId = "somelayerid")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeWebGLHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], "somelayerid")

  ts <- leaflet(quakes) %>%
    clearWebGLHeatmap()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "clearWebGLHeatmap")

  ts <- leaflet() %>%
    setView(-77.0369, 38.9072, 12) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addWebGLGeoJSONHeatmap(
      geoJson,
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLGeoJSONHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$size, "30000")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$units, "m")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$opacity, 1)

  ts <- leaflet() %>%
    setView(-77.0369, 38.9072, 12) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addWebGLGeoJSONHeatmap(
      geoJson,
      size = 30, units = "px", gradientTexture = "deep-sea",
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLGeoJSONHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$size, 30)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$units, "px")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$gradientTexture, "deep-sea")

  ts <- leaflet() %>%
    setView(-77.0369, 38.9072, 12) %>%
    addGeoJSONv2(
      geoJson,
      markerType = "circleMarker",
      stroke = FALSE, fillColor = "black", fillOpacity = 0.7,
      markerOptions = markerOptions(radius = 2)
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")

  ts <- leaflet() %>%
    setView(-77.0369, 38.9072, 12) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addWebGLKMLHeatmap(kml, size = 20, units = "px") %>%
    addKML(
      kml,
      markerType = "circleMarker",
      stroke = FALSE, fillColor = "black", fillOpacity = 1,
      markerOptions = markerOptions(radius = 1)
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addKML")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], kml)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "circleMarker")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[7]], markerOptions(radius = 1))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[12]], labelOptions())
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[14]], popupOptions())

  ts <- leaflet() %>%
    setView(0, 0, 2) %>%
    addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>%
    addWebGLCSVHeatmap(
      csv,
      csvParserOptions("latitude_deg", "longitude_deg"),
      size = 10, units = "px",
      layerId = "somelayer", group = "mygroup"
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLCSVHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], csv)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[6]], csvParserOptions("latitude_deg", "longitude_deg"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$size, 10)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$units, "px")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$opacity, 1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$alphaRange, 1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "somelayer")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "mygroup")


  ts <- leaflet() %>%
    addBootstrapDependency() %>%
    setView(-76.6413, 39.0458, 8) %>%
    addProviderTiles(
      providers$CartoDB.Positron,
      options = providerTileOptions(detectRetina = TRUE)
    ) %>%
    addGPX(
      airports,
      markerType = "circleMarker",
      stroke = FALSE, fillColor = "black", fillOpacity = 1,
      markerOptions = markerOptions(radius = 1.5),
      group = "airports"
    ) %>%
    addWebGLGPXHeatmap(
      airports,
      size = 20000,
      group = "airports",
      opacity = 0.9
    )
  # ts
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLGPXHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], airports)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "airports")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$size, 20000)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$units, "m")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$opacity, 0.9)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$alphaRange, 1)

  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$method, "addGPX")
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[1]], airports)
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[3]], "airports")
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[4]], "circleMarker")
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[7]], markerOptions(radius = 1.5))
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[12]], labelOptions())
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[14]], popupOptions())
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[15]]$stroke, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[15]]$fillColor, "black")
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[15]]$fillOpacity, 1)

  ## addHeatmap #########################
  ts <- leaflet(quakes) %>%
    addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView(178, -20, 5) %>%
    addHeatmap(
      lng = ~long, lat = ~lat, intensity = ~mag,
      blur = 20, max = 0.05, radius = 15
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][, "intensity"], quakes[, "mag"])

  ts <- leaflet() %>% removeHeatmap(layerId = "bylayerid")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], "bylayerid")

  ts <- leaflet() %>% clearHeatmap()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "clearHeatmap")


  ts <- leaflet(quakes) %>%
    addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView(178, -20, 5) %>%
    addHeatmap(
      lng = ~long, lat = ~lat, intensity = ~mag,
      # gradient = RColorBrewer::brewer.pal(5, "Reds"),
      gradient = c("#FEE5D9", "#FCAE91", "#FB6A4A", "#DE2D26", "#A50F15"),
      blur = 20, max = 0.05, radius = 15
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][, "intensity"], quakes[, "mag"])
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$max, 0.05)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$radius, 15)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$blur, 20)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$minOpacity, 0.05)


  ts <- leaflet(quakes) %>%
    addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView(178, -20, 5) %>%
    addHeatmap(
      lng = ~long, lat = ~lat, intensity = NULL,
      # gradient = RColorBrewer::brewer.pal(5, "BrBG"),
      gradient = c("#A6611A", "#DFC27D", "#F5F5F5", "#80CDC1", "#018571"),
      blur = 20, max = 0.05, radius = 15
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addHeatmap")
  expect_identical(ncol(ts$x$calls[[length(ts$x$calls)]]$args[[1]]), 2L)


  ts <- leaflet(quakes) %>%
    addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView(178, -20, 5) %>%
    addHeatmap(
      lng = ~long, lat = ~lat, intensity = 3,
      blur = 20, max = 0.05, radius = 15
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][, "intensity"], rep(3, nrow(quakes)))


  ts <- leaflet(quakes) %>%
    addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView(-77.0369, 38.9072, 12) %>%
    addGeoJSONHeatmap(geojson = geoJson)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], geoJson)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[2]])
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[3]])
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[4]])
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$minOpacity, 0.05)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$max, 1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$radius, 25)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$blur, 15)

  ## TODO - GRADIENT CAN BE ANYTHING-- throws error in the browser console..
  ts <- leaflet(quakes) %>%
    addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView(-77.0369, 38.9072, 12) %>%
    addGeoJSONHeatmap(
      geojson = geoJson, layerId = "id", group = "group",
      intensityProperty = "someprop", minOpacity = 0.4, max = 10,
      radius = 50, gradient = "asd", cellSize = 20
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], geoJson)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "someprop")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "group")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "id")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$max, 10)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$radius, 50)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$cellSize, 20)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]]$gradient, "asd")

  ts <- leaflet() %>%
    setView(-77.0369, 38.9072, 12) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addKMLHeatmap(kml, radius = 7) %>%
    addKML(
      kml,
      markerType = "circleMarker",
      stroke = FALSE, fillColor = "black", fillOpacity = 1,
      markerOptions = markerOptions(radius = 1)
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addKML")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], kml)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "circleMarker")

  # addCSVHeatmap
  ts <- leaflet() %>%
    setView(0, 0, 2) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addCSVHeatmap(
      csv, csvParserOptions("latitude_deg", "longitude_deg"),
      layerId = "somelayer", group = "mygroup"
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addCSVHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], csv)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "somelayer")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "mygroup")

  ## for more examples see
  # browseURL(system.file("examples/KML.R", package = "leaflet.extras"))


  ts <- leaflet() %>%
    addBootstrapDependency() %>%
    setView(-76.6413, 39.0458, 8) %>%
    addProviderTiles(
      providers$CartoDB.Positron,
      options = providerTileOptions(detectRetina = TRUE)
    ) %>%
    addGPXHeatmap(airports) %>%
    addGPX(
      airports,
      markerType = "circleMarker",
      stroke = FALSE, fillColor = "black", fillOpacity = 1,
      markerOptions = markerOptions(radius = 1.5),
      group = "airports"
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGPX")
  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$method, "addGPXHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], airports)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "airports")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "circleMarker")

  expect_identical(ts$x$calls[[length(ts$x$calls) - 1]]$args[[1]], airports)
  expect_null(ts$x$calls[[length(ts$x$calls) - 1]]$args[[2]])
  expect_null(ts$x$calls[[length(ts$x$calls) - 1]]$args[[3]])
  expect_null(ts$x$calls[[length(ts$x$calls) - 1]]$args[[4]])
})
