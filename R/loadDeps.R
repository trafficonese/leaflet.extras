.onAttach <- function(...) {
  packageStartupMessage("Also loading leaflet package")
  library(leaflet)
}
