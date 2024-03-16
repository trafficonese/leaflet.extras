library(leaflet)
library(leaflet.extras)

test_that("heatmaps", {

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
