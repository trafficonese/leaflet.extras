iconSetToIcons <- function(x) {
  cols <- names(formals(makeIcon))
  cols <- structure(as.list(cols), names = cols)
  filterNULL(lapply(cols, function(col) {
    colVals <- unname(sapply(x, `[[`, col))
    if (length(unique(colVals)) == 1) {
      return(colVals[[1]])
    } else {
      return(colVals)
    }
  }))
}

b64EncodePackedIcons <- function(packedIcons) {
  if (is.null(packedIcons)) {
    return(packedIcons)
  }
  packedIcons$data <- sapply(packedIcons$data, function(icon) {
    if (is.character(icon) && file.exists(icon)) {
      xfun::base64_uri(icon)
    } else {
      icon
    }
  }, USE.NAMES = FALSE)
  packedIcons
}

packStrings <- function(strings) {
  if (length(strings) == 0) {
    return(NULL)
  }
  uniques <- unique(strings)
  indices <- match(strings, uniques)
  indices <- indices - 1
  list(data = uniques, index = indices)
}


awesomeIconSetToAwesomeIcons <- function(x) {
  # c("icon", "library", ...)
  cols <- names(formals(makeAwesomeIcon))
  # list(icon = "icon", library = "library", ...)
  cols <- structure(as.list(cols), names = cols)

  # Construct an equivalent output to awesomeIcons().
  filterNULL(lapply(cols, function(col) {
    # Pluck the `col` member off of each item in awesomeIconObjs and put them in an
    # unnamed list (or vector if possible).
    colVals <- unname(sapply(x, `[[`, col))

    # If this is the common case where there's lots of values but they're all
    # actually the same exact thing, then just return one value; this will be
    # much cheaper to send to the client, and we'll do recycling on the client
    # side anyway.
    if (length(unique(colVals)) == 1) {
      return(colVals[[1]])
    } else {
      return(colVals)
    }
  }))
}

# getCrosstalkOptions <- function (data) {
#   if (is.SharedData(data)) {
#     list(ctKey = data$key(), ctGroup = data$groupName())
#   }
#   else {
#     NULL
#   }
# }
