LeafletWidget.methods.addWebGLHeatmap = function(lat, lng, intensity,
  layerId, group, options) {

  if(!($.isEmptyObject(lat) || $.isEmptyObject(lng)) ||
    ($.isNumeric(lat) && $.isNumeric(lng))) {

    var heatmapLayer = L.webGLHeatmap(options);

    var df = new LeafletWidget.DataFrame()
      .col('lat',lat)
      .col('lng',lng);

     if(intensity) {
       df.col('intensity',intensity);
     }

    var latlngs = [];
    var i = 0;

    if(intensity) {
      for(i;i<df.nrow();i++){
        if($.isNumeric(df.get(i, "lat")) && $.isNumeric(df.get(i, "lng"))) {
          latlngs.push([
            df.get(i,'lat'),
            df.get(i,'lng'),
            df.get(i,'intensity')
          ]);
        }
      }
    } else {
      for(i;i<df.nrow();i++){
        if($.isNumeric(df.get(i, "lat")) && $.isNumeric(df.get(i, "lng"))) {
          latlngs.push([
            df.get(i,'lat'),
            df.get(i,'lng')
          ]);
        }
      }
    }

    heatmapLayer.setData(latlngs);

    this.layerManager.addLayer(heatmapLayer, "webGLHeatmap", layerId, group);
  }
};

function getHeatmapIntensity(feature, intensityProperty) {
  var intensity = null;
  if(feature) {
    if(typeof intensityProperty === "string") {
      intensity = feature.properties[intensityProperty]
    } else if(typeof intensityProperty === "function") {
      intensity = intensityProperty(feature)
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
  if (geojson.type === "Topology") {
    var topoJsonFeatures = [];
    for (key in geojson.objects) {
      topoJsonFeatures.push(
        topojson.feature(geojson, geojson.objects[key]));
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
            getHeatmapIntensity(feature, intensityProperty)]);
        } else {
          latlngs.push([lat, lng]);
        }
      }
    });
  }

  return latlngs;
}

LeafletWidget.methods.addGenericWebGLGeoJSONHeatmap = function(
    widget, geojson, intensityProperty, layerId, group, options) {
      var heatmapCoords = getHeatmapCoords(geojson, intensityProperty);

      if(!$.isEmptyObject(heatmapCoords)) {
        var heatmapLayer = L.webGLHeatmap(options);
        heatmapLayer.setData(heatmapCoords);
        widget.layerManager.addLayer(
          heatmapLayer, "webGLHeatmap", layerId, group);
      }
};

LeafletWidget.methods.addWebGLGeoJSONHeatmap = function(
  geojson, intensityProperty, layerId, group, options) {
    var self = this;
    if(LeafletWidget.utils.isURL(geojson)) {
      $.getJSON(geojson, function(geojsondata){
        LeafletWidget.methods.addGenericWebGLGeoJSONHeatmap(self,
          geojsondata, intensityProperty, layerId, group, options);
      });
    } else {
      LeafletWidget.methods.addGenericWebGLGeoJSONHeatmap(self,
        geojson, intensityProperty, layerId, group, options);
    }


};

LeafletWidget.methods.addWebGLKMLHeatmap = function(
  kml, intensityProperty, layerId, group, options) {
    var self = this;
    if(LeafletWidget.utils.isURL(kml)) {
      $.getJSON(kml, function(data){
        var geojsondata = toGeoJSON.kml(parseXML(data));
        LeafletWidget.methods.addGenericWebGLGeoJSONHeatmap(self,
          geojsondata, intensityProperty, layerId, group, options);
      });
    } else {
      var geojsondata = toGeoJSON.kml(parseXML(kml));
      LeafletWidget.methods.addGenericWebGLGeoJSONHeatmap(self,
        geojsondata, intensityProperty, layerId, group, options);
    }
};

LeafletWidget.methods.addWebGLCSVHeatmap = function(
  csv, intensityProperty, layerId, group, options, parserOptions) {
    var self = this;
    if(LeafletWidget.utils.isURL(csv)) {
      $.getJSON(csv, function(data){
        csv2geojson.csv2geojson(
          data, parserOptions || {}, 
          function(err, geojsondata) {
            LeafletWidget.methods.addGenericWebGLGeoJSONHeatmap(self,
              geojsondata, intensityProperty, layerId, group, options);
          }
        );
      });
    } else {
      csv2geojson.csv2geojson(
        csv, parserOptions || {}, 
        function(err, geojsondata) {
          LeafletWidget.methods.addGenericWebGLGeoJSONHeatmap(self,
            geojsondata, intensityProperty, layerId, group, options);
        }
      );
    }

};

LeafletWidget.methods.removeWebGLHeatmap = function(layerId) {
  this.layerManager.removeLayer("webGLHeatmap", layerId);
};

LeafletWidget.methods.clearWebGLHeatmap = function() {
  this.layerManager.clearLayers("webGLHeatmap");
};

function parseXML(str) {
  if (typeof str === 'string') {
    return (new DOMParser()).parseFromString(str, 'text/xml');
  } else {
    return str;
  }
}

