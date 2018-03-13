const path = require("path");
// const webpack = require('webpack');
var HtmlWebpackPlugin = require("html-webpack-plugin");

const src_path = "./inst/htmlwidgets/src/";
const build_path = path.resolve(__dirname, "./inst/htmlwidgets/build");

library_module = function(name) {
  return {
    rules: [
      {
        test: /\.(png|jpg|gif|svg|woff|woff2|eot|ttf|otf)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: name + "-[hash].[ext]"
            }
          }
        ]
      },
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"]
      }
    ]
  }
}


library_prod = function(name, filename = name, library = undefined) {
  filename = filename + "_prod"
  var ret = {
    mode: "production",
    entry: name,
    // devtool: "source-map",
    module: library_module(filename),
    output: {
      // library: library,
      filename: filename + ".js",
      path: build_path
    }
  }
  if (typeof library != 'undefined') {
    ret.output.library = library
  }
  return ret;
}
library_prod_externals = function(externals, ...info) {
  var ret = library_prod(...info);
  ret.externals = externals;
  return ret;
}

library_binding = function(name) {
  filename = name + "-bindings"
  return {
    entry: src_path + filename + ".js",
    output: {
      filename: filename + ".js",
      path: build_path
    },
    module: library_module(filename),
    // devtool: "source-map",
    devtool: "inline-source-map",
    mode: "development"
  }
}

const config = [

  // library_prod(LIBRARY, SAVE_NAME, GLOBAL_JS_VAR_NAME)

  // "@mapbox/leaflet-omnivore": "0.3.4",
  library_prod("csv2geojson", "csv2geojson", "csv2geojson"),
  library_prod("togeojson", "toGeoJSON", "toGeoJSON"),
  library_prod("topojson", "topojson", "topojson"),
  library_prod_externals({
    topojson: "topojson",
    csv2geojson: "csv2geojson",
    togeojson: "togeojson",
  }, "@mapbox/leaflet-omnivore", "leaflet-omnivore"),
  library_binding("omnivore"),

  // "Leaflet.Geodesic": "github:henrythasler/Leaflet.Geodesic#c5fe36b",
  library_prod("Leaflet.Geodesic", "leaflet-geodesic"),
  library_binding("geodesic"),

  // "leaflet-choropleth": "1.1.4",
  library_prod("leaflet-choropleth"),

  // "leaflet-draw": "1.0.2",
  // "leaflet-draw-drag": "1.0.2",
  library_prod(
    ["leaflet-draw", "leaflet-draw/dist/leaflet.draw.css"],
    "leaflet-draw"
  ),
  library_prod("leaflet-draw-drag"),
  library_binding("draw"),

  // "leaflet-fullscreen": "1.0.2",
  library_prod(
    ["leaflet-fullscreen", "leaflet-fullscreen/dist/leaflet.fullscreen.css"],
    "leaflet-fullscreen"
  ),

  // "leaflet-gps": "1.7.0",
  library_prod(
    ["leaflet-gps", "leaflet-gps/dist/leaflet-gps.min.css"],
    "leaflet-gps"
  ),

  // "leaflet-hash": "github:PowerPan/leaflet-hash#4020d13",
  library_prod("leaflet-hash/dist/leaflet-hash.min.js"),

  // "leaflet-measure-path": "1.3.1",
  library_prod(
    ["leaflet-measure-path", "leaflet-measure-path/leaflet-measure-path.css"],
    "leaflet-measure-path"
  ),
  library_binding("measure-path"),

  // "leaflet-plugins": "3.0.2",
  library_prod("leaflet-plugins/layer/tile/Bing.js", "tile-bing"),
    // For google support!!
    // "leaflet.gridlayer.googlemutant": "^0.6.4",

  // "leaflet-pulse-icon": "0.1.0",
  library_prod(
    ["leaflet-pulse-icon", "leaflet-pulse-icon/src/L.Icon.Pulse.css"],
    "leaflet-pulse-icon"
  ),
  library_binding("pulse-icon"),

  // "fuse.js": "3.2.0",
  // "leaflet-search": "2.3.7",
  library_prod("fuse.js", "fuse_js", "Fuse"),
  library_prod(
    ["leaflet-search", "leaflet-search/dist/leaflet-search.min.css"],
    "leaflet-search"
  ),

  // "leaflet-sleep": "0.5.1",
  library_prod("leaflet-sleep"),

  // "leaflet-webgl-heatmap": "0.2.7",
  library_prod(
    ["leaflet-webgl-heatmap", "leaflet-webgl-heatmap/src/leaflet-webgl-heatmap.js"],
    "leaflet-webgl-heatmap"
  ),
  library_binding("webgl-heatmap"),

  // "leaflet-wms-legend": "github:schloerke/leaflet-wms-legend#c97fde8",
  library_prod(
    ["leaflet-wms-legend", "leaflet-wms-legend/leaflet.wmslegend.css"],
    "leaflet-wms-legend"
  ),


  // "leaflet.heat": "0.2.0",
  // TODO!!! use distributed version from somewhere
  library_prod(src_path + "leaflet-heat.js", "leaflet-heat"),
  library_binding("heat"),

  // "leaflet.tilelayer.pouchdbcached": "0.3.0",
  library_prod("pouchdb", "pouchdb", "PouchDB"),
  library_prod("leaflet.tilelayer.pouchdbcached"),

  // "leaflet.weather-markers": "github:schloerke/Leaflet.weather-markers#a4389f1",
  library_prod(
    [
      "leaflet.weather-markers",
      "leaflet.weather-markers/dist/leaflet.weather-markers.css",
      src_path + "weather-icons/weather-icons.min.css",
      src_path + "weather-icons/weather-icons-wind.min.css"
    ],
    "leaflet.weather-markers"
  ),
  library_binding("weather-markers")



];

