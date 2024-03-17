library(leaflet)
library(leaflet.extras)

test_that("Geodesic", {
  greenLeafIcon <- makeIcon(
    iconUrl = "https://leafletjs.com/examples/custom-icons/leaf-green.png",
    iconWidth = 38, iconHeight = 95,
    iconAnchorX = 22, iconAnchorY = 94,
    shadowUrl = "https://leafletjs.com/examples/custom-icons/leaf-shadow.png",
    shadowWidth = 50, shadowHeight = 64,
    shadowAnchorX = 4, shadowAnchorY = 62
  )

  ## Lines ###################
  cities_df_all <- data.frame(
    city = c("Hammerfest", "Calgary", "Los Angeles", "Santiago", "Cape Town", "Tokio", "Barrow"),
    lat = c(70.67, 51.05, 34.05, -33.44, -33.91, 35.69, 71.29),
    lng = c(23.68, -114.08, -118.24, -70.71, 18.41, 139.69, -156.76)
  )
  cities_df_all$radius <- runif(nrow(cities_df_all), 4000, 900000)
  cities_df_all$weight <- runif(nrow(cities_df_all), 1, 20)
  cities_df_all$opacity  <- runif(nrow(cities_df_all), 0.1, 1)
  cities_df_all$steps  <- runif(nrow(cities_df_all), 5, 400)
  cities_df_all$color <- sample(c("green","red","blue","orange","black"), nrow(cities_df_all), replace = TRUE)
  # cities_df_all <- list(cities_df_all[1:4,],cities_df_all[5:7,])
  cities_df <- cities_df_all[1:4,]

  ts <- leaflet(cities_df) %>%
    addGeodesicPolylines(lng = ~lng, lat = ~lat)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeodesicPolylines")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2,3, 5:12)]))


  ## Circles ###################
  ts <- leaflet(cities_df) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addMeasure(primaryLengthUnit = "meters", primaryAreaUnit = "sqmeters") %>%
    addGreatCircles(lng_center = ~lng, lat_center = ~lat, radius = 100)
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-geodesic")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGreatCircles")
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(4,5, 7:13)]))
})
