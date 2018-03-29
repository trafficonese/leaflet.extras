# leaflet.extras 1.0.0

## leaflet.js

- `leaflet.extras` depends upon `leaflet` (>= 2.0.0). As of `leaflet` 2.0.0, it is built using `leaflet.js` version 1.3.1.  All plugins have been updated to their latest compatible version of `leaflet.js` v1.3.1.
- All javascript dependencies have been updated to the latest stable release.
  - @mapbox/leaflet-omnivore@0.3.4 - https://github.com/mapbox/leaflet-omnivore
  - @mapbox/togeojson@0.16.0 - https://github.com/mapbox/togeojson
  - Leaflet.Geodesic@1.1.0 - https://github.com/henrythasler/Leaflet.Geodesic
  - Leaflet.StyleEditor@0.1.6 - https://github.com/dwilhelm89/Leaflet.StyleEditor
  - csv2geojson@5.0.2 - https://github.com/mapbox/csv2geojson
  - fuse.js@3.2.0 - https://github.com/krisk/Fuse
  - leaflet-choropleth@1.1.2 - https://github.com/timwis/leaflet-choropleth
  - leaflet-draw-drag@0.4.5 - https://github.com/w8r/Leaflet.draw.drag
  - leaflet-draw@0.4.14 - https://github.com/Leaflet/Leaflet.draw
  - leaflet-draw@1.0.2 - https://github.com/Leaflet/Leaflet.draw
  - leaflet-fullscreen@1.0.2 - https://github.com/Leaflet/Leaflet.fullscreen
  - leaflet-gps@1.7.0 - https://github.com/stefanocudini/leaflet-gps
  - leaflet-hash@1.0.1 - https://github.com/PowerPan/leaflet-hash
  - leaflet-measure-path@1.3.1 - https://github.com/perliedman/leaflet-measure-path
  - leaflet-plugins@3.0.2 - https://github.com/shramov/leaflet-plugins
  - leaflet-pulse-icon@0.1.0 - https://github.com/mapshakers/leaflet-icon-pulse
  - leaflet-search@2.3.7 - https://github.com/stefanocudini/leaflet-search
  - leaflet-sleep@0.5.1 - https://github.com/CliffCloud/Leaflet.Sleep
  - leaflet-webgl-heatmap@0.2.7 - https://github.com/ursudio/webgl-heatmap-leaflet
  - leaflet.BounceMarker@1.0.0 - https://github.com/maximeh/leaflet.bouncemarker
  - leaflet.heat@0.2.0 - https://github.com/Leaflet/Leaflet.heat
  - leaflet.tilelayer.pouchdbcached@0.4.0 - https://github.com/MazeMap/Leaflet.TileLayer.PouchDBCached
  - pouchdb-browser@6.4.3 - https://github.com/pouchdb/pouchdb
  - topojson@1.6.26 - https://github.com/mbostock/topojson
  - topojson@3.0.2 - https://github.com/topojson/topojson



## leaflet-omnivore

- [Leaflet.label](https://github.com/Leaflet/Leaflet.label/blob/0a4e3a6422c9e5a799a9cde106de5bcfdb5ab741/README.md#upgrade-path-to-ltooltip) has updated to v1.x of leaflet.js changing default behavior. Mainly... "bindLabel, openLabel and so should be replaced by bindTooltip, openTooltip, etc".

## New Features

- [Bing Tiles](https://github.com/shramov/leaflet-plugins/tree/v2)

- [Bounce Markers](https://github.com/maximeh/leaflet.bouncemarker)

## Improvements

- Major Changes to search

# leaflet.extras 0.2

## Bug Fixes

- Fixed #86
- Made CRAN Ready #87 (Thanks @timelyportfolio!)

# leaflet.extras 0.1.9009

## Bug Fixes

- Fixed #61 by merging #62 (Thanks @RCura!)
- Upgraded Draw Plugin now supports clearing all features. Fixes #55.

# leaflet.extras 0.1.9008

## New Features

* Another option for heatmaps via [Leaflet.heat](https://github.com/Leaflet/Leaflet.heat)
* Also fixed gradientTexture option of WebGLHeatmap.

# leaflet.extras 0.1.9007

## New Features

* Ability to suspend scrolling using [Leaflet.Sleep](https://github.com/CliffCloud/Leaflet.Sleep)

# leaflet.extras 0.1.9006

## Improvements

* Major performance boost to addWebGLHeatmap function. Closes #42.

# leaflet.extras 0.1.9004

## New Features

* Added support for [Leaflet-GPS](https://github.com/stefanocudini/leaflet-gps).

# leaflet.extras 0.1.9003

## New Features

* Added support for [Leaflet-search](https://github.com/stefanocudini/leaflet-search) plugin. Contributed by [Bangyou Zheng](https://github.com/bhaskarvk/leaflet.extras/pull/15).

# leaflet.extras 0.1.9002

## New Features

* Added support for [Leaflet-measure-path](https://github.com/ProminentEdge/leaflet-measure-path) plugin.

# leaflet.extras 0.1.9001

## New Features

* Switched to x.y.zzzz naming for the package version.
* Added support for editing existing shapes with the draw toobar.

# leaflet.extras 0.1.9

## New Features

* Added support for [Leaflet.Draw](https://github.com/Leaflet/Leaflet.draw) plugin.
* Added support of [Style Editor](https://github.com/dwilhelm89/Leaflet.StyleEditor) plugin.

# leaflet.extras 0.1.8

## New Features

* Added support for GPX Files

## Improvements

* Streamlined entire GeoJSON handling code
* Now you can add GeoJSON/TopoJSON/GPX/KML/CSV point and polygon data.

# leaflet.extras 0.1.7

## New Features

* Added support for automatic legend with bi-directional highlighting to Choropleths.

# leaflet.extras 0.1.6

## New Features

* Added KML/CSV support and more examples of handling geojson/topojson/kml data.

# leaflet.extras 0.1.5

## New Features

* Added addGeoJSONv2 for better GeoJSON support.

## Improvements

* Refactored GeoJSON/TopoJSON Chropleths.

# leaflet.extras 0.1.4

## New Features

* Added addTopoJSONChoropleth (Thanks [TrantorM](https://github.com/TrantorM)).

## Improvements

* GeoJSON/TopoJSON Choropleth now accepts popupOptions, labelOptions, and highlightOptions.

# leaflet.extras 0.1.3

## New Features

* Added [WMS Legend](https://github.com/kartoza/leaflet-wms-legend) Control.

# leaflet.extras 0.1.2

## New Features

* Added [Leaflet Hash](https://github.com/mlevans/leaflet-hash) Plugin for bookmarkable/sharable URLs.

# leaflet.extras 0.1.1

## New Features

* Added [Tile Caching](https://github.com/MazeMap/Leaflet.TileLayer.PouchDBCached) ability

# leaflet.extras 0.1.0

## New Features

* Added [webgl-heatmap](https://github.com/ursudio/webgl-heatmap-leaflet) plugin
* Added [geojson-choropleth](https://github.com/bhaskarvk/leaflet-choropleth) plugin
* Added [Weather Markers](https://github.com/tallsam/Leaflet.weather-markers) plugin
* Added [Pulse Icon](https://github.com/mapshakers/leaflet-icon-pulse) plugin
