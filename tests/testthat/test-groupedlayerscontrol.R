library(testthat)
library(leaflet)
library(leaflet.extras)

test_that("Test addGroupedLayersControl", {
  # Basic functionality
  ts <- leaflet() %>%
    addTiles(group = "OpenStreetMap") %>%
    addProviderTiles("CartoDB", group = "CartoDB") %>%
    addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "red", group = "Markers2") %>%
    addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "green", group = "Markers1") %>%
    addGroupedLayersControl(
      baseGroups = c("OpenStreetMap", "CartoDB"),
      overlayGroups = list(
        "Layergroup_2" = c("Markers5", "Markers4"),
        "Layergroup_1" = c("Markers2", "Markers1", "Markers3")),
      position = "topright",
      options = groupedLayersControlOptions(groupCheckboxes = TRUE, collapsed = FALSE)
    )
  expect_s3_class(ts, "leaflet")
  expect_true(any(sapply(ts$dependencies, function(dep) dep$name == "lfx-groupedlayercontrol")))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGroupedLayersControl")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], c("OpenStreetMap", "CartoDB"))

  # Basic functionality
  ts <- leaflet() %>%
    addTiles(group = "OpenStreetMap") %>%
    addProviderTiles("CartoDB", group = "CartoDB") %>%
    addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "red", group = "Markers2") %>%
    addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42), color = "green", group = "Markers1") %>%
    addGroupedLayersControl(
      baseGroups = c("OpenStreetMap", "CartoDB"),
      overlayGroups = list(
        "Layergroup_2" = c("Markername5" = "Markers5", "Markername4" = "Markers4"),
        "Layergroup_1" = c("Markername2" = "Markers2", "Markername1" = "Markers1",
                           "Markername3" = "Markers3")),
      position = "topright",
      options = groupedLayersControlOptions(groupCheckboxes = TRUE, collapsed = FALSE)
    )
  expect_s3_class(ts, "leaflet")
  expect_true(any(sapply(ts$dependencies, function(dep) dep$name == "lfx-groupedlayercontrol")))
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGroupedLayersControl")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], c("OpenStreetMap", "CartoDB"))

  # Using different positions
  positions <- c("topright", "bottomright", "bottomleft", "topleft")
  for (pos in positions) {
    ts <- leaflet() %>%
      addGroupedLayersControl(position = pos)
    expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$position, pos)
  }

  # Options check
  ts <- leaflet() %>%
    addGroupedLayersControl(options = groupedLayersControlOptions(
      exclusiveGroups = "Layergroup_1",
      groupCheckboxes = FALSE,
      collapsed = TRUE
    ))
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$exclusiveGroups, "Layergroup_1")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$groupCheckboxes, FALSE)
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]]$collapsed, TRUE)

  ## Test groupedLayersControlOptions ###################
  # Default options
  opts <- groupedLayersControlOptions()
  expect_true(opts$groupCheckboxes)
  expect_true(opts$groupsCollapsable)
  expect_true(opts$collapsed)
  expect_true(opts$autoZIndex)

  # Custom options
  opts <- groupedLayersControlOptions(
    exclusiveGroups = "Layergroup_1",
    groupCheckboxes = FALSE,
    groupsCollapsable = FALSE,
    groupsExpandedClass = "custom-expanded-class",
    groupsCollapsedClass = "custom-collapsed-class",
    sortLayers = TRUE,
    sortGroups = TRUE,
    sortBaseLayers = TRUE,
    collapsed = FALSE,
    autoZIndex = FALSE
  )
  expect_identical(opts$exclusiveGroups, "Layergroup_1")
  expect_false(opts$groupCheckboxes)
  expect_false(opts$groupsCollapsable)
  expect_identical(opts$groupsExpandedClass, "custom-expanded-class")
  expect_identical(opts$groupsCollapsedClass, "custom-collapsed-class")
  expect_true(opts$sortLayers)
  expect_true(opts$sortGroups)
  expect_true(opts$sortBaseLayers)
  expect_false(opts$collapsed)
  expect_false(opts$autoZIndex)

  ## Test addGroupedOverlay ###################
  ts <- leaflet() %>%
    addGroupedOverlay(group = "Markers1", name = "Markers1 Layer", groupname = "MarkersGroup")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGroupedOverlay")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "Markers1 Layer")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[3]], "MarkersGroup")

  ## Test addGroupedBaseLayer ###################
  ts <- leaflet() %>%
    addGroupedBaseLayer(group = "Markers1", name = "Markers1 Base Layer")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "addGroupedBaseLayer")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[2]], "Markers1 Base Layer")

  ## Test removeGroupedOverlay ###################
  ts <- leaflet() %>%
    removeGroupedOverlay(group = "Markers1")
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeGroupedOverlay")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$args[[1]], "Markers1")

  ## Test removeGroupedLayersControl ###################
  ts <- leaflet() %>%
    removeGroupedLayersControl()
  expect_s3_class(ts, "leaflet")
  expect_identical(ts$x$calls[[length(ts$x$calls)]]$method, "removeGroupedLayersControl")
})
