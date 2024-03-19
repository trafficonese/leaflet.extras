const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const ESLintPlugin = require('eslint-webpack-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');


const binding_path = './inst/htmlwidgets/bindings/';
const src_path = './inst/htmlwidgets/src/';
const build_path = path.resolve(__dirname, './inst/htmlwidgets/build');

const mode = 'production';
//const mode = "development";

const library_prod = function(name, filename = name, library = undefined) {
  const foldername = filename;
  filename = filename + '-prod';
  var ret = {
    mode: mode, // minify the files
    entry: name,
    devtool: false, // produce a sibling source map file
    externals: {
      // if 'leaflet' is required, pull from window.L
      leaflet: 'L',
    },
    optimization: {
      minimize: true,
      minimizer: [
        new TerserPlugin(),
        new CssMinimizerPlugin(),
      ]
    },
    module: {
      rules: [
        // copy files to destination folder who have these extensions
        {
          test: /\.(png|jpg|gif|svg|woff|woff2|eot|ttf|otf)$/,
          type: 'asset/resource'
        },
        // copy from https://github.com/webpack-contrib/mini-css-extract-plugin/tree/e307e251a476e24f3d1827e74e0434de52ce6ea3
        {
          test: /\.css$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader']
        },
      ]
    },
    plugins: [
      // copy from https://github.com/webpack-contrib/mini-css-extract-plugin/tree/e307e251a476e24f3d1827e74e0434de52ce6ea3
      new MiniCssExtractPlugin({
        filename: filename + '.css'
      })
    ],
    output: {
      // save to this javascript file
      filename: filename + '.js',
      // save all files in this folder
      path: build_path + '/' + foldername
    }
  };
  // if saving the module to something...
  if (typeof library != 'undefined') {
    // save the library as a variable
    // https://webpack.js.org/configuration/output/#output-library
    ret.output.library = library;
    // do not use 'var' in the assignment
    // https://webpack.js.org/configuration/output/#output-librarytarget
    ret.output.libraryTarget = 'assign';
  }
  return ret;
};
const add_externals = function(config, externals) {
  config.externals = Object.assign(config.externals, externals);
  return config;
};
const add_attachments = function(config, src, attachments, output_folder) {
  config.plugins = config.plugins.concat([
    new CopyWebpackPlugin({
      patterns: [{
        context: 'node_modules/' + src,
        from: attachments,
        to: build_path + '/' + output_folder
      }]
    })
  ]);
  return config;
};

const library_binding = function(name) {
  return {
    mode: mode, // minify everything
    devtool: false, // include external map file
    entry: binding_path + name + '-bindings.js',
    module: {
      rules: [
      ]
    },
    plugins: [
      new ESLintPlugin({
        // Specify the files/paths to lint.
        files: binding_path + name + '-bindings.js',
        // If you have an ESLint configuration file at a custom path, you can specify it here:
        context: path.resolve(__dirname, '.eslintrc.js'),
      }),
    ],
    // save bindings to build bindings folder
    output: {
      filename: name + '-bindings.js', // save file in path on next line
      path: build_path + '/' + name // save all files in this path
    }
  };
};


