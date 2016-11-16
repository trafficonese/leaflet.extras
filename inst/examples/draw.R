library(leaflet.extras)

leaflet() %>%
  setView(0,0,2) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addDrawToolbar(
    group='draw',
    editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))  %>%
  addLayersControl(overlayGroups = c('draw'), options =
                     layersControlOptions(collapsed=FALSE))
