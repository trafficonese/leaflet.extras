
[![R-CMD-check](https://github.com/trafficonese/leaflet.extras/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/trafficonese/leaflet.extras/actions/workflows/R-CMD-check.yaml)
[![Project Status: Active – The project is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Last-changedate](https://img.shields.io/badge/last%20change-2024--03--15-green.svg)](/commits/master)  
[![License:
GPL-3](https://img.shields.io/badge/License-GPLv3-yellow.svg)](https://opensource.org/licenses/GPL-3.0)
[![packageversion](https://img.shields.io/badge/Package%20version-1.0.0-orange.svg?style=flat-square)](commits/master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/leaflet.extras)](https://cran.r-project.org/package=leaflet.extras)
[![](http://cranlogs.r-pkg.org/badges/grand-total/leaflet.extras)](http://cran.rstudio.com/web/packages/leaflet.extras/index.html)
[![Codecov test
coverage](https://codecov.io/gh/trafficonese/leaflet.extras/branch/master/graph/badge.svg)](https://app.codecov.io/gh/trafficonese/leaflet.extras?branch=master)

## leaflet.extras

The goal of `leaflet.extras` package is to provide extra functionality
to the
[leaflet](https://cran.r-project.org/web/packages/leaflet/index.html) R
package using various [leaflet plugins](http://leafletjs.com/plugins).

### Installation

For CRAN version

``` r
install.packages('leaflet.extras')
```

For latest development version

``` r
# We need latest leaflet package from Github, as CRAN package is too old.
devtools::install_github('rstudio/leaflet')
devtools::install_github('bhaskarvk/leaflet.extras')
```

### Progress

Plugins integrated so far …

- [Pulse Icon](https://github.com/mapshakers/leaflet-icon-pulse)
- [Weather Markers](https://github.com/tallsam/Leaflet.weather-markers)
- [Leaflet Heat](https://github.com/Leaflet/Leaflet.heat)
- [webgl-heatmap](https://github.com/ursudio/webgl-heatmap-leaflet)
- [Tile
  Caching](https://github.com/MazeMap/Leaflet.TileLayer.PouchDBCached)
- [Leaflet Hash](https://github.com/mlevans/leaflet-hash)
- [Fullscreen Control](https://github.com/Leaflet/Leaflet.fullscreen)
- [WMS Legend](https://github.com/kartoza/leaflet-wms-legend)
- [Omnivore](https://github.com/mapbox/leaflet-omnivore): Allows adding
  data from various geospatial file formats.
  - GeoJSON
  - TopoJSON
  - KML
  - CSV
  - GPX
  - ~~WKT~~: Will not be implemented.
  - ~~Polyline~~: Will not be implemented.
- [Leaflet.Draw](https://github.com/Leaflet/Leaflet.draw) & [Style
  Editor](https://github.com/dwilhelm89/Leaflet.StyleEditor)
- [Leaflet.Geodesic](https://github.com/henrythasler/Leaflet.Geodesic)
- [Leaflet-measure-path](https://github.com/ProminentEdge/leaflet-measure-path)
- [Leaflet-search](https://github.com/stefanocudini/leaflet-search)
- [Leaflet-GPS](https://github.com/stefanocudini/leaflet-gps)
- [Leaflet.Sleep](https://github.com/CliffCloud/Leaflet.Sleep)
- [Bing Tiles](https://github.com/shramov/leaflet-plugins/tree/v2)
- [Bounce Marker](https://github.com/maximeh/leaflet.bouncemarker)

If you need a plugin that is not already implemented create an
[issue](https://github.com/trafficonese/leaflet.extras/issues/new). See
the [FAQ](#FAQ) section below for details.

### Documentation

The R functions have been documented using roxygen, and should provide
enough help to get started on using a feature. However some plugins have
lots of options and it’s not feasible to document every single detail.
In such cases you are encouraged to check the plugin’s documentation.

Currently there are no vignettes (contributions welcome), but there are
plenty of
[examples](https://github.com/trafficonese/leaflet.extras/tree/master/inst/examples)
available.

### FAQ

*I want to use a certain leaflet plugin not integrated so far.*

- **Good Solution**: Create issues for plugins you wish incorporated but
  before that search the existing issues to see if issue already exists
  and if so comment on that issue instead of creating duplicates.
- **Better Solution**: It would help in prioritizing if you can include
  additional details like why you need the plugin, how helpful will it
  be to everyone etc.
- **Best Solution**: Code it yourself and submit a pull request. This is
  the fastest way to get a plugin into the package.

*I submitted an issue for a plugin long time ago but it is still not
available.*

This package is being developed purely on a voluntary basis on spare
time without any monetary compensation. So the development progress can
stall at times. It may also not be possible to prioritize one-off
requests that no one else is interested in. Getting more people
interested in a feature request will help prioritize development. Other
option is to contribute code. That will get you added to the contributer
list and a thanks tweet.

*I found a bug.*

- **Good Solution**: Search existing issue list and if no one has
  reported it create a new issue.
- **Better Solution**: Along with issue submission provide a minimal
  reproducible code sample.
- **Best Solution**: Fix the issue and submit a pull request. This is
  the fastest way to get a bug fixed.

*I need a plugin which requires 1.x version of the leaflet JavaScript
library*

As of version 1.0.0, `leaflet.extras` supports leaflet.js version 1.x.

### Development

To make additions to the plugin dependencies, please add the plugin
using `npm`. Make sure it is compiled within the `webpack.config.js`.
Finally, make sure htmlwidgets finds it within your plugin’s dependency
function.

To build the latest version of the plugins, please make sure Node.js is
installed on your system, then run:

    npm install
    npm run build

### Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
