const path = require("path");
// const webpack = require('webpack');
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CopyWebpackPlugin = require('copy-webpack-plugin')

const src_path = "./inst/htmlwidgets/src/";
const lib_path = "./inst/htmlwidgets/lib/";
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
              name: name + "_css/" + name + "-[hash].[ext]"
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
  foldername = filename
  filename = filename + "-prod"
  var ret = {
    mode: "production",
    entry: name,
    // devtool: "source-map",
    module: library_module(foldername),
    output: {
      // library: library,
      filename: filename + ".js",
      path: build_path + "/" + foldername
    }
  }
  if (typeof library != 'undefined') {
    ret.output.library = library
  }
  return ret;
}
library_prod_css = function(version, name, filename, library = undefined) {
  var ret = library_prod(name, filename, library);
  ret.module = library_module(filename);
  ret.output.publicPath = "lib/" + filename + "-" + version + "/";
  return ret;
}
library_prod_externals = function(externals, ...info) {
  var ret = library_prod(...info);
  ret.externals = externals;
  return ret;
}
library_prod_attachements = function(attachments, output_folder, ...info) {
  var ret = library_prod(...info)
  ret.plugins = [
    new CopyWebpackPlugin(
      [{
        from: attachments,
        to: build_path + "/" + output_folder,
        flatten: true
      }]
    )
  ]
  return ret;
}

library_raw = function(entry, filename, foldername) {
  return {
    mode: "development",
    entry: entry,
    output: {
      filename: filename,
      path: build_path + "/" + foldername
    },
    module: {
      rules: [
        {use: "raw-loader"}
      ]
    }
  }

  // return {
  //   entry: entry,
  //   output: {
  //     filename: filename,
  //     path: build_path + "/" + foldername
  //   },
  //   module: library_module(filename),
  //   // devtool: "source-map",
  //   devtool: "inline-source-map",
  //   mode: "development"
  // }
}
library_binding = function(name) {
  var filename = name + "-bindings"
  var folder = "bindings"
  return library_raw(
    folder + "/" + filename + ".js",
    filename + ".js",
    name
  )
}

