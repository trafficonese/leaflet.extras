LeafletWidget.methods.addTopoJSONChoropleth = function(data, layerId, group, options) {
  var self = this;
  if (typeof(data) === "string") {
    data = JSON.parse(data);
  }

  var popupProperty = options.popupProperty;
  var labelProperty = options.labelProperty;
  delete options.popupProperty;
  delete options.labelProperty;
  var popupOptions = options.popupOptions;
  var labelOptions = options.labelOptions;
  delete options.popupOptions;
  delete options.labelOptions;

  var globalOptions = $.extend({}, options);
  globalOptions.onEachFeature =  function(feature, layer) {
    var extraInfo = {
      featureId: feature.id,
      properties: feature.properties
    };

		if (typeof popupProperty !== "undefined" && popupProperty !== null) {
			if(typeof popupProperty == "string") {
        if(!$.isEmptyObject(popupOptions)) {
  				layer.bindPopup(feature.properties[popupProperty], popupOptions);
        } else {
  				layer.bindPopup(feature.properties[popupProperty]);
        }
			} else if(typeof popupProperty == "function") {
        if(!$.isEmptyObject(popupOptions)) {
  				layer.bindPopup(popupProperty(feature), popupOptions);
        } else {
  				layer.bindPopup(popupProperty(feature));
        }
			}
		}

		if (typeof labelProperty !== "undefined" && labelProperty !== null) {
			if(typeof labelProperty == "string") {
        if(!$.isEmptyObject(labelOptions)) {
          if(labelOptions.noHide) {
           layer.bindLabel(feature.properties[labelProperty], labelOptions).showLabel();
          } else {
           layer.bindLabel(feature.properties[labelProperty], labelOptions);
          }
        } else {
           layer.bindLabel(feature.properties[labelProperty]);
        }
			} else if(typeof labelProperty == "function") {
        if(!$.isEmptyObject(labelOptions)) {
          if(labelOptions.noHide) {
           layer.bindLabel(labelProperty(feature), labelOptions).showLabel();
          } else {
           layer.bindLabel(labelProperty(feature), labelOptions);
          }
        } else {
           layer.bindLabel(labelProperty(feature));
        }
			}
		}

    layer.on("click", LeafletWidget.methods.mouseHandler(self.id, layerId, group,
      "geojson_click", extraInfo), this);
    layer.on("mouseover", LeafletWidget.methods.mouseHandler(self.id, layerId, group,
      "geojson_mouseover", extraInfo), this);
    layer.on("mouseout", LeafletWidget.methods.mouseHandler(self.id, layerId, group,
      "geojson_mouseout", extraInfo), this);
  };

  var gjlayer = L.choroplethTopo(data, globalOptions);
  this.layerManager.addLayer(gjlayer, "topojsonchoropleth", layerId, group);
};

LeafletWidget.methods.removeTopoJSONChoropleth = function(layerId) {
  this.layerManager.removeLayer("topojsonchoropleth", layerId);
};

LeafletWidget.methods.clearTopoJSONChoropleth = function() {
  this.layerManager.clearLayers("topojsonchoropleth");
};
