/******/ (() => { // webpackBootstrap
var __webpack_exports__ = {};
/*!*****************************************************************!*\
  !*** ./inst/htmlwidgets/bindings/lfx-webgl-heatmap-bindings.js ***!
  \*****************************************************************/
/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
LeafletWidget.methods.addWebGLHeatmap = function(points, layerId, group, options) {

  var map = this;

  if(!$.isEmptyObject(points)) {

    if(options.gradientTexture) {
      var attachment = document.getElementById('lfx-webgl-heatmap-'+options.gradientTexture+'-attachment');
      if(!$.isEmptyObject(attachment)) {
        options.gradientTexture = attachment.href;
      } else {
        delete options.gradientTexture;
      }
    }

    var heatmapLayer = L.webGLHeatmap(options);
    heatmapLayer.setData(points);
    map.layerManager.addLayer(heatmapLayer, 'webGLHeatmap', layerId, group);
    if(options.gradientTexture) { // hack to trigger proper loading of the gradient
      map.zoomOut();
      setTimeout(function() {map.zoomIn();}, 500);
    }
  }
};

function getHeatmapIntensity(feature, intensityProperty) {
  var intensity = null;
  if(feature) {
    if(typeof intensityProperty === 'string') {
      intensity = feature.properties[intensityProperty];
    } else if(typeof intensityProperty === 'function') {
      intensity = intensityProperty(feature);
    }
  }
  return intensity;
}

function getHeatmapCoords(geojson, intensityProperty) {

  var latlngs = [];
  if(typeof geojson === 'undefined' || geojson === null) {
    return latlngs;
  }

  if(typeof geojson === 'string') {
    geojson = JSON.parse(geojson);
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
    return getHeatmapCoords(topoJsonFeatures, intensityProperty);
  }

  var features = L.Util.isArray(geojson) ?  geojson : geojson.features;

  if(features) {  // either a FeatureCollection or an Array of Features
    $.each(features, function(index, feature) {

      var lat = null, lng = null;

      // We're only interested in Points and Multipoints
      // every other geometry is a shape
      if(feature.geometry.type === 'Point') {
        lat = parseFloat(feature.geometry.coordinates[1]);
        lng = parseFloat(feature.geometry.coordinates[0]);

        if(lat && lng) {
          if(intensityProperty) {
            latlngs.push([lat, lng,
              getHeatmapIntensity(feature, intensityProperty)]);
          } else {
            latlngs.push([lat, lng]);
          }
        }
      } else if(feature.geometry.type === 'MultiPoint') {
        latlngs = latlngs.concat(
          getHeatmapCoords(feature, intensityProperty));
      }
    });
  } else if(geojson.type === 'Feature') { // Single GeoJSON Feature with MultiPoint dataset
    $.each(geojson.geometry.coordinates, function(index, coordinate){
      var lat = null, lng = null;
      lat = parseFloat(coordinate[1]);
      lng = parseFloat(coordinate[0]);
      if(lat && lng) {
        if(intensityProperty) {
          latlngs.push([lat, lng,
            getHeatmapIntensity(geojson, intensityProperty)]);
        } else {
          latlngs.push([lat, lng]);
        }
      }
    });
  }

  return latlngs;
}

function addGenericWebGLGeoJSONHeatmap( widget, geojson, intensityProperty, layerId, group, options) {
  var heatmapCoords = getHeatmapCoords(geojson, intensityProperty);

  if(!$.isEmptyObject(heatmapCoords)) {

    if(options.gradientTexture) {
      var attachment =
        document.getElementById('lfx-webgl-heatmap-'+options.gradientTexture+'-attachment');
      if(!$.isEmptyObject(attachment)) {
        options.gradientTexture = attachment.href;
      } else {
        delete options.gradientTexture;
      }
    }

    var heatmapLayer = L.webGLHeatmap(options);
    heatmapLayer.setData(heatmapCoords);
    widget.layerManager.addLayer(
      heatmapLayer, 'webGLHeatmap', layerId, group);
    if(options.gradientTexture) {
      // hack to trigger proper loading of the gradient
      widget.zoomOut();
      setTimeout(function() {widget.zoomIn();}, 500);
    }
  }
}

LeafletWidget.methods.addWebGLGeoJSONHeatmap = function(geojson, intensityProperty, layerId, group, options) {
  var self = this;
  if(LeafletWidget.utils.isURL(geojson)) {
    $.getJSON(geojson, function(geojsondata){
      addGenericWebGLGeoJSONHeatmap(self,
        geojsondata, intensityProperty, layerId, group, options);
    });
  } else {
    addGenericWebGLGeoJSONHeatmap(self,
      geojson, intensityProperty, layerId, group, options);
  }
};

LeafletWidget.methods.addWebGLKMLHeatmap = function(kml, intensityProperty, layerId, group, options) {
  var self = this;
  if(LeafletWidget.utils.isURL(kml)) {
    $.getJSON(kml, function(data){
      var geojsondata = toGeoJSON.kml(
        LeafletWidget.utils.parseXML(data));
      addGenericWebGLGeoJSONHeatmap(self,
        geojsondata, intensityProperty, layerId, group, options);
    });
  } else {
    var geojsondata = toGeoJSON.kml(
      LeafletWidget.utils.parseXML(kml));
    addGenericWebGLGeoJSONHeatmap(self,
      geojsondata, intensityProperty, layerId, group, options);
  }
};

LeafletWidget.methods.addWebGLCSVHeatmap = function(csv, intensityProperty, layerId, group, options, parserOptions) {
  var self = this;
  if(LeafletWidget.utils.isURL(csv)) {
    $.getJSON(csv, function(data){
      csv2geojson.csv2geojson(
        data, parserOptions || {},
        function(err, geojsondata) {
          addGenericWebGLGeoJSONHeatmap(self,
            geojsondata, intensityProperty, layerId, group, options);
        }
      );
    });
  } else {
    csv2geojson.csv2geojson(
      csv, parserOptions || {},
      function(err, geojsondata) {
        addGenericWebGLGeoJSONHeatmap(self,
          geojsondata, intensityProperty, layerId, group, options);
      }
    );
  }
};

LeafletWidget.methods.addWebGLGPXHeatmap = function(gpx, intensityProperty, layerId, group, options) {
  var self = this;
  if(LeafletWidget.utils.isURL(gpx)) {
    $.getJSON(gpx, function(data){
      var geojsondata = toGeoJSON.gpx(
        LeafletWidget.utils.parseXML(data));
      addGenericWebGLGeoJSONHeatmap(self,
        geojsondata, intensityProperty, layerId, group, options);
    });
  } else {
    var geojsondata = toGeoJSON.gpx(
      LeafletWidget.utils.parseXML(gpx));
    addGenericWebGLGeoJSONHeatmap(self,
      geojsondata, intensityProperty, layerId, group, options);
  }
};

LeafletWidget.methods.removeWebGLHeatmap = function(layerId) {
  this.layerManager.removeLayer('webGLHeatmap', layerId);
};

LeafletWidget.methods.clearWebGLHeatmap = function() {
  this.layerManager.clearLayers('webGLHeatmap');
};

/******/ })()
;
//# sourceMappingURL=lfx-webgl-heatmap-bindings.js.map