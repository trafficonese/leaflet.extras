LeafletWidget.methods.addGeoJSONChoropleth = function(data, layerId, group, options) {
  var self = this;
  if (typeof(data) === "string") {
    data = JSON.parse(data);
  }

  var popupProperty = options.popupProperty;
  var labelProperty = options.labelProperty;
  delete options.popupProperty;
  delete options.labelProperty;

  var globalOptions = $.extend({}, options);
  globalOptions.onEachFeature =  function(feature, layer) {
    var extraInfo = {
      featureId: feature.id,
      properties: feature.properties
    };

		if (typeof popupProperty !== "undefined" && popupProperty !== null) {
			if(typeof popupProperty == "string") {
				layer.bindPopup(feature.properties[popupProperty]);
			} else if(typeof popupProperty == "function") {
				layer.bindPopup(popupProperty(feature));
			}
		}

		if (typeof labelProperty !== "undefined" && labelProperty !== null) {
			if(typeof labelProperty == "string") {
				layer.bindLabel(feature.properties[labelProperty]);
			} else if(typeof labelProperty == "function") {
				layer.bindLabel(labelProperty(feature));
			}
		}

    layer.on("click", LeafletWidget.methods.mouseHandler(self.id, layerId, group,
      "geojson_click", extraInfo), this);
    layer.on("mouseover", LeafletWidget.methods.mouseHandler(self.id, layerId, group,
      "geojson_mouseover", extraInfo), this);
    layer.on("mouseout", LeafletWidget.methods.mouseHandler(self.id, layerId, group,
      "geojson_mouseout", extraInfo), this);
  };

  var gjlayer = L.choropleth(data, globalOptions);
  this.layerManager.addLayer(gjlayer, "geojsonchoropleth", layerId, group);
};

LeafletWidget.methods.removeGeoJSONChoropleth = function(layerId) {
  this.layerManager.removeLayer("geojsonchoropleth", layerId);
};

LeafletWidget.methods.clearGeoJSONChoropleth = function() {
  this.layerManager.clearLayers("geojsonchoropleth");
};

