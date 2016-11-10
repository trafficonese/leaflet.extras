var L = require('leaflet');
var chroma = require('chroma-js');
var _ = {
  defaults: require('lodash/object/defaults'),
  extend: require('lodash/object/extend'),
  core: require('lodash')
};

function styleFunction(self) {
  return function styleFeature(feature) {

    var style = {};
    var featureValue;

    if (typeof self._options.valueProperty === 'function') {
      featureValue = self._options.valueProperty(feature)
    } else {
      featureValue = feature.properties[self._options.valueProperty]
    }

    if (!isNaN(featureValue)) {
      // Find the bucket/step/limit that self value is less than and give it that color
      for (var i = 0; i < self._limits.length; i++) {
        if (featureValue <= self._limits[i]) {
          style.fillColor = self._colors[i]
          break
        }
      }
    }

    // Return self style, but include the user-defined style if it was passed
    switch (typeof self._userStyle) {
      case 'function':
        return _.extend(self._userStyle(), style)
      case 'object':
        return _.extend(self._userStyle, style)
      default:
        return style
    }
  }
}

L.GeoJSONChoropleth = L.GeoJSON.extend({
  initialize: function(geojson, options, legendOptions) {

    var self = this;

    options = options || {}

    // Set default options in case any weren't passed
    _.defaults(options, {
      valueProperty: 'value',
      scale: ['white', 'red'],
      steps: 5,
      mode: 'q'
    });

    // save options
    self._options = options;

    // Save what the user passed as the style property for later use (since we're overriding it)
    self._userStyle = options.style

    // Create color buckets
    self._colors = options.colors || chroma.scale(options.scale).colors(options.steps)

    // will be calculated when data is added
    self._limits = null;

    if(!$.isEmptyObject(legendOptions)) {

      var formatOptions = {},
        legendTitle = null,
        highlightStyle = null,
        resetStyle = null;
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
      self._legend.layer = self;
    }

    if(geojson) {
      self.setGeoJSON(geojson);
    }

    L.GeoJSON.prototype.initialize.call(self, geojson,
      _.extend(self._options,{style: styleFunction(this)}));
  },
  onAdd: function(map) {
    var self = this;
    if(self._legend) {
      // add Legend to map only if limits are calculated, else just store the map.
      if(self._legend.onAdd) {
        self._legend.addTo(map);
      } else {
        self._legend._map = map;
      }
    }
    L.LayerGroup.prototype.onAdd.call(self, map);
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
    var values = geojson.features.map(function (item) {
      if (typeof self._options.valueProperty === 'function') {
        return self._options.valueProperty(item)
      } else {
        return item.properties[self._options.valueProperty]
      }
    })
    self._limits = chroma.limits(values, self._options.mode, self._options.steps - 1)
    
    if(self._legend) {

      var legendTitle = self._legend.title,
        locale = self._legend.formatOptions.locale,
        localeOptions = self._legend.formatOptions.options,
        highlightStyle = self._legend.highlightStyle,
        resetStyle = self._legend.resetStyle,
        targetLayer = self._legend.layer;

      self._legend.onAdd = function (map) {

        var div = L.DomUtil.create('div', 'info legend');
        if(legendTitle) {
          var title = document.createElement("div");
          title.style={};
          title.style['font-weight'] = "bold";
          title.appendChild(document.createTextNode(legendTitle));
          div.appendChild(title);
        }

        for (var i = 0; i < self._limits.length; i++) {
          var from, to, span, color, text;
          from = i === 0 ? "undefined" : self._limits[i-1];
          to = self._limits[i];
          
          span = document.createElement("span");
          span.classList.add("legendItem");
          span.id = L.stamp(span);
          span.dataset.from = from;
          span.dataset.to = to;

          color = document.createElement("i");
          color.style.background = self._colors[i];
          color.style.border = "solid 0.5px #666";

          textSpan = document.createElement("span");
          //textSpan.classList.add("hvr-grow");
          text = document.createTextNode(
            (from !== 'undefined' ?
              from.toLocaleString(locale, localeOptions) + ' - ' : '<= ') +
              to.toLocaleString(locale, localeOptions) );
          textSpan.appendChild(text);

          span.appendChild(color);
          span.appendChild(textSpan);

          if(!$.isEmptyObject(highlightStyle)) {


            targetLayer.eachLayer(function (layer) {
              var featureValue;
              var spanId = span.id;

              if (typeof self._options.valueProperty === 'function') {
                featureValue = self._options.valueProperty(layer.feature)
              } else {
                featureValue = layer.feature.properties[self._options.valueProperty]
              }

              if ((from !== 'undefined' ? featureValue > from : true) &&
                featureValue <= to) {
                  layer.on({
                    mouseover: function(e) {
                      document.getElementById(spanId).style['font-weight'] = 'bold';
                    },
                    mouseout: function(e) {
                      document.getElementById(spanId).style['font-weight'] = 'normal';
                    },
                  });
                }
            });

            span.addEventListener("mouseover", function (event) {
              var span = event.currentTarget,
                from = span.dataset.from,
                to = span.dataset.to;

              span.style['font-weight'] = 'bold';

              targetLayer.eachLayer(function (layer) {
                var featureValue;

                if (typeof self._options.valueProperty === 'function') {
                  featureValue = self._options.valueProperty(layer.feature)
                } else {
                  featureValue = layer.feature.properties[self._options.valueProperty]
                }

                if ((from !== 'undefined' ? featureValue > from : true) &&
                  featureValue <= to) {
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

              targetLayer.eachLayer(function (layer) {

                var featureValue;

                if (typeof self._options.valueProperty === 'function') {
                  featureValue = self._options.valueProperty(layer.feature)
                } else {
                  featureValue = layer.feature.properties[self._options.valueProperty]
                }

                if ((from !== 'undefined' ? featureValue > from : true) &&
                  featureValue <= to) {
                    if(!$.isEmptyObject(resetStyle)) {
                      layer.setStyle(resetStyle);
                    } else {
                      targetLayer.resetStyle(layer);
                    }
                    if(highlightStyle.sendToBack) {
                      layer.bringToBack();
                    }
                  }
              });
            });
          }


          div.appendChild(span);
          div.appendChild(document.createElement("br"));

        }

        return div;
      };
      if(self._legend._map) {
        self._legend.addTo(self._legend._map);
      }
    }
  }
});

L.choropleth = module.exports = function (geojson, options, legendOptions) {
	return new L.GeoJSONChoropleth(geojson, options, legendOptions);
};