const config = [

  // library_prod(LIBRARY, SAVE_NAME, GLOBAL_JS_VAR_NAME)

  // "csv2geojson": "5.0.2",
  // "togeojson": "0.16.0",
  // "topojson": "3.0.2"
  library_prod('csv2geojson', 'csv2geojson', 'window.csv2geojson'),
  library_prod('@mapbox/togeojson', 'togeojson', 'window.toGeoJSON'),
  library_prod('topojson', 'topojson', 'topojson'),

  // "@mapbox/leaflet-omnivore": "0.3.4",
  add_externals(library_prod('@mapbox/leaflet-omnivore', 'lfx-omnivore'),
    {
      topojson: 'topojson',
      csv2geojson: 'csv2geojson',
      togeojson: 'toGeoJSON'
    }),
  library_binding('lfx-omnivore'),

  // "Leaflet.geodesic": "2.7.1",
  library_prod('leaflet.geodesic', 'lfx-geodesic'),
  library_binding('lfx-geodesic'),

  // "Leaflet.StyleEditor": "github:dwilhelm89/Leaflet.StyleEditor#24366b9"
  library_prod(['leaflet-styleeditor', 'leaflet-styleeditor/dist/css/Leaflet.StyleEditor.min.css'],
    'lfx-styleeditor'),
  library_binding('lfx-styleeditor'),

  // "leaflet-choropleth": "1.1.4",
  library_prod('leaflet-choropleth', 'lfx-choropleth'),

  // "leaflet-draw": "1.0.2",
  // "leaflet-draw-drag": "1.0.2",
  library_prod(['leaflet-draw', 'leaflet-draw/dist/leaflet.draw.css'],
    'lfx-draw'),
  library_prod('leaflet-draw-drag', 'lfx-draw-drag'),
  library_binding('lfx-draw'),

  library_prod(['leaflet-fullscreen', 'leaflet-fullscreen/dist/leaflet.fullscreen.css'],
    'lfx-fullscreen'),

  // "leaflet-gps": "1.7.0",
  library_prod(['leaflet-gps', 'leaflet-gps/dist/leaflet-gps.min.css'],
    'lfx-gps'),
  library_binding('lfx-gps'),

  // "leaflet-hash": "github:PowerPan/leaflet-hash#4020d13",
  library_prod('leaflet-hash/dist/leaflet-hash.min.js', 'lfx-hash'),

  // "leaflet-measure-path": "1.3.1",
  library_prod(['leaflet-measure-path', 'leaflet-measure-path/leaflet-measure-path.css'],
    'lfx-measure-path'),
  library_binding('lfx-measure-path'),

  // "leaflet-plugins": "3.0.2",
  library_prod('leaflet-plugins/layer/tile/Bing.js', 'tile-bing'),
  library_binding('tile-bing'),
  // For google support!!
  // "leaflet.gridlayer.googlemutant": "^0.6.4",

  // "leaflet-pulse-icon": "0.1.1",
  library_prod(['@ansur/leaflet-pulse-icon', '@ansur/leaflet-pulse-icon/dist/L.Icon.Pulse.css'],
    'lfx-pulse-icon'),
  library_binding('lfx-pulse-icon'),

  // "fuse.js": "3.2.0",
  // "leaflet-search": "2.3.7",
  library_prod('fuse.js', 'fuse_js', 'Fuse'),
  library_prod(['leaflet-search', 'leaflet-search/dist/leaflet-search.min.css'],
    'lfx-search'),
  library_binding('lfx-search'),

  // "leaflet-sleep": "0.5.1",
  library_prod('leaflet-sleep', 'lfx-sleep'),

  // "leaflet-webgl-heatmap": "0.2.7",
  add_attachments(library_prod(['webgl-heatmap/webgl-heatmap.js', 'leaflet-webgl-heatmap'],
    'lfx-webgl-heatmap'),
  'webgl-heatmap/',
  '*.png',
  'lfx-webgl-heatmap'),
  library_binding('lfx-webgl-heatmap'),

  // napa kartoza/leaflet-wms-legend#0f59578:leaflet-wms-legend
  library_prod(['leaflet-wms-legend/leaflet.wmslegend.js', 'leaflet-wms-legend/leaflet.wmslegend.css'],
    'lfx-wms-legend'),
  library_binding('lfx-wms-legend'),

  // "leaflet.heat": "0.2.0",
  //library_prod(src_path + "heat/leaflet-heat.js", "lfx-heat"),
  library_prod('leaflet-heat', 'lfx-heat'),
  library_binding('lfx-heat'),

  // "pouchdb-browser": "6.4.3",
  // "leaflet.tilelayer.pouchdbcached": "nikolauskrismer/Leaflet.TileLayer.PouchDBCached#a92b176",
  library_prod('pouchdb-browser/lib/index.js', 'pouchdb-browser', 'PouchDB'),
  library_prod('leaflet.tilelayer.pouchdbcached', 'lfx-tilelayer'),

  // napa tallsam/Leaflet.weather-markers#afda5b3:leaflet-weather-markers
  library_prod([
    'leaflet-weather-markers/dist/leaflet.weather-markers.js',
    'leaflet-weather-markers/dist/leaflet.weather-markers.css',
    src_path + 'weather-icons/weather-icons.min.css',
    src_path + 'weather-icons/weather-icons-wind.min.css'
  ],
  'lfx-weather-markers'),
  library_binding('lfx-weather-markers'),

  // "leaflet.BounceMarker": "github:maximeh/leaflet.bouncemarker#v1.1",
  library_prod('leaflet.BounceMarker', 'lfx-bouncemarker'),
  library_binding('lfx-bouncemarker'),


  library_binding('map-widget-style')



];

module.exports = config;