const config = [

  // library_prod(LIBRARY, SAVE_NAME, GLOBAL_JS_VAR_NAME)

  // library_raw(
  //   src_path + "utils/leaflet_extras-utils.js",
  //   "leaflet_extras-utils.js",
  //   "leaflet_extras-utils"
  // ),


  // "csv2geojson": "5.0.2",
  // "togeojson": "0.16.0",
  // "topojson": "3.0.2"
  library_prod("csv2geojson", "csv2geojson", "csv2geojson"),
  library_prod("togeojson", "togeojson", "toGeoJSON"),
  library_prod("topojson", "topojson", "topojson"),

  // "@mapbox/leaflet-omnivore": "0.3.4",
  library_prod_externals({
    topojson: "topojson",
    csv2geojson: "csv2geojson",
    togeojson: "toGeoJSON",
  }, "@mapbox/leaflet-omnivore", "leaflet-omnivore"),
  // library_binding("leaflet-omnivore"),

  // "Leaflet.Geodesic": "github:henrythasler/Leaflet.Geodesic#c5fe36b",
  library_prod("Leaflet.Geodesic", "leaflet-geodesic"),
  // library_binding("leaflet-geodesic"),

  // "Leaflet.StyleEditor": "github:dwilhelm89/Leaflet.StyleEditor#24366b9"
  library_prod_css(
    "0.1.6",
    ["Leaflet.StyleEditor", "Leaflet.StyleEditor/dist/css/Leaflet.StyleEditor.min.css"],
    "leaflet-styleeditor"
  ),
  // library_binding("leaflet-styleeditor"),


  // "leaflet-choropleth": "1.1.4",
  library_prod("leaflet-choropleth"),

  // "leaflet-draw": "1.0.2",
  // "leaflet-draw-drag": "1.0.2",
  library_prod_css(
    "1.0.2",
    ["leaflet-draw", "leaflet-draw/dist/leaflet.draw.css"],
    "leaflet-draw"
  ),
  library_prod("leaflet-draw-drag"),
  // library_binding("leaflet-draw"),

  // "leaflet-fullscreen": "1.0.2",
  library_prod_css(
    "1.0.2",
    ["leaflet-fullscreen", "leaflet-fullscreen/dist/leaflet.fullscreen.css"],
    "leaflet-fullscreen"
  ),

  // "leaflet-gps": "1.7.0",
  library_prod_css(
    "1.7.0",
    ["leaflet-gps", "leaflet-gps/dist/leaflet-gps.min.css"],
    "leaflet-gps"
  ),

  // "leaflet-hash": "github:PowerPan/leaflet-hash#4020d13",
  library_prod("leaflet-hash/dist/leaflet-hash.min.js", "leaflet-hash"),

  // "leaflet-measure-path": "1.3.1",
  library_prod_css(
    "1.3.1",
    ["leaflet-measure-path", "leaflet-measure-path/leaflet-measure-path.css"],
    "leaflet-measure-path"
  ),
  // library_binding("leaflet-measure-path"),

  // "leaflet-plugins": "3.0.2",
  library_prod("leaflet-plugins/layer/tile/Bing.js", "tile-bing"),
  // library_binding("tile-bing"),
    // For google support!!
    // "leaflet.gridlayer.googlemutant": "^0.6.4",

  // "leaflet-pulse-icon": "0.1.0",
  library_prod_css(
    "0.1.0",
    ["leaflet-pulse-icon", "leaflet-pulse-icon/src/L.Icon.Pulse.css"],
    "leaflet-pulse-icon"
  ),
  // library_binding("leaflet-pulse-icon"),

  // "fuse.js": "3.2.0",
  // "leaflet-search": "2.3.7",
  library_prod("fuse.js", "fuse_js", "Fuse"),
  library_prod_css(
    "2.3.7",
    ["leaflet-search", "leaflet-search/dist/leaflet-search.min.css"],
    "leaflet-search"
  ),
  // library_binding("leaflet-search"),

  // "leaflet-sleep": "0.5.1",
  library_prod("leaflet-sleep"),

  // "leaflet-webgl-heatmap": "0.2.7",
  library_prod_attachements(
    "node_modules/webgl-heatmap/*.png",
    "leaflet-webgl-heatmap",
    ["webgl-heatmap/webgl-heatmap.js", "leaflet-webgl-heatmap"],
    "leaflet-webgl-heatmap"
  ),
  // library_binding("leaflet-webgl-heatmap"),

  // napa kartoza/leaflet-wms-legend#0f59578:leaflet-wms-legend
  library_prod_css(
    "0.0.1",
    ["leaflet-wms-legend/leaflet.wmslegend.js", "leaflet-wms-legend/leaflet.wmslegend.css"],
    "leaflet-wms-legend"
  ),


  // "leaflet.heat": "0.2.0",
  // TODO!!! use distributed version from somewhere
  library_prod(lib_path + "heat/leaflet-heat.js", "leaflet-heat"),
  // library_binding("leaflet-heat"),

  // "pouchdb": "6.4.3",
  // "leaflet.tilelayer.pouchdbcached": "0.3.0",
  library_prod("pouchdb", "pouchdb", "PouchDB"),
  library_prod("leaflet.tilelayer.pouchdbcached", "leaflet-tilelayer-pouchdbcached"),

  // napa tallsam/Leaflet.weather-markers#afda5b3:leaflet-weather-markers
  library_prod_css(
    "3.0.0",
    [
      "leaflet-weather-markers/dist/leaflet.weather-markers.js",
      "leaflet-weather-markers/dist/leaflet.weather-markers.css",
      lib_path + "weather-icons/weather-icons.min.css",
      lib_path + "weather-icons/weather-icons-wind.min.css"
    ],
    "leaflet-weather-markers"
  ),
  // library_binding("leaflet-weather-markers")



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
