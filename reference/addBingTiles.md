# Adds Bing Tiles Layer

Adds Bing Tiles Layer

## Usage

``` r
addBingTiles(
  map,
  apikey = Sys.getenv("BING_MAPS_API_KEY"),
  imagerySet = c("Aerial", "AerialWithLabels", "AerialWithLabelsOnDemand",
    "AerialWithLabelsOnDemand", "Birdseye", "BirdseyeWithLabels", "BirdseyeV2",
    "BirdseyeV2WithLabels", "CanvasDark", "CanvasLight", "CanvasGray", "Road",
    "RoadOnDemand", "Streetside"),
  layerId = NULL,
  group = NULL,
  ...
)
```

## Arguments

- map:

  The Map widget

- apikey:

  String. Bing API Key

- imagerySet:

  String. Type of Tiles to display

- layerId:

  String. An optional unique ID for the layer

- group:

  String. An optional group name for the layer

- ...:

  Optional Parameters required by the Bing API described at
  <https://learn.microsoft.com/en-us/bingmaps/getting-started/bing-maps-dev-center-help/getting-a-bing-maps-key?redirectedfrom=MSDN>

## See also

Get a Bing Maps API Key:
<https://learn.microsoft.com/en-us/bingmaps/rest-services/imagery/get-imagery-metadata?redirectedfrom=MSDN>
