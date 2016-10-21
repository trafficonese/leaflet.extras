LeafletWidget.methods.addTopoJSONChoropleth = function(data, layerId, group, options) {
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

  var gjlayer = L.choroplethTopo(data, globalOptions);
  this.layerManager.addLayer(gjlayer, "topojsonchoropleth", layerId, group);
};

LeafletWidget.methods.removeTopoJSONChoropleth = function(layerId) {
  this.layerManager.removeLayer("topojsonchoropleth", layerId);
};

LeafletWidget.methods.clearTopoJSONChoropleth = function() {
  this.layerManager.clearLayers("topojsonchoropleth");
};
