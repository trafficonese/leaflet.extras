/* global LeafletWidget, $, L, Shiny, HTMLWidgets */

LeafletWidget.methods.addDrawToolbar = function(targetLayerId, targetGroup, options) {
  (function(){

    // Copied from: https://github.com/rstudio/leaflet/blob/8b20549eeca9b7b66019f098a380422377666bc6/javascript/src/methods.js#L17
    function mouseHandler(mapId, layerId, group, eventName, extraInfo) {
      return function(e) {
        if (!HTMLWidgets.shinyMode) return;

        var eventInfo = $.extend(
          {
            id: layerId,
            '.nonce': Math.random()  // force reactivity
          },
          group !== null ? {group: group} : null,
          e.target.getLatLng ? e.target.getLatLng() : e.latlng,
          extraInfo
        );

        Shiny.onInputChange(mapId + '_' + eventName, eventInfo);
      };
    }

    var map = this;

    if(map.drawToolbar) {
      map.drawToolbar.removeFrom(map);
      delete map.drawToobar;
    }

    // FeatureGroup that will hold our drawn shapes/markers
    // This can be an existing GeoJSON layer whose features can be edited/deleted or new ones added.
    // OR an existing FeatureGroup whose features can be edited/deleted or new ones added.
    // OR a new FeatureGroup to hold drawn shapes.
    var editableFeatureGroup;

    if(targetLayerId) {
      // If we're given an existing GeoJSON layer find it and use it
      editableFeatureGroup = map.layerManager.getLayer('geojson', targetLayerId);
      if(editableFeatureGroup) {
        map._editableGeoJSONLayerId = targetLayerId;
      } else {
        // throw an error if we can't find the target GeoJSON layer
        throw 'GeoJSON layer with ID '+targetLayerId+' not Found';
      }
    } else {
      // If we're given an existing FeatureLayer use that.
      // In this case we don't throw an error if the specified FeatureGroup is not found,
      // we silently create a new one.
      if(!targetGroup) {
        targetGroup = 'editableFeatureGroup';
      }
      editableFeatureGroup = map.layerManager.getLayerGroup(targetGroup, true);
      map._editableFeatureGroupName = targetGroup;
    }

    // Create appropriate Marker Icon.
    if(options && options.draw && options.draw.marker) {
      if(options.draw.marker.markerIcon &&
        options.draw.marker.markerIconFunction) {
        options.draw.marker.icon =
          options.draw.marker.markerIconFunction(
            options.draw.marker.markerIcon);
      }
    }

    // create appropriate options
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

      editOptions.featureGroup = editableFeatureGroup;
      options.edit = editOptions;
    }

    map.drawToolbar =  new L.Control.Draw(options);
    map.drawToolbar.addTo(map);

    // Event Listeners
    map.on(L.Draw.Event.DRAWSTART, function(e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_start', {'feature_type': e.layerType});
    });

    map.on(L.Draw.Event.DRAWSTOP, function(e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_stop', {'feature_type': e.layerType});
    });

    map.on(L.Draw.Event.CREATED, function (e) {
      if (options.draw.singleFeature){
        if (editableFeatureGroup.getLayers().length > 0) {
          editableFeatureGroup.clearLayers();
        }
      }

      var layer = e.layer;
      editableFeatureGroup.addLayer(layer);

      // assign a unique key to the newly created feature
      var featureId = L.stamp(layer);
      layer.feature = {
        'type' : 'Feature',
        'properties' : {
          '_leaflet_id' : featureId,
          'feature_type' : e.layerType
        }
      };

      // circles are just Points and toGeoJSON won't store radius by default
      // so we store it inside the properties.
      if(typeof layer.getRadius === 'function') {
        layer.feature.properties.radius = layer.getRadius();
      }

      if (!HTMLWidgets.shinyMode) return;

      // Derive R leaflet layer category (shape, marker) from leaflet layer type
      var layerCategory = e.layerType;

      if (['rectangle', 'polygon', 'circle'].includes(layerCategory)) {
        layerCategory = 'shape';
      } else if (layerCategory === 'circlemarker') {
        layerCategory = 'marker';
      }

      // Add R leaflet click, etc, handlers.
      // Adjusted from: https://github.com/rstudio/leaflet/blob/8b20549eeca9b7b66019f098a380422377666bc6/javascript/src/methods.js#L355
      layer.on('click', mouseHandler(map.id, featureId, targetGroup, layerCategory + '_click'), map);
      layer.on('mouseover', mouseHandler(map.id, featureId, targetGroup, layerCategory + '_mouseover'), map);
      layer.on('mouseout', mouseHandler(map.id, featureId, targetGroup, layerCategory + '_mouseout'), map);

      Shiny.onInputChange(map.id+'_draw_new_feature',
        layer.toGeoJSON());
      Shiny.onInputChange(map.id+'_draw_all_features',
        editableFeatureGroup.toGeoJSON());
    });

    map.on(L.Draw.Event.EDITSTART, function (e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_editstart', true);
    });
    map.on(L.Draw.Event.EDITSTOP, function (e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_editstop', true);
    });

    map.on(L.Draw.Event.EDITED, function (e) {
      var layers = e.layers;
      layers.eachLayer(function(layer){
        var featureId = L.stamp(layer);
        if(!layer.feature) {
          layer.feature = {'type' : 'Feature'};
        }
        if(!layer.feature.properties) {
          layer.feature.properties = {};
        }
        layer.feature.properties._leaflet_id = featureId;
        layer.feature.properties.layerId = layer.options.layerId;
        if(typeof layer.getRadius === 'function') {
          layer.feature.properties.radius = layer.getRadius();
        }
      });

      if (!HTMLWidgets.shinyMode) return;

      Shiny.onInputChange(map.id+'_draw_edited_features',
        layers.toGeoJSON());
      Shiny.onInputChange(map.id+'_draw_all_features',
        editableFeatureGroup.toGeoJSON());
    });

    map.on(L.Draw.Event.DELETESTART, function (e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_deletestart', true);
    });

    map.on(L.Draw.Event.DELETESTOP, function (e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_deletestop', true);
    });

    map.on(L.Draw.Event.DELETED, function (e) {
      var layers = e.layers;
      layers.eachLayer(function(layer){
        var featureId = L.stamp(layer);
        if(!layer.feature) {
          layer.feature = {'type' : 'Feature'};
        }
        if(!layer.feature.properties) {
          layer.feature.properties = {};
        }
        layer.feature.properties._leaflet_id = featureId;
        layer.feature.properties.layerId = layer.options.layerId;
        if(typeof layer.getRadius === 'function') {
          layer.feature.properties.radius = layer.getRadius();
        }
      });

      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_deleted_features',
        layers.toGeoJSON());
      Shiny.onInputChange(map.id+'_draw_all_features',
        editableFeatureGroup.toGeoJSON());
    });

  }).call(this);

};

LeafletWidget.methods.removeDrawToolbar = function(clearFeatures) {
  (function(){

    var map = this;

    if(map.drawToolbar) {
      map.drawToolbar.removeFrom(map);
      delete map.drawToolbar;
    }
    if(map._editableFeatureGroupName && clearFeatures) {
      var featureGroup = map.layerManager.getLayerGroup(map._editableFeatureGroupName, false);
      featureGroup.clearLayers();
    }
    map._editableFeatureGroupName = null;
    if(map._editableGeoJSONLayerId && clearFeatures) {
      map.layerManager.removeLayer('geojson', map._editableGeoJSONLayerId);
    }
    map._editableGeoJSONLayerId = null;
  }).call(this);

};

LeafletWidget.methods.getDrawnItems = function() {
  var map = this;

  var featureGroup;
  if(map._editableGeoJSONLayerId) {
    featureGroup = map.layerManager.getLayer('geojson', map._editableGeoJSONLayerId);
  } else if(map._editableFeatureGroupName) {
    featureGroup = map.layerManager.getLayerGroup(map._editableFeatureGroupName, false);
  }
  if(featureGroup) {
    return featureGroup.toGeoJSON();
  } else {
    return null;
  }

};
