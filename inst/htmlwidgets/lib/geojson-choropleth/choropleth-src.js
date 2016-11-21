var L = require('leaflet');
var chroma = require('chroma-js');
var _ = {
  defaults: require('lodash/object/defaults'),
  extend: require('lodash/object/extend'),
};

// determine the value for a polygon
// valueProperty can be a simple property name or
// a function that accepts a feature and returns a value.
function getValue(feature, valueProperty) {
  return (typeof valueProperty === 'function' ? 
    valueProperty(feature) : feature.properties[valueProperty]);
}

// returns a function that will set the color for each polygon
function styleFunction(self) {
  return function styleFeature(feature) {

    var style = {};
    var featureValue = getValue(feature, self._options.valueProperty);

    if (!isNaN(featureValue)) {
      // Find the bucket/step/limit that self value is less than and give it that color
      // skip the first value of the limits that's the min value of our range.
      var upperLimit;
      for (var i = 1; i < self._limits.length; i++) {
        upperLimit = i === (self._limits.length-1) ? (self._limits[i] + 1) : self._limits[i];
        if (featureValue < upperLimit) {
          style.fillColor = self._colors[i-1];
          break;
        }
      }
    }

    // Return self style, but include the user-defined style if it was passed
    switch (typeof self._userStyle) {
      case 'function':
        return _.extend(self._userStyle(), style);
      case 'object':
        return _.extend(self._userStyle, style);
      default:
        return style;
    }
  };
}


