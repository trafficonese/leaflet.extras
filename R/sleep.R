sleepDependency <- function() {
  list(
    # // "leaflet-sleep": "0.5.1",
    html_dep_prod("lfx-sleep", "0.5.1")
  )
}

#' Prevents accidental map scrolling when scrolling in a document.
#' @rdname sleep
#' @param  map The leaflet map
#' @param  sleep false if you want an unruly map
#' @param  sleepTime time(ms) until map sleeps on mouseout
#' @param  wakeTime time(ms) until map wakes on mouseover
#' @param  sleepNote should the user receive wake instructions?
#' @param  hoverToWake should hovering wake the map? (non-touch devices only)
#' @param  wakeMessage a message to inform users about waking the map
#' @param  sleepOpacity opacity for the sleeping map
#' @export
#' @examples
#' leaflet(width = "100%") %>%
#'   setView(0, 0, 1) %>%
#'   addTiles() %>%
#'   suspendScroll()
suspendScroll <- function(
    map,
    sleep = TRUE,
    sleepTime = 750,
    wakeTime = 750,
    sleepNote = TRUE,
    hoverToWake = TRUE,
    wakeMessage = "Click or Hover to Wake",
    # sleepButton = "L.Control.sleepMapControl",
    sleepOpacity = .7) {
  sleepOptions <- list(
    sleep = sleep,
    sleepTime = sleepTime,
    wakeTime = wakeTime,
    sleepNote = sleepNote,
    hoverToWake = hoverToWake,
    wakeMessage = wakeMessage,
    # sleepButton = sleepButton,
    sleepOpacity = sleepOpacity
  )
  map$dependencies <- c(map$dependencies, sleepDependency())
  if (is.null(map$x$options)) {
    map$x$options <- list()
  }
  map$x$options <- c(map$x$options, sleepOptions)
  map
}
