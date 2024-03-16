iconSetToIcons <- function(x) {
  cols <- names(formals(makeIcon))
  cols <- structure(as.list(cols), names = cols)
  filterNULL(lapply(cols, function(col) {
    colVals <- unname(sapply(x, `[[`, col))
    if (length(unique(colVals)) == 1) {
      return(colVals[[1]])
    }
    else {
      return(colVals)
    }
  }))
}

b64EncodePackedIcons <- function (packedIcons) {
  if (is.null(packedIcons))
    return(packedIcons)
  packedIcons$data <- sapply(packedIcons$data, function(icon) {
    if (is.character(icon) && file.exists(icon)) {
      xfun::base64_uri(icon)
    }
    else {
      icon
    }
  }, USE.NAMES = FALSE)
  packedIcons
}

packStrings <- function (strings) {
  if (length(strings) == 0) {
    return(NULL)
  }
  uniques <- unique(strings)
  indices <- match(strings, uniques)
  indices <- indices - 1
  list(data = uniques, index = indices)
}


# getCrosstalkOptions <- function (data) {
#   if (is.SharedData(data)) {
#     list(ctKey = data$key(), ctGroup = data$groupName())
#   }
#   else {
#     NULL
#   }
# }
