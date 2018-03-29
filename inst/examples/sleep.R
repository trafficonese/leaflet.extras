library(leaflet.extras)

#' ## Suspend Map scrolling
#'
#' This helps when embedding leaflet in HTML pages using R Markdown, Bookdown,
#' blogdown or in HTML presentations. The map will not scroll unless you hover/click
#' it. This prevents unintentional map scrolling when scrolling the document.

leaflet(width = "100%") %>% setView(0, 0, 1) %>%
  addTiles() %>%
  suspendScroll()
