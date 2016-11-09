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

LeafletWidget.methods.addWebGLGeoJSONHeatmap = function(
  geojson, intensityProperty, layerId, group, options) {

  if(!$.isEmptyObject(geojson)) {

    var heatmapLayer = L.webGLHeatmap(options);

    var latlngs = [];

    var geojsondata = null;
    if(LeafletWidget.utils.isURL(geojson)) {
      $.ajaxSetup({async: false});
      $.getJSON(geojson, function(data){
        geojsondata = data;
      });
      $.ajaxSetup({async: true});
    } else {
      geojsondata = geojson;
    }

    if(geojsondata) {

      if(typeof geojsondata === 'string') {
        geojsondata = JSON.parse(geojsondata);
      }
      if (geojsondata.type === "Topology") {
      	for (key in geojsondata.objects) {
          var topoToGeo = topojson.feature(geojsondata,
            geojsondata.objects[key]);
        }
        geojsondata = topoToGeo;
      }

      if('features' in geojsondata) { // GeoJSON FeatureCollection with Point/MultiPoint Datasets
        $.each(geojsondata.features, function(index, feature) {
          var lat = null, lng = null;

          if(feature.geometry.type === 'MultiPoint') {
            lat = parseFloat(feature.geometry.coordinates[0][1]);
            lng = parseFloat(feature.geometry.coordinates[0][0]);
          } else if(feature.geometry.type === 'Point') {
            lat = parseFloat(feature.geometry.coordinates[1]);
            lng = parseFloat(feature.geometry.coordinates[0]);
          }

          if(lat && lng) {
            if (typeof intensityProperty !== "undefined" && intensityProperty !== null) {
              if(typeof intensityProperty === "string") {
                latlngs.push([
                  lat, lng,
                  feature.properties[intensityProperty]
                ]);
              } else if(typeof intensityProperty === "function") {
                latlngs.push([
                  lng, lng,
                  intensityProperty(feature)
                ]);
              }
            } else {
              latlngs.push([lat, lng]);
            }
          }

        });
      } else if(geojsondata.type === 'Feature') { // Single GeoJSON Feature with MultiPoint dataset
          if(geojsondata.geometry.type === 'MultiPoint') {
            $.each(geojsondata.geometry.coordinates, function(index, coordinate){
              var lat = coordinate[1];
              var lng = coordinate[0];
              if(lat && lng) {
                if (typeof intensityProperty !== "undefined" && intensityProperty !== null) {
                  if(typeof intensityProperty === "string") {
                    latlngs.push([
                      lat, lng,
                      feature.properties[intensityProperty]
                    ]);
                  } else if(typeof intensityProperty === "function") {
                    latlngs.push([
                      lng, lng,
                      intensityProperty(feature)
                    ]);
                  }
                } else {
                  latlngs.push([lat, lng]);
                }
              }
            });
          }
      }

      heatmapLayer.setData(latlngs);

      this.layerManager.addLayer(heatmapLayer, "webGLHeatmap", layerId, group);
    } 
  }
};

LeafletWidget.methods.addWebGLKMLHeatmap = function(
  kml, intensityProperty, layerId, group, options) {
 var geojsondata = null;
    if(LeafletWidget.utils.isURL(kml)) {
      $.ajaxSetup({async: false});
      $.getJSON(kml, function(data){
        geojsondata = toGeoJSON.kml(parseXML(data));
      });
      $.ajaxSetup({async: true});
    } else {
      geojsondata = toGeoJSON.kml(parseXML(kml));
    }
    if(geojsondata) {
    LeafletWidget.methods.addWebGLGeoJSONHeatmap.call(this,
      geojsondata, intensityProperty, layerId, group, options);
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

