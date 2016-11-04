LeafletWidget.methods.addgenericGeoJSON = function(
  widget,
  dataFunction, geojsonLayerFunction,
  layerId, group,
  setStyle,
  markerIconProperty, markerOptions, markerIcons, markerIconFunction,
  clusterOptions, clusterId,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions
  ) {
  var self = widget;

  var data = dataFunction();

  // convert JSON string to Object
  if (data !== null){
    if(typeof(data) === "string") {
      data = JSON.parse(data);
    }
  } else {
    data = {};
  }

  // Initialize Clusering support if enabled.
  var clusterGroup = self.layerManager.getLayer("cluster", clusterId),
    cluster = clusterOptions !== null;
  if (cluster && !clusterGroup) {
    clusterGroup = L.markerClusterGroup.layerSupport(clusterOptions);
    if(clusterOptions.freezeAtZoom) {
      var freezeAtZoom = clusterOptions.freezeAtZoom;
      delete clusterOptions.freezeAtZoom;
      clusterGroup.freezeAtZoom(freezeAtZoom);
    }
    clusterGroup.clusterLayerStore = new LeafletWidget.ClusterLayerStore(clusterGroup);
  }
  var extraInfo = cluster ? { clusterId: clusterId } : {};
  var thisGroup = cluster ? null : group;

  // Initialize shape highlighting if enabled.
  var defaultStyle = {};
  var style = pathOptions;
  var highlightStyle = highlightOptions;
  if(!$.isEmptyObject(highlightStyle)) {
    $.each(highlightStyle, function (k, v) {
      if(k != "bringToFront" && k != "sendToBack"){
        if(style && style[k]) {
          defaultStyle[k] = style[k];
        }
      }
    });
  }

  function highlightFeature(e) {
    var layer = e.target;
    layer.setStyle(highlightStyle);
    if(highlightStyle.bringToFront) {
      layer.bringToFront();
    }
  }
  function resetFeature(e){
    var layer = e.target;
    layer.setStyle(defaultStyle);
    if(highlightStyle.sendToBack) {
      layer.bringToBack();
    }
  }


  var globalStyle = $.extend({}, style, data.style || {});

  function styleFunction(feature) {
    return $.extend(globalStyle, feature.style || {},
      feature.properties.style || {});
  }

  function onEachFeatureFunction(feature, layer) {
    var featureExtraInfo = $.extend({
      featureId: feature.id,
      properties: feature.properties
    }, extraInfo || {});

    // create and bind popups if enabled.
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

    // create and bind labels if enabled.
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

    // add EventListeners to highlight shapes on hover if enabled.
    if(!$.isEmptyObject(highlightStyle)) {
      layer.on({
        "mouseover": highlightFeature,
        "mouseout": resetFeature});
    }

    layer.on("click", LeafletWidget.methods.mouseHandler(self.id, layerId,
      thisGroup, "geojson_click", featureExtraInfo), self);
    layer.on("mouseover", LeafletWidget.methods.mouseHandler(self.id, layerId,
      thisGroup, "geojson_mouseover", featureExtraInfo), self);
    layer.on("mouseout", LeafletWidget.methods.mouseHandler(self.id, layerId,
      thisGroup, "geojson_mouseout", featureExtraInfo), self);
  }

  // code for custom markers
  function pointToLayerFunction(feature, latlng) {
    var layer = null;
  	if (typeof markerIconProperty !== "undefined" && markerIconProperty !== null) {
  		if(typeof markerIconProperty == "string") {
          layer = L.marker(latlng, $.extend({
            icon: markerIconFunction(markerIcons[feature.properties[markerIconProperty]])
          }, markerOptions || {}));
  		} else if(typeof markerIconProperty == "function") {
            layer = L.marker(latlng, $.extend({
              icon: markerIconFunction(markerIcons[markerIconProperty(feature)])
            }, markerOptions || {}));
  		}
  	} else {
          layer = L.marker(latlng, $.extend({
            icon: markerIconFunction(markerIcons)
          }, markerOptions || {}));
  	}

    if(cluster) {
      clusterGroup.clusterLayerStore.add(layer);
    }
  	return layer;
  }

  var geojsonOptions = {};
  if(setStyle){
    geojsonOptions.style = styleFunction;
  }
  geojsonOptions.onEachFeature = onEachFeatureFunction;

  if(!$.isEmptyObject(markerIcons)) {
    geojsonOptions.pointToLayer = pointToLayerFunction;
  }

  var gjlayer = geojsonLayerFunction(data, geojsonOptions);

  self.layerManager.addLayer(gjlayer, "geojson", layerId, thisGroup);
  if (cluster) {
    self.layerManager.addLayer(clusterGroup, "cluster", clusterId, group);
  }

};

LeafletWidget.methods.addGeoJSONv2 = function(
  data, layerId, group,
  markerIconProperty, markerOptions, markerIcons, markerIconFunction,
  clusterOptions, clusterId,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions
  ) {
    LeafletWidget.methods.addgenericGeoJSON(
      this,
      function getData(){return data;},
      function getGeoJSONLayer(data, geoJsonOptions){
        return L.geoJson(data, geoJsonOptions);
      },
      layerId, group,
      true,
      markerIconProperty, markerOptions, markerIcons, markerIconFunction,
      clusterOptions, clusterId,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions
    );
};
