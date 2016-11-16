LeafletWidget.methods.addDrawToolbar = function(layerId, group, options) {
  (function(){

    var map = this;

    // clear old toolbar if any
    map.layerManager.clearLayers('editableLayers');
    if(map.drawToolbar) {
      map.drawToolbar.removeFrom(map);
      delete map.drawToobar;
    }
    map._editableLayerId = null;

    // FeatureGroup that will hold our drawn shapes/markers
    // DON'T TOUCH THIS IF YOU DON'T KNOW WHAT YOU ARE DOING
    var editableLayers = new L.FeatureGroup();
    editableLayers.id = layerId || L.Util.stamp(editableLayers);
    map._editableLayerId = editableLayers.id; // store the ID for later use
    this.layerManager.addLayer(editableLayers, 'editableLayers',
      editableLayers.id, group);

    // Create appropriate Marker Icon.
    // DON'T TOUCH THIS IF YOU DON'T KNOW WHAT YOU ARE DOING
    if(options && options.draw && options.draw.marker) {
      if(options.draw.marker.markerIcon && 
        options.draw.marker.markerIconFunction) {
          options.draw.marker.icon =
            options.draw.marker.markerIconFunction(
              options.draw.marker.markerIcon);
        }
    }

    // create appropriate options
    // DON'T TOUCH THIS IF YOU DON'T KNOW WHAT YOU ARE DOING
    if(!$.isEmptyObject(options.edit)) {
      var editOptions = {};
      if(!options.edit.remove) {
        editOptions.remove = false;
      }
      if(!options.edit.edit) {
        editOptions.edit = false;
      } else if(!$.isEmptyObject(options.edit.selectedPathOptions)) {
        editOptions.edit = {};
        editOptions.edit.selectedPathOptions =
          options.edit.selectedPathOptions;
      }

      if(!$.isEmptyObject(options.edit.poly)) {
        editOptions.poly = options.edit.poly;
      }

      editOptions.featureGroup = editableLayers;
      options.edit = editOptions;
    }

    // DON'T TOUCH ANYTHING BELOW IF YOU DON'T KNOW WHAT YOU ARE DOING
    map.drawToolbar =  new L.Control.Draw(options);
    map.drawToolbar.addTo(map);

    map.on(L.Draw.Event.CREATED, function (e) {
      var type = layer = e.layer;
      editableLayers.addLayer(layer);
    });
  }).call(this);

};

LeafletWidget.methods.removeDrawToolbar = function() {
  (function(){

    var map = this;

    if(map.drawToolbar) {
      map.drawToolbar.removeFrom(map);
      delete map.drawToolbar;
    }
    map.layerManager.clearLayers('editableLayers');
    map._editableLayerId = null;
  }).call(this);

}

LeafletWidget.methods.getDrawnItems = function() {
  var map = this;

  if(map._editableLayerId) {
    var layer = this.layerManager.getLayer('editableLayers', map._editableLayerId);
    if(layer) { 
      return layer.toGeoJSON();
    } else {
      return null; // Normally this shouldn't happen
    }
  } else {
    return null;
  }
}
