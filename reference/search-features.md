# Add a feature search control to the map.

Add a feature search control to the map.

Removes the feature search control from the map.

Clears the search marker

## Usage

``` r
addSearchFeatures(map, targetGroups, options = searchFeaturesOptions())

removeSearchFeatures(map, clearFeatures = FALSE)

clearSearchFeatures(map)
```

## Arguments

- map:

  a map widget object

- targetGroups:

  A vector of group names of groups whose features need to be searched.

- options:

  Search Options

- clearFeatures:

  Boolean. If TRUE the features that this control searches will be
  removed too.

## Value

modified map

modified map

modified map
