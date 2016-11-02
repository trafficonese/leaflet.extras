var L = require('leaflet')
var chroma = require('chroma-js')
var _ = {
  defaults: require('lodash/object/defaults'),
  extend: require('lodash/object/extend')
}

var topojson = require("topojson");

L.choroplethTopo = module.exports = function (geojson, opts) {
  if (geojson.type === "Topology") {
  	for (key in geojson.objects) {
  		geojson = topojson.feature(geojson, geojson.objects[key]);
  	}
  }
  opts = opts || {}

  // Set default options in case any weren't passed
  _.defaults(opts, {
    valueProperty: 'value',
    scale: ['white', 'red'],
    steps: 5,
    mode: 'q'
  })

  // Save what the user passed as the style property for later use (since we're overriding it)
  var userStyle = opts.style

  // Calculate limits
  var values = geojson.features.map(function (item) {
    if (typeof opts.valueProperty === 'function') {
      return opts.valueProperty(item)
    } else {
      return item.properties[opts.valueProperty]
    }
  })
  var limits = chroma.limits(values, opts.mode, opts.steps - 1)

  // Create color buckets
  var colors = opts.colors || chroma.scale(opts.scale).colors(opts.steps)

  return L.geoJson(geojson, _.extend(opts, {
    limits: limits,
    colors: colors,
    style: function (feature) {
      var style = {}
      var featureValue

      if (typeof opts.valueProperty === 'function') {
        featureValue = opts.valueProperty(feature)
      } else {
        featureValue = feature.properties[opts.valueProperty]
      }

      if (!isNaN(featureValue)) {
        // Find the bucket/step/limit that this value is less than and give it that color
        for (var i = 0; i < limits.length; i++) {
          if (featureValue <= limits[i]) {
            style.fillColor = colors[i]
            break
          }
        }
      }

      // Return this style, but include the user-defined style if it was passed
      switch (typeof userStyle) {
        case 'function':
          return _.extend(userStyle(), style)
        case 'object':
          return _.extend(userStyle, style)
        default:
          return style
      }
    }
  }))
}
