devtools::install_github("schloerke/viztest")
# source("scripts/viztest.R")


viztest::viztest(".", "leaflet.extras", resize = FALSE, stomp = TRUE)

# viztest::viztest(".", "bhaskarvk/leaflet.extras", resize = FALSE, stomp = TRUE, skip_old = TRUE)
