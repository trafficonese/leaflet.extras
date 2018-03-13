/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
LeafletWidget.methods.addHeatmap = function(points, layerId, group, options) {

  if(!$.isEmptyObject(points)) {
    var heatmapLayer = L.heatLayer(points, options);
    this.layerManager.addLayer(heatmapLayer, 'heatmap', layerId, group);
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

function addGenericGeoJSONHeatmap( widget, geojson, intensityProperty, layerId, group, options) {
  var heatmapCoords = getHeatmapCoords(geojson, intensityProperty);

  if(!$.isEmptyObject(heatmapCoords)) {
    var heatmapLayer = L.heatLayer(heatmapCoords, options);
    widget.layerManager.addLayer(
      heatmapLayer, 'heatmap', layerId, group);
  }
}

LeafletWidget.methods.addGeoJSONHeatmap = function(geojson, intensityProperty, layerId, group, options) {
  var self = this;
  if(LeafletWidget.utils.isURL(geojson)) {
    $.getJSON(geojson, function(geojsondata){
      addGenericGeoJSONHeatmap(self,
        geojsondata, intensityProperty, layerId, group, options);
    });
  } else {
    addGenericGeoJSONHeatmap(self,
      geojson, intensityProperty, layerId, group, options);
  }
};

LeafletWidget.methods.addKMLHeatmap = function(kml, intensityProperty, layerId, group, options) {
  var self = this;
  if(LeafletWidget.utils.isURL(kml)) {
    $.getJSON(kml, function(data){
      var geojsondata = toGeoJSON.kml(
        LeafletWidget.utils.parseXML(data));
      addGenericGeoJSONHeatmap(self,
        geojsondata, intensityProperty, layerId, group, options);
    });
  } else {
    var geojsondata = toGeoJSON.kml(
      LeafletWidget.utils.parseXML(kml));
    addGenericGeoJSONHeatmap(self,
      geojsondata, intensityProperty, layerId, group, options);
  }
};

LeafletWidget.methods.addCSVHeatmap = function(csv, intensityProperty, layerId, group, options, parserOptions) {
  var self = this;
  if(LeafletWidget.utils.isURL(csv)) {
    $.getJSON(csv, function(data){
      csv2geojson.csv2geojson(
        data, parserOptions || {},
        function(err, geojsondata) {
          addGenericGeoJSONHeatmap(self,
            geojsondata, intensityProperty, layerId, group, options);
        }
      );
    });
  } else {
    csv2geojson.csv2geojson(
      csv, parserOptions || {},
      function(err, geojsondata) {
        addGenericGeoJSONHeatmap(self,
          geojsondata, intensityProperty, layerId, group, options);
      }
    );
  }
};

LeafletWidget.methods.addGPXHeatmap = function(gpx, intensityProperty, layerId, group, options) {
  var self = this;
  if(LeafletWidget.utils.isURL(gpx)) {
    $.getJSON(gpx, function(data){
      var geojsondata = toGeoJSON.gpx(
        LeafletWidget.utils.parseXML(data));
      addGenericGeoJSONHeatmap(self,
        geojsondata, intensityProperty, layerId, group, options);
    });
  } else {
    var geojsondata = toGeoJSON.gpx(
      LeafletWidget.utils.parseXML(gpx));
    addGenericGeoJSONHeatmap(self,
      geojsondata, intensityProperty, layerId, group, options);
  }
};

LeafletWidget.methods.removeHeatmap = function(layerId) {
  this.layerManager.removeLayer('heatmap', layerId);
};

LeafletWidget.methods.clearHeatmap = function() {
  this.layerManager.clearLayers('heatmap');
};
