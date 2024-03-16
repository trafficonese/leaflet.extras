library(leaflet)
library(leaflet.extras)

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
      addWebGLHeatmap(lng = ~long, lat = ~lat,
                      gradientTexture = "skyline1")
  })
  ts <- leaflet(quakes) %>%
    addWebGLHeatmap(lng = ~long, lat = ~lat, intensity = ~mag,
                    gradientTexture = "skyline")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][,"intensity"], quakes$mag)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$size, "30000")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$units, "m")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$opacity, 1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$gradientTexture, "skyline")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$alphaRange, 1)

  ts <- leaflet(quakes) %>%
    addWebGLHeatmap(lng = ~long, lat = ~lat, intensity = ~mag,
                    size = 20000, group = "somegroup", opacity = 0.1, alphaRange = 0.8,
                    units = "px",
                    gradientTexture = "deep-sea")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-webgl-heatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addWebGLHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][,"intensity"], quakes$mag)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$size, 20000)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$units, "px")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$opacity, 0.1)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$gradientTexture, "deep-sea")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$alphaRange, 0.8)


  geoJson <- readr::read_file(
    "https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson"
  )

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

  kml <- readr::read_file(
    system.file("examples/data/kml/crimes.kml.zip", package = "leaflet.extras")
  )
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
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "circlemarker")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[7]], markerOptions(radius = 1))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[12]], labelOptions())
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[14]], popupOptions())



  ## addHeatmap #########################
  ts <- leaflet(quakes) %>% addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView( 178, -20, 5 ) %>%
    addHeatmap(lng = ~long, lat = ~lat, intensity = ~mag,
               blur = 20, max = 0.05, radius = 15)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][,"intensity"], quakes[,"mag"])


  ts <- leaflet(quakes) %>% addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView( 178, -20, 5 ) %>%
    addHeatmap(lng = ~long, lat = ~lat, intensity = ~mag,
               gradient = RColorBrewer::brewer.pal(5, "Reds"),
               blur = 20, max = 0.05, radius = 15)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][,"intensity"], quakes[,"mag"])
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$max, 0.05)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$radius, 15)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$blur, 20)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]]$minOpacity, 0.05)


  ts <- leaflet(quakes) %>% addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView( 178, -20, 5 ) %>%
    addHeatmap(lng = ~long, lat = ~lat, intensity = NULL,
               gradient = RColorBrewer::brewer.pal(5, "BrBG"),
               blur = 20, max = 0.05, radius = 15)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addHeatmap")
  expect_identical(ncol(ts$x$calls[[length(ts$x$calls)]]$args[[1]]), 2L)


  ts <- leaflet(quakes) %>% addProviderTiles(providers$CartoDB.DarkMatter) %>%
    setView( 178, -20, 5 ) %>%
    addHeatmap(lng = ~long, lat = ~lat, intensity = 3,
               blur = 20, max = 0.05, radius = 15)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-heat")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addHeatmap")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]][,"intensity"], rep(3, nrow(quakes)))

})
