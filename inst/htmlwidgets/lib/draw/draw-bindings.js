/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
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

    // Event Listeners
    map.on(L.Draw.Event.CREATED, function (e) {
      var layer = e.layer;
      editableLayers.addLayer(layer);

      // assign a unique key to the newly created feature
      var featureId = L.stamp(layer);
      layer.feature = {
        'type' : 'Feature',
        'properties' : {
          '_leaflet_id' : featureId
        }
      };

      // circles are just Points and toGeoJSON won't store radius by default
      // so we store it inside the properties.
      if(e.layerType === 'circle') {
        layer.feature.properties.type = 'circle';
        layer.feature.properties.radius = layer.getRadius();
      }
      
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;

      Shiny.onInputChange(map.id+'_draw_new_feature',
        layer.toGeoJSON());
      Shiny.onInputChange(map.id+'_draw_all_features',
        editableLayers.toGeoJSON());
    });

    map.on(L.Draw.Event.EDITED, function (e) {
      
      var layers = e.layers;

      // re-compute the radius of circles
      layers.eachLayer(function(layer){
        // circles are just Points and toGeoJSON won't store radius by default
        // so we store it inside the properties.
        if(layer.feature.properties.type === 'circle') {
          layer.feature.properties.radius = layer.getRadius();
        }
      });

      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_edited_features',
        layers.toGeoJSON());
      Shiny.onInputChange(map.id+'_draw_all_features',
        editableLayers.toGeoJSON());
    });

    map.on(L.Draw.Event.DELETED, function (e) {
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      var layers = e.layers;
      Shiny.onInputChange(map.id+'_draw_deleted_features',
        layers.toGeoJSON());
      Shiny.onInputChange(map.id+'_draw_all_features',
        editableLayers.toGeoJSON());
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

};

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
};