module.exports = config



// {
//   mode: "development",
//   entry: "leaflet.tilelayer.pouchdbcached",
//   output: {
//     filename: "leaflet.tilelayer.pouchdbcached-static.js",
//     path: build_path
//   },
//   module: {
//     rules: [
//       {
//         use: [ 'script-loader' ]
//       }
//     ]
//   }
// },

// {
//   entry: {
//     "omnivore": [
//       "@mapbox/leaflet-omnivore",
//       "./inst/htmlwidgets/src/omnivore-bindings.js",
//     ],
//     "tilelayer-cached": [
//       "pouchdb",
//       "./inst/htmlwidgets/lib/TileLayer.PouchDBCached/L.TileLayer.PouchDBCached.js"
//     ],
//     "measure-path": [
//       "leaflet-measure-path",
//       "./inst/htmlwidgets/src/measure-path-bindings.js",
//       "./inst/htmlwidgets/src/measure-path.css"
//     ],
//     "webgl-heatmap": [
//       "leaflet-webgl-heatmap",
//       "./inst/htmlwidgets/src/webgl-heatmap-bindings.js"
//     ]
//   },
//   output: {
//     filename: "[name].js",
//     library: "leaflet.extras",
//     path: path.resolve(__dirname, "./inst/htmlwidgets/build")
//   },
//   // plugins: [
//   //   new webpack.optimize.splitChunks({
//   //     name: 'leaflet.extras-common',
//   //     name: 'leaflet.extras-common-[hash].js'
//   //   })
//   // ],
//   // optimization: {
//   //   splitChunks: {
//   //     // chunks: "all"
//   //     cacheGroups: {
//   //   		commons: {
//   //   			name: "commons",
//   //   			chunks: "initial",
//   //   			minChunks: 2
//   //   		}
//   //   	}    }
//   // },
//   module: {
//     rules: [
//       {
//         test: /\.css$/,
//         use: ["style-loader", "css-loader"]
//       }
//     ]
//   },
//   // devtool: "inline-source-map",
//   devtool: "source-map",
//   mode: "development"
// }
