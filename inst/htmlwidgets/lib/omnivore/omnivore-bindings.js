/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
// parse an XML
LeafletWidget.utils.parseXML = function(str) {
  if (typeof str === 'string') {
    return (new DOMParser()).parseFromString(str, 'text/xml');
  } else {
    return str;
  }
};

// parse an GeoJSON/TopoJSON
LeafletWidget.utils.getParsedGeoJSON = function(data) {
  var geojson;

  if(typeof data ==='undefined' || data === null ||
    (typeof data === 'string' && data.trim() === '')) {
    return geojson;
  }

  if(typeof data === 'string') {
    geojson = JSON.parse(data);
  } else {
    geojson = data;
  }

  // if input is a TopoJSON
  // iterate over each of its objects and add their coords
  if (geojson.type === 'Topology') {
    var topoJsonFeatures = [];
    for (var key in geojson.objects) {
      var topoToGeo = topojson.feature(geojson, geojson.objects[key]);
      if(L.Util.isArray(topoToGeo)) {
        topoJsonFeatures = topoJsonFeatures.concat(topoToGeo);
      } else if('features' in topoToGeo ) {
        topoJsonFeatures = topoJsonFeatures.concat(topoToGeo.features);
      } else {
        topoJsonFeatures.push(topoToGeo);
      }
    }
    geojson = topoJsonFeatures;
  }
  return geojson;
};

// utility method to extract resetStyle from defaultStyle & highlightStyle
function getResetStyle(style, highlightStyle) {
  var resetStyle = {};
  if(!$.isEmptyObject(highlightStyle)) {
    $.each(highlightStyle, function (k, v) {
      if(k != 'bringToFront' && k != 'sendToBack'){
        if(style && style[k]) {
          resetStyle[k] = style[k];
        }
      }
    });
  }
  return resetStyle;
}

// is a given string a URL
LeafletWidget.utils.isURL = function(url) {
  if (typeof url !== 'string' || url.trim() === '' ) {
    return false;
  }
  var strRegex = '^((https|http|ftp|rtsp|mms)?://)'
    + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp user@
    + '(([0-9]{1,3}\.){3}[0-9]{1,3}' // IP/URL- 199.194.52.184
    + '|' // IP/DOMAIN
    + "([0-9a-z_!~*'()-]+\.)*" //  www.
    + '([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\.' //
    + '[a-z]{2,6})' // first level domain- .com or .museum
    + '(:[0-9]{1,4})?' // Port - :80
    + '((/?)|' // a slash isn't required if there is no file name
    + "(/[0-9A-Za-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
  var re=new RegExp(strRegex);
  return re.test(url);
};

