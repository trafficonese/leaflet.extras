# html_dependency <- function(name, version, script) {
#   htmltools::htmlDependency(
#     name,
#     version = version,
#     system.file(file.path("htmlwidgets", "build"), package = "leaflet.extras"),
#     script = script,
#     ...
#   )
# }

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
html_dep_prod <- function(name, version, ...) {
  html_dependency(
    name, version,
    paste0(name, "-prod.js"),
    file.path("htmlwidgets", "build"),
    ...
  )
}

# keep the version at the lastest release version where the bindings were updated
html_dep_binding <- function(name, version, ...) {
  html_dependency(
    name, version,
    paste0(name, "-bindings.js"),
    file.path("htmlwidgets", "src", "bindings", name),
    ...
  )
}

# keep the version at the lastest release version where the bindings were updated
html_dep_util <- function(name, version, ...) {
  html_dependency(
    name, version,
    paste0(name, ".js"),
    file.path("htmlwidgets", "src", "utils", name),
    ...
  )
}
