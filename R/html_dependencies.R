html_dependency <- function(name, version, script, folder, ...) {
  htmltools::htmlDependency(
    name,
    version = version,
    system.file(folder, package = "leaflet.extras"),
    script = script,
    ...
  )
}

# match the npm version
html_dep_prod <- function(name, version, has_style = FALSE, has_binding = FALSE, ..., stylesheet = NULL) {
  if (isTRUE(has_style)) {
    if (missing(stylesheet)) {
      stylesheet <- paste0(name, "-prod.css")
    }
  }

  script <- paste0(name, "-prod.js")
  if (isTRUE(has_binding)) {
    script <- c(script, paste0(name, "-bindings.js"))
  }
  html_dependency(
    name, version,
    script,
    file.path("htmlwidgets", "build", name),
    all_files = TRUE,
    ...,
    stylesheet = stylesheet
  )
}

# should only be used if there is not prod file
# keep the version at the lastest release version where the bindings were updated
html_dep_binding <- function(name, version, ...) {
  html_dependency(
    name, version,
    paste0(name, "-bindings.js"),
    file.path("htmlwidgets", "build", name),
    all_files = FALSE,
    ...
  )
}
