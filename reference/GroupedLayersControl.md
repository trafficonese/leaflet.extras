# Methods of GroupedLayersControl

Add an overlay to the GroupedLayersControl

Add a baselayer to the GroupedLayersControl

Remove an overlay layer from the GroupedLayersControl

Removes the GroupedLayersControl from the map

## Usage

``` r
addGroupedOverlay(map, group, name, groupname)

addGroupedBaseLayer(map, group, name)

removeGroupedOverlay(map, group)

removeGroupedLayersControl(map)
```

## Arguments

- map:

  The map widget

- group:

  The group of the leaflet layer

- name:

  The visible name of the layer in the control

- groupname:

  The visible group name in the control

## See also

Other GroupedLayersControl:
[`addGroupedLayersControl()`](https://trafficonese.github.io/leaflet.extras/reference/addGroupedLayersControl.md),
[`groupedLayersControlOptions()`](https://trafficonese.github.io/leaflet.extras/reference/groupedLayersControlOptions.md)
