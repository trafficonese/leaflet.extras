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

LeafletWidget.methods.removeWebGLHeatmap = function(layerId) {
  this.layerManager.removeLayer("webGLHeatmap", layerId);
};

LeafletWidget.methods.clearWebGLHeatmap = function() {
  this.layerManager.clearLayers("webGLHeatmap");
};

