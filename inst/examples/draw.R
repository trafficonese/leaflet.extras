library(leaflet.extras)

#+ fig.width=10, fig.height=8
leaflet() %>%
  setView(0,0,2) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addDrawToolbar(
    group='draw',
    editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))  %>%
  addLayersControl(overlayGroups = c('draw'), options =
                     layersControlOptions(collapsed=FALSE)) %>%
  addStyleEditor()

#' <br/><br/><br/>