// Main Class extends L.GeoJSON
// geojson can be null, and the data can be set later on using setGeoJSON()
L.GeoJSONChoropleth = L.GeoJSON.extend({
  initialize: function(geojson, options, legendOptions) {

    var self = this;

    options = options || {}

    // Set default options in case any weren't passed
    // See https://gka.github.io/chroma.js/ for details
    _.defaults(options, {
      valueProperty: 'value',
      scale: ['white', 'red'],
      steps: 5,
      mode: 'q',
      channelMode: 'rgb',
      padding: false,
      correctLightness: false,
      bezierInterpolate: false
    });

    // save options
    self._options = options;

    // Save what the user passed as the style property for later use (since we're overriding it)
    self._userStyle = options.style

    // Create color buckets
    var cols = options.colors;
    if(!cols) {
      if(options.bezierInterpolate) {
        cols = chroma.bezier(options.scale).scale();
      } else {
        cols = chroma.scale(options.scale);
        cols = options.channelMode !== 'rgb' ? cols.mode(options.channelMode) : cols ; //rgb is default.
        cols = options.correctLightness ? cols.correctLightness() : cols;
      }
      cols = options.padding ?
        cols.padding(options.padding).colors(options.steps) : cols.colors(options.steps);
    }
    self._colors = cols;

    // will be calculated when data is added
    // the geojson data can be added later on
    self._limits = null;

    // Check if we need to create a legend
    if(!$.isEmptyObject(legendOptions)) {

      var formatOptions = {}, // formatting of number range
        legendTitle = null, // title for the legend
        highlightStyle = null, // style used to highlight matching polygons on hover
        resetStyle = null; // style to reset back to, can be null
      if(legendOptions.formatOptions) {
        formatOptions = legendOptions.formatOptions;
        delete legendOptions.formatOptions;
      }
      if(legendOptions.title) {
        legendTitle = legendOptions.title;
        delete legendOptions.title;
      }
      if(legendOptions.highlightStyle) {
        highlightStyle = legendOptions.highlightStyle;
        delete legendOptions.highlightStyle;
      }
      if(legendOptions.resetStyle) {
        resetStyle = legendOptions.resetStyle;
        delete legendOptions.resetStyle;
      }

      // default formatting of the numbers
      _.defaults(formatOptions, {
        locale: 'en-US',
        options: {
          style: 'decimal',
          maximumFractionDigits : 2
        }
      })

      self._legend = L.control(legendOptions);
      self._legend.formatOptions = formatOptions;
      self._legend.title = legendTitle;
      self._legend.highlightStyle = highlightStyle;
      self._legend.resetStyle = resetStyle;
    }

    // proceed on to L.GeoJSON's initialize call, but
    // don't pass the geojson object yet because
    // we haven't called setGeoJSON yet
    L.GeoJSON.prototype.initialize.call(self, null,
      _.extend(self._options,{style: styleFunction(this)}));
    
    // call setGeoJSON in case geojson was provided 
    // else it will have to be called manually later.
    if(geojson) {
      self.setGeoJSON(geojson);
    }

  },
  onAdd: function(map) {
    var self = this;

    L.LayerGroup.prototype.onAdd.call(self, map);

    if(self._legend) {
      // add Legend to map only if limits are calculated, else just store the map.
      // this allows the legend to be added when actual data is added to the layer.
      if(self._legend.onAdd) {
        self._legend.addTo(map);
      } else {
        self._legend._map = map;
      }
    }
  },
  onRemove: function(map) {
    var self = this;
    if(self._legend) {
      self._legend.removeFrom(map);
    }
    L.LayerGroup.prototype.onRemove.call(self, map);
  },
  setGeoJSON: function(geojson) {
    var self = this;
		var features = L.Util.isArray(geojson) ? geojson : geojson.features;
    
    var values = features.map(function (feature) {
      return getValue(feature, self._options.valueProperty);
    });

    // Notes that our limits array has 1 more element than our colors arrary
    // this is because the limits denote a range and colors correspond to the range.
    // So if your limits are [0, 10, 20, 30], you'll have 3 colors one for each range 0-9, 10-19, 20-30
    self._limits = chroma.limits(values, self._options.mode, self._options.steps)
    //
    // Add the geojson to L.GeoJSON object so that our geometries are initialized.
    L.GeoJSON.prototype.addData.call(self, geojson);

    
    // Calculate legend items and add legend if needed
    if(self._legend) {

      var legendTitle = self._legend.title,
        locale = self._legend.formatOptions.locale,
        localeOptions = self._legend.formatOptions.options,
        highlightStyle = self._legend.highlightStyle,
        resetStyle = self._legend.resetStyle;

      self._legend.onAdd = function (map) {

        var div = L.DomUtil.create('div', 'info legend');
        if(legendTitle) {
          var title = document.createElement("div");
          title.style={};
          title.style['font-weight'] = "bold";
          title.appendChild(document.createTextNode(legendTitle));
          div.appendChild(title);
        }

        for (var i = 0; i < (self._limits.length-1); i++) {
          var from, to, span, color, text;
          from = self._limits[i];
          // Slightly increase the last value so that we can use from >= featureValue < to
          to = i === (self._limits.length-2) ? (self._limits[i+1] + 1) : self._limits[i+1];
          
          span = document.createElement("span");
          span.classList.add("legendItem");
          span.id = L.stamp(span); // unique id for each legend item.
          span.dataset.from = from;
          span.dataset.to = to;

          color = document.createElement("i");
          color.style.background = self._colors[i];
          color.style.border = "solid 0.5px #666";

          textSpan = document.createElement("span");
          text = document.createTextNode(
            from.toLocaleString(locale, localeOptions) + ' - ' +
              to.toLocaleString(locale, localeOptions) );
          textSpan.appendChild(text);

          span.appendChild(color);
          span.appendChild(textSpan);

          div.appendChild(span);
          div.appendChild(document.createElement("br"));


          if(!$.isEmptyObject(highlightStyle)) {

            self.eachLayer(function (layer) {
              var featureValue = getValue(layer.feature, self._options.valueProperty);
              if (featureValue >= from  && featureValue < to) {
                layer._legendItemId = span.id; 
                if(!layer._highlightLegendItem) {
                  layer._highlightLegendItem = true;
                  layer.on({
                    mouseover: function(e) {
                      document.getElementById(e.target._legendItemId).style['font-weight'] = 'bold';
                    },
                    mouseout: function(e) {
                       document.getElementById(e.target._legendItemId).style['font-weight'] = 'normal';
                    }
                  });
                }
              }
            });

            span.addEventListener("mouseover", function (event) {
              var span = event.currentTarget,
                from = span.dataset.from,
                to = span.dataset.to;

              span.style['font-weight'] = 'bold';

              self.eachLayer(function (layer) {
                var featureValue = getValue(layer.feature, self._options.valueProperty);

                if(span.id === layer._legendItemId) {
                    layer.setStyle(highlightStyle);
                    if(highlightStyle.bringToFront) {
                      layer.bringToFront();
                    }
                  }
              });
            });
            span.addEventListener("mouseout", function (event) {
              var span = event.currentTarget,
                from = span.dataset.from,
                to = span.dataset.to;
              
              span.style['font-weight'] = 'normal';

              self.eachLayer(function (layer) {

                var featureValue = getValue(layer.feature, self._options.valueProperty);

                if(span.id === layer._legendItemId) {
                    if(!$.isEmptyObject(resetStyle)) {
                      layer.setStyle(resetStyle);
                    } else {
                      self.resetStyle(layer);
                    }
                    if(highlightStyle.sendToBack) {
                      layer.bringToBack();
                    }
                  }
              });
            });
          }
        }

        return div;
      };
      // depending on how the GeoJSON data is supplied the map may or maynot be present at this time.
      if(self._legend._map) {
        self._legend.addTo(self._legend._map);
      }
    }
  }
});

L.choropleth = module.exports = function (geojson, options, legendOptions) {
	return new L.GeoJSONChoropleth(geojson, options, legendOptions);
};
