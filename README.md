# leaflet.extras

The goal of leaflet.extras is to provide extra functionality to the [leaflet](https://cran.r-project.org/web/packages/leaflet/index.html) R package using various [leaflet plugins](http://leafletjs.com/plugins).

### Installation

```r
# We need latest leaflet package from Github, as CRAN package is too old.
devtools::install_github('rstudio/leaflet')
devtools::install_github('bhaskarvk/leaflet.extras')
```

### Progress

Plugins integrated so far ...

- [Pulse Icon](https://github.com/mapshakers/leaflet-icon-pulse): Demo at [Rpubs - Pulse Icons](http://rpubs.com/bhaskarvk/leaflet-pulseIcon)
- [Weather Markers](https://github.com/tallsam/Leaflet.weather-markers): Demo at [Rpubs - Weather Icons](http://rpubs.com/bhaskarvk/leaflet-weather)
- [Leaflet Heat](https://github.com/Leaflet/Leaflet.heat): Demo at [Rpubs - Heatmaps](http://rpubs.com/bhaskarvk/leaflet-heat)
- [webgl-heatmap](https://github.com/ursudio/webgl-heatmap-leaflet): Demo at [Rpubs - Heatmap](http://rpubs.com/bhaskarvk/leaflet-heatmap)
- [Tile Caching](https://github.com/MazeMap/Leaflet.TileLayer.PouchDBCached): Demo at [Rpubs - Tile Caching](http://rpubs.com/bhaskarvk/TileLayer-Caching)
- [Leaflet Hash](https://github.com/mlevans/leaflet-hash)
- [Fullscreen Control](https://github.com/Leaflet/Leaflet.fullscreen)
- [WMS Legend](https://github.com/kartoza/leaflet-wms-legend)
- [Omnivore](https://github.com/mapbox/leaflet-omnivore)
    * GeoJSON: Demo at [Rpubs - GeoJSON](http://rpubs.com/bhaskarvk/geojsonv2)
    * TopoJSON: Demo at [Rpubs - TopoJSON](http://rpubs.com/bhaskarvk/topojsonv2)
    * KML: Demo at [Rpubs - KML](http://rpubs.com/bhaskarvk/kml)
    * CSV: Demo at [Rpubs - CSV](http://rpubs.com/bhaskarvk/csv)
    * GPX: Demo at [Rpubs - GPX](http://rpubs.com/bhaskarvk/gpx)
    * ~~WKT~~: Will not be implemented.
    * ~~Polyline~~: Will not be implemented.
- [Leaflet.Draw](https://github.com/Leaflet/Leaflet.draw) & [Style Editor](https://github.com/dwilhelm89/Leaflet.StyleEditor): Demo at [Rpubs: leaflet-draw](http://rpubs.com/bhaskarvk/leaflet-draw)
- [Leaflet.Geodesic](https://github.com/henrythasler/Leaflet.Geodesic): Demo at [Rpubs: Geodesic Lines](http://rpubs.com/bhaskarvk/geodesic)
- [Leaflet-measure-path](https://github.com/ProminentEdge/leaflet-measure-path): Demo at [Rpubs: Measure Path](http://rpubs.com/bhaskarvk/measure-path)
- [Leaflet-search](https://github.com/stefanocudini/leaflet-search): Demo at [Rpubs: Leaflet Search](http://rpubs.com/bhaskarvk/leaflet-search)
- [Leaflet-GPS](https://github.com/stefanocudini/leaflet-gps)
- [Leaflet.Sleep](https://github.com/CliffCloud/Leaflet.Sleep): Demo at [Rpubs: Suspended Scrolling](http://rpubs.com/bhaskarvk/suspended-scroll)

If you need a plugin that is not already implemented create an [issue](https://github.com/bhaskarvk/leaflet.extras/issues/new).

### Documentation

The R functions have been documented using roxygen, and as such should provide enough help to get started on using a feature. However some plugins have lots of options and it's not feasible to document every single detail, so you are encouraged to check the plugin's documentation. 

Currently there are no vignettes (contributions welcome), but there are plenty of [examples](https://github.com/bhaskarvk/leaflet.extras/tree/master/inst/examples) available. 

### Contributing

Here are several ways in which you can help. Please consult the [Code of Conduct](CONDUCT.md).

- Create issues for plugins you wish incorporated. It would help in prioritizing if you can include additional details like why you need the plugin, how helpful will it be to everyone etc.
- Submit pull requests by incorporating plugins on your own.
- Spreading awareness about the package and showcasing your use via social media, blog posts, presentations etc.

