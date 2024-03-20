## DATA ###################
fName <- "https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson"
topoJson <- readr::read_file(fName)
geoJson <- readr::read_file(
  "https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson"
)
geoJsonPoints <- readr::read_file(
  "https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson"
)


## Tests ###################
test_that("geojson and jsFunctions", {

  ts <- leaflet() %>%
    addBootstrapDependency() %>%
    setView(-75.14, 40, zoom = 11) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addGeoJSONChoropleth(
      topoJson,
      valueProperty = "incidents",
      scale = "OrRd", mode = "q", steps = 5,
      padding = c(0.2, 0),
      popupProperty = propstoHTMLTable(
        props = c("dist_numc", "location", "incidents", "_feature_id_string"),
        table.attrs = list(class = "table table-striped table-bordered"), drop.na = T
      ),
      labelProperty = JS("function(feature){return \"WARD: \" + feature.properties.dist_numc;}"),
      color = "#ffffff", weight = 1, fillOpacity = 0.7,
      highlightOptions =
        highlightOptions(
          fillOpacity = 1, weight = 2, opacity = 1, color = "#000000",
          bringToFront = TRUE, sendToBack = TRUE
        ),
      legendOptions =
        legendOptions(title = "Crimes", position = "bottomright"),
      group = "orange-red"
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-choropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONChoropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], topoJson)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[2]])
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "orange-red")

  expect_error(leaflet() %>%
    addGeoJSONChoropleth(
      topoJson,
      valueProperty = "incidents",
      popupProperty = propstoHTMLTable(
        table.attrs = list("table table-striped table-bordered"), drop.na = T
      )
    ))

  ts <- leaflet() %>%
    addGeoJSONv2(
      geoJson,
      markerType = "circleMarker",
      stroke = FALSE, fillColor = "black", fillOpacity = 0.7,
      markerOptions = markerOptions(radius = 2)
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], geoJson)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "circleMarker")

  expect_error(
    leaflet() %>%
      addGeoJSONv2(
        geoJson,
        markerType = "circleMarker123",
        stroke = FALSE, fillColor = "black", fillOpacity = 0.7,
        markerOptions = markerOptions(radius = 2)
      )
  )

  expect_error(
    leaflet() %>%
      addGeoJSONv2(
        geoJson,
        markerType = "circleMarker",
        stroke = FALSE, fillColor = "black", fillOpacity = 0.7,
        # markerOptions = markerOptions(radius = 2),
        markerIcons = "asd"
      )
  )
  ts <- leaflet() %>%
    addGeoJSONv2(
      geoJson,
      markerType = "circleMarker",
      stroke = FALSE, fillColor = "black", fillOpacity = 0.7,
      # markerOptions = markerOptions(radius = 2),
      markerIcons = iconList(
        red = makeIcon("leaf-red.png", iconWidth = 32, iconHeight = 32),
        green = makeIcon("leaf-green.png", iconWidth = 32, iconHeight = 32)
      )
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], geoJson)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "circleMarker")





  ts <- leaflet() %>%
    addBootstrapDependency() %>%
    setView(-75.14, 40, zoom = 11) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addGeoJSONChoropleth(
      topoJson,
      valueProperty = "incidents",
      scale = "OrRd", mode = "q", steps = 5,
      padding = c(0.2, 0),
      popupProperty = propsToHTML(
        props = c("dist_numc", "location", "incidents", "_feature_id_string")
      ),
      labelProperty = JS("function(feature){return \"WARD: \" + feature.properties.dist_numc;}"),
      color = "#ffffff", weight = 1, fillOpacity = 0.7,
      highlightOptions =
        highlightOptions(
          fillOpacity = 1, weight = 2, opacity = 1, color = "#000000",
          bringToFront = TRUE, sendToBack = TRUE
        ),
      legendOptions =
        legendOptions(title = "Crimes", position = "bottomright"),
      group = "orange-red"
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-choropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONChoropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], topoJson)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[2]])
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "orange-red")



  ts <- leaflet() %>%
    addGeoJSONChoropleth(
      topoJson,
      valueProperty = "incidents",
      popupProperty = propsToHTML(
        props = c("dist_numc")
      )
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-choropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONChoropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], topoJson)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[2]])

  ts <- leaflet() %>%
    addGeoJSONChoropleth(
      topoJson,
      valueProperty = "incidents",
      popupProperty = propsToHTML(
        props = c("dist_numc"), elem = "asdasd",
        elem.attrs = list(class = "some named list")
      )
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-choropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONChoropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], topoJson)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[2]])

  expect_error(leaflet() %>%
    addGeoJSONChoropleth(
      topoJson,
      valueProperty = "incidents",
      popupProperty = propsToHTML(props = 1)
    ))
  expect_error(leaflet() %>%
    addGeoJSONChoropleth(
      topoJson,
      valueProperty = "incidents",
      popupProperty = propsToHTML(
        props = "props1", elem = "asd", "asdasd"
      )
    ))



  ## KML Chlorpleth ###########################
  kml <- readr::read_file(
    system.file("examples/data/kml/cb_2015_us_state_20m.kml.zip", package = "leaflet.extras")
  )
  ts <- leaflet() %>%
    addBootstrapDependency() %>%
    setView(-98.583333, 39.833333, 4) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addKMLChoropleth(
      kml,
      valueProperty = JS(
        "function(feature){
             var props = feature.properties;
             var aland = props.ALAND/100000;
             var awater = props.AWATER/100000;
             return 100*awater/(awater+aland);
          }"
      ),
      scale = "OrRd", mode = "q", steps = 5,
      padding = c(0.2, 0),
      popupProperty = "description",
      labelProperty = "NAME",
      color = "#ffffff", weight = 1, fillOpacity = 1,
      highlightOptions = highlightOptions(
        fillOpacity = 1, weight = 2, opacity = 1, color = "#000000",
        bringToFront = TRUE, sendToBack = TRUE
      ),
      legendOptions = legendOptions(
        title = "% of Water Area",
        numberFormatOptions = list(
          style = "decimal",
          maximumFractionDigits = 2
        )
      )
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-choropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addKMLChoropleth")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], kml)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[2]])
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[3]])
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "NAME")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[6]], "description")


  ## addCSV ######################
  csv <- readr::read_file(
    system.file("examples/data/csv/world_airports.csv.zip", package = "leaflet.extras")
  )

  ts <- leaflet() %>%
    setView(0, 0, 2) %>%
    addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>%
    addCSV(
      csv,
      csvParserOptions("latitude_deg", "longitude_deg"),
      markerType = "circleMarker",
      stroke = FALSE, fillColor = "red", fillOpacity = 1,
      markerOptions = markerOptions(radius = 0.5)
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addCSV")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], csv)
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[2]])
  expect_null(ts$x$calls[[length(ts$x$calls)]]$args[[3]])
})