function addGeoJSONLayer(
  widget,
  geojsonLayerFunction,
  layerId, group,
  setStyle,
  markerType, markerIcons,
  markerIconProperty, markerOptions, markerIconFunction,
  clusterOptions, clusterId,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions
) {
  var self = widget;

  // Initialize Clusering support if enabled.
  var clusterGroup = self.layerManager.getLayer('cluster', clusterId),
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
  var style = pathOptions;
  var highlightStyle = highlightOptions;
  var defaultStyle = getResetStyle(style, highlightStyle);

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

  var globalStyle = $.extend({}, style);

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
    if (typeof popupProperty !== 'undefined' && popupProperty !== null) {
      if(typeof popupProperty == 'string') {
        if(!$.isEmptyObject(popupOptions)) {
          layer.bindPopup(feature.properties[popupProperty], popupOptions);
        } else {
          layer.bindPopup(feature.properties[popupProperty]);
        }
      } else if(typeof popupProperty == 'function') {
        if(!$.isEmptyObject(popupOptions)) {
          layer.bindPopup(popupProperty(feature), popupOptions);
        } else {
          layer.bindPopup(popupProperty(feature));
        }
      }
    }

    // create and bind labels if enabled.
    if (typeof labelProperty !== 'undefined' && labelProperty !== null) {
      if(typeof labelProperty == 'string') {
        if(!$.isEmptyObject(labelOptions)) {
          if(labelOptions.noHide) {
            layer.bindLabel(feature.properties[labelProperty], labelOptions).showLabel();
          } else {
            layer.bindLabel(feature.properties[labelProperty], labelOptions);
          }
        } else {
          layer.bindLabel(feature.properties[labelProperty]);
        }
      } else if(typeof labelProperty == 'function') {
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
        'mouseover': highlightFeature,
        'mouseout': resetFeature});
    }

    layer.on('click', LeafletWidget.methods.mouseHandler(self.id, layerId,
      thisGroup, 'geojson_click', featureExtraInfo), self);
    layer.on('mouseover', LeafletWidget.methods.mouseHandler(self.id, layerId,
      thisGroup, 'geojson_mouseover', featureExtraInfo), self);
    layer.on('mouseout', LeafletWidget.methods.mouseHandler(self.id, layerId,
      thisGroup, 'geojson_mouseout', featureExtraInfo), self);
  }

  // code for custom markers
  function pointToLayerFunction(feature, latlng) {
    var layer = null;
    if(markerType === 'circleMarker') {
      layer = L.circleMarker(latlng, markerOptions || {});
    } else {
      if (typeof markerIconProperty !== 'undefined' && markerIconProperty !== null) {
        if(typeof markerIconProperty == 'string') {
          layer = L.marker(latlng, $.extend({
            icon: markerIconFunction(markerIcons[feature.properties[markerIconProperty]])
          }, markerOptions || {}));
        } else if(typeof markerIconProperty == 'function') {
          layer = L.marker(latlng, $.extend({
            icon: markerIconFunction(markerIcons[markerIconProperty(feature)])
          }, markerOptions || {}));
        }
      } else {
        layer = L.marker(latlng, $.extend({
          icon: markerIconFunction(markerIcons)
        }, markerOptions || {}));
      }
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

  if(markerType === 'circleMarker' || !$.isEmptyObject(markerIcons)) {
    geojsonOptions.pointToLayer = pointToLayerFunction;
  }

  var gjlayer = geojsonLayerFunction(geojsonOptions);

  self.layerManager.addLayer(gjlayer, 'geojson', layerId, thisGroup);
  if (cluster) {
    self.layerManager.addLayer(clusterGroup, 'cluster', clusterId, group);
  }

}

LeafletWidget.methods.addGenericGeoJSONLayer = addGeoJSONLayer;

LeafletWidget.methods.addGeoJSONv2 = function(
  geojson, layerId, group,
  markerType, markerIcons,
  markerIconProperty, markerOptions, markerIconFunction,
  clusterOptions, clusterId,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions
) {
  var self = this;
  if(LeafletWidget.utils.isURL(geojson)) {
    $.getJSON(geojson, function(geojsondata){
      addGeoJSONLayer(
        self,
        function getGeoJSONLayer(geoJSONOptions){
          return L.geoJson(
            LeafletWidget.utils.getParsedGeoJSON(geojsondata), geoJSONOptions);
        },
        layerId, group,
        true,
        markerType, markerIcons,
        markerIconProperty, markerOptions, markerIconFunction,
        clusterOptions, clusterId,
        labelProperty, labelOptions, popupProperty, popupOptions,
        pathOptions, highlightOptions
      );
    });
  } else {
    addGeoJSONLayer(
      self,
      function getGeoJSONLayer(geoJSONOptions){
        return L.geoJson(
          LeafletWidget.utils.getParsedGeoJSON(geojson), geoJSONOptions);
      },
      layerId, group,
      true,
      markerType, markerIcons,
      markerIconProperty, markerOptions, markerIconFunction,
      clusterOptions, clusterId,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions
    );
  }
};

LeafletWidget.methods.addKML = function(
  kml, layerId, group,
  markerType, markerIcons,
  markerIconProperty, markerOptions, markerIconFunction,
  clusterOptions, clusterId,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions
) {
  var self = this;
  if(LeafletWidget.utils.isURL(kml)) {
    $.getJSON(kml, function(data){
      var geojsondata = toGeoJSON.kml(
        LeafletWidget.utils.parseXML(data));
      addGeoJSONLayer(
        self,
        function getGeoJSONLayer(geoJSONOptions){
          return L.geoJson(
            LeafletWidget.utils.getParsedGeoJSON(geojsondata), geoJSONOptions);
        },
        layerId, group,
        true,
        markerType, markerIcons,
        markerIconProperty, markerOptions, markerIconFunction,
        clusterOptions, clusterId,
        labelProperty, labelOptions, popupProperty, popupOptions,
        pathOptions, highlightOptions
      );
    });
  } else {
    var geojsondata = toGeoJSON.kml(
      LeafletWidget.utils.parseXML(kml));
    addGeoJSONLayer(
      self,
      function getGeoJSONLayer(geoJSONOptions){
        return L.geoJson(
          LeafletWidget.utils.getParsedGeoJSON(geojsondata), geoJSONOptions);
      },
      layerId, group,
      true,
      markerType, markerIcons,
      markerIconProperty, markerOptions, markerIconFunction,
      clusterOptions, clusterId,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions
    );
  }
};

LeafletWidget.methods.addCSV = function(
  csv, layerId, group,
  markerType, markerIcons,
  markerIconProperty, markerOptions, markerIconFunction,
  clusterOptions, clusterId,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions, csvParserOptions
) {
  var self = this;
  if(LeafletWidget.utils.isURL(csv)) {
    $.getJSON(csv, function(data){
      csv2geojson.csv2geojson(
        data, csvParserOptions || {},
        function(err, geojsondata) {
          addGeoJSONLayer(
            self,
            function getGeoJSONLayer(geoJSONOptions){
              return L.geoJson(
                LeafletWidget.utils.getParsedGeoJSON(geojsondata), geoJSONOptions);
            },
            layerId, group,
            true,
            markerType, markerIcons,
            markerIconProperty, markerOptions, markerIconFunction,
            clusterOptions, clusterId,
            labelProperty, labelOptions, popupProperty, popupOptions,
            pathOptions, highlightOptions
          );
        }
      );
    });
  } else {
    csv2geojson.csv2geojson(
      csv, csvParserOptions || {},
      function(err, geojsondata) {
        addGeoJSONLayer(
          self,
          function getGeoJSONLayer(geoJSONOptions){
            return L.geoJson(
              LeafletWidget.utils.getParsedGeoJSON(geojsondata), geoJSONOptions);
          },
          layerId, group,
          true,
          markerType, markerIcons,
          markerIconProperty, markerOptions, markerIconFunction,
          clusterOptions, clusterId,
          labelProperty, labelOptions, popupProperty, popupOptions,
          pathOptions, highlightOptions
        );
      }
    );
  }
};

LeafletWidget.methods.addGPX = function(
  gpx, layerId, group,
  markerType, markerIcons,
  markerIconProperty, markerOptions, markerIconFunction,
  clusterOptions, clusterId,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions
) {
  var self = this;
  if(LeafletWidget.utils.isURL(gpx)) {
    $.getJSON(gpx, function(data){
      var geojsondata = toGeoJSON.gpx(
        LeafletWidget.utils.parseXML(data));
      addGeoJSONLayer(
        self,
        function getGeoJSONLayer(geoJSONOptions){
          return L.geoJson(
            LeafletWidget.utils.getParsedGeoJSON(geojsondata), geoJSONOptions);
        },
        layerId, group,
        true,
        markerType, markerIcons,
        markerIconProperty, markerOptions, markerIconFunction,
        clusterOptions, clusterId,
        labelProperty, labelOptions, popupProperty, popupOptions,
        pathOptions, highlightOptions
      );
    });
  } else {
    var geojsondata = toGeoJSON.gpx(
      LeafletWidget.utils.parseXML(gpx));
    addGeoJSONLayer(
      self,
      function getGeoJSONLayer(geoJSONOptions){
        return L.geoJson(
          LeafletWidget.utils.getParsedGeoJSON(geojsondata), geoJSONOptions);
      },
      layerId, group,
      true,
      markerType, markerIcons,
      markerIconProperty, markerOptions, markerIconFunction,
      clusterOptions, clusterId,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions
    );
  }
};



LeafletWidget.methods.addGeoJSONChoropleth = function(
  geojson, layerId, group,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions, legendOptions
) {

  var style = pathOptions;
  var highlightStyle = highlightOptions;
  var defaultStyle = getResetStyle(style, highlightStyle);

  if(!$.isEmptyObject(legendOptions)) {
    legendOptions.highlightStyle = highlightStyle;
    legendOptions.resetStyle = defaultStyle;
  }

  var self = this;
  if(LeafletWidget.utils.isURL(geojson)) {
    $.getJSON(geojson, function(geojsondata){
      addGeoJSONLayer(
        self,
        function getGeoJSONLayer(geoJSONOptions){
          return L.choropleth(
            LeafletWidget.utils.getParsedGeoJSON(geojsondata),
            $.extend(pathOptions, geoJSONOptions), legendOptions);
        },
        layerId, group,
        false,
        null, null,
        null, null, null,
        null, null,
        labelProperty, labelOptions, popupProperty, popupOptions,
        pathOptions, highlightOptions
      );
    });
  } else {
    addGeoJSONLayer(
      self,
      function getGeoJSONLayer(geoJSONOptions){
        return L.choropleth(
          LeafletWidget.utils.getParsedGeoJSON(geojson),
          $.extend(pathOptions, geoJSONOptions), legendOptions);
      },
      layerId, group,
      false,
      null, null,
      null, null, null,
      null, null,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions
    );
  }
};

LeafletWidget.methods.addKMLChoropleth = function(
  kml, layerId, group,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions, legendOptions
) {
  var style = pathOptions;
  var highlightStyle = highlightOptions;
  var defaultStyle = getResetStyle(style, highlightStyle);

  if(!$.isEmptyObject(legendOptions)) {
    legendOptions.highlightStyle = highlightStyle;
    legendOptions.resetStyle = defaultStyle;
  }

  var self = this;
  if(LeafletWidget.utils.isURL(kml)) {
    $.getJSON(kml, function(data){
      var geojsondata = toGeoJSON.kml(LeafletWidget.utils.parseXML(data));
      addGeoJSONLayer(
        self,
        function getGeoJSONLayer(geoJSONOptions){
          return L.choropleth(
            LeafletWidget.utils.getParsedGeoJSON(geojsondata),
            $.extend(pathOptions, geoJSONOptions), legendOptions);
        },
        layerId, group,
        false,
        null, null,
        null, null, null,
        null, null,
        labelProperty, labelOptions, popupProperty, popupOptions,
        pathOptions, highlightOptions
      );
    });
  } else {
    var geojsondata = toGeoJSON.kml(LeafletWidget.utils.parseXML(kml));
    addGeoJSONLayer(
      self,
      function getGeoJSONLayer(geoJSONOptions){
        return L.choropleth(
          LeafletWidget.utils.getParsedGeoJSON(geojsondata),
          $.extend(pathOptions, geoJSONOptions), legendOptions);
      },
      layerId, group,
      false,
      null, null,
      null, null, null,
      null, null,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions
    );
  }
};

