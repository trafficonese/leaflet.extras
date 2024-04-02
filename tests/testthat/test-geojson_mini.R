## DATA ###################
fName <- "https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson"
topoJson <- readr::read_file(fName)
geosonpointurl <- "https://rawgit.com/benbalter/dc-maps/master/maps/historic-landmarks-points.geojson"
geoJson <- readr::read_file(geosonpointurl)

historicLandmark <- makeAwesomeIcon(icon = "flag", library = "ion", markerColor = "green", iconColor = "black")

iconsList <- awesomeIconList(
  Designated = makeAwesomeIcon(icon = "glass", library = "fa", markerColor = "red"),
  Pending = makeAwesomeIcon(icon = "cutlery", library = "fa", markerColor = "blue")
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

  ts <- leaflet() %>%
    addTiles() %>%
    setView(-77.0369, 38.9072, 11) %>%
    addGeoJSONv2(
      geoJson,
      markerType = "marker",
      markerIcons = makeAwesomeIcon(icon = "glass", library = "fa", markerColor = "red"),
      markerOptions = markerOptions(radius = 2),
      clusterOptions = markerClusterOptions()
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "fontawesome")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "leaflet-markercluster")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 3]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], geoJson)
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2, 3, 6, 10, 11, 13, 16)]))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[4]], "marker")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]], makeAwesomeIcon(icon = "glass", library = "fa", markerColor = "red"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[7]], markerOptions(radius = 2))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[9]], markerClusterOptions())
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[12]], labelOptions())
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[14]], popupOptions())


  ts <- leaflet() %>%
    addTiles() %>%
    setView(-77.0369, 38.9072, 12) %>%
    addBootstrapDependency() %>%
    addGeoJSONv2(
      geosonpointurl,
      labelProperty = "LABEL",
      popupProperty = propstoHTMLTable(
        table.attrs = list(class = "table table-striped table-bordered"), drop.na = T
      ),
      labelOptions = labelOptions(textsize = "12px", direction = "auto"),
      markerIcons = historicLandmark,
      markerOptions = markerOptions(riseOnHover = TRUE, opacity = 1),
      clusterOptions = markerClusterOptions(), group = "Historic Landmarks"
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "ionicons")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "leaflet-markercluster")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 3]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], geosonpointurl)
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2, 4, 6, 10, 16)]))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "Historic Landmarks")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]], historicLandmark)
  expect_identical(class(ts$x$calls[[length(ts$x$calls)]]$args[[8]]), "JS_EVAL")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[7]], markerOptions(riseOnHover = TRUE, opacity = 1))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[9]], markerClusterOptions())
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[12]], labelOptions(textsize = "12px", direction = "auto"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[14]], popupOptions())


  ts <- leaflet() %>%
    addTiles() %>%
    setView(-77.0369, 38.9072, 12) %>%
    addBootstrapDependency() %>%
    addGeoJSONv2(
      geosonpointurl,
      labelProperty = "LABEL",
      popupProperty = propstoHTMLTable(
        table.attrs = list(class = "table table-striped table-bordered"), drop.na = T
      ),
      labelOptions = labelOptions(textsize = "12px", direction = "auto"),
      markerIcons = iconsList,
      markerIconProperty = "STATUS",
      markerOptions = markerOptions(riseOnHover = TRUE, opacity = 1),
      group = "Historic Landmarks"
    )
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$dependencies[[length(ts$dependencies)]]$name, "fontawesome")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 1]]$name, "leaflet-awesomemarkers")
  expect_identical(ts$dependencies[[length(ts$dependencies) - 2]]$name, "lfx-omnivore")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGeoJSONv2")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], geosonpointurl)
  expect_null(unlist(ts$x$calls[[length(ts$x$calls)]]$args[c(2, 4, 9, 10, 16)]))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "Historic Landmarks")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[5]], iconsList)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[6]], "STATUS")
  expect_identical(class(ts$x$calls[[length(ts$x$calls)]]$args[[8]]), "JS_EVAL")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[7]], markerOptions(riseOnHover = TRUE, opacity = 1))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[12]], labelOptions(textsize = "12px", direction = "auto"))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[14]], popupOptions())


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
