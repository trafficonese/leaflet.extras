reachabilityDependencies <- function() {
  list(
    htmlDependency(
      "leaflet.reachability", "1.0.0",
      src = system.file("htmlwidgets/build/lfx-reachability", package = "leaflet.extras"),
      script = c("leaflet.reachability.js",
                 "leaflet.reachability.bindings.js"),
      stylesheet = "leaflet.reachability.css"
    )
  )
}

#' Add Isochrones to Leaflet
#'
#' @param map a map widget
#' @param apiKey a valid Openrouteservice API-key. Can be obtained from
#'   \href{https://openrouteservice.org/dev/#/signup}{Openrouteservice}
#' @param options see \code{\link{reachabilityOptions}}
#' @description Add Leaflet Reachability Plugin Control. Based on the
#'  \href{https://github.com/traffordDataLab/leaflet.reachability}{leaflet.reachability plugin}
#' @export
#' @family Reachability Plugin
addReachability <- function(map, apiKey = NULL,
                            options = reachabilityOptions()){

  map$dependencies <- c(map$dependencies, reachabilityDependencies())
  if (is.null(apiKey)) stop("You must provide an API Key")
  options = leaflet::filterNULL(c(apiKey = apiKey, options))

  invokeMethod(map, NULL, "addReachability", options)
}

#' reachabilityOptions
#'
#' @param collapsed Should the control widget start in a collapsed mode.
#'   Default is \code{TRUE}
#' @param pane Leaflet pane to add the isolines GeoJSON to.
#'   Default is \code{overlayPane}
#' @param position Leaflet control pane position. Default is \code{topleft}
#' @param ... Further arguments passed to `L.Control.Reachability`
#' @description Add extra options. For a full list please visit the
#' \href{https://github.com/traffordDataLab/leaflet.reachability}{plugin repository}
#' @export
#' @family Reachability Plugin
reachabilityOptions = function(collapsed = TRUE,
                               pane = "overlayPane",
                               position = "topleft",
                               ...) {
  filterNULL(list(
    collapsed = collapsed,
    pane = pane,
    position = position,
    ...
  ))
}

#' removeReachability
#' @param map the map widget.
#' @description Remove the reachability controls
#' @export
#' @family Reachability Plugin
removeReachability <- function(map){
  invokeMethod(map, NULL, "removeReachability")
}
