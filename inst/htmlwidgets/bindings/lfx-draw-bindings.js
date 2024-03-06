/* global LeafletWidget, $, L, Shiny, HTMLWidgets */

LeafletWidget.methods.addDrawToolbar = function(targetLayerId, targetGroup, options) {
  (function(){

    var map = this;

    if(map.drawToolbar) {
      map.drawToolbar.remove(map);
      delete map.drawToolbar;
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

    // Set Toolbar / Handlers options if provided. Changes the default values.
    if (options && options.toolbar) {
      var rtool = options.toolbar;
      var tooldef = L.drawLocal.draw.toolbar;
      L.drawLocal.draw.toolbar.buttons.polygon = rtool.buttons.polygon ? rtool.buttons.polygon : tooldef.buttons.polygon;
      L.drawLocal.draw.toolbar.buttons.polyline = rtool.buttons.polyline ? rtool.buttons.polyline : tooldef.buttons.polyline;
      L.drawLocal.draw.toolbar.buttons.rectangle = rtool.buttons.rectangle ? rtool.buttons.rectangle : tooldef.buttons.rectangle;
      L.drawLocal.draw.toolbar.buttons.circle = rtool.buttons.circle ? rtool.buttons.circle : tooldef.buttons.circle;
      L.drawLocal.draw.toolbar.buttons.marker = rtool.buttons.marker ? rtool.buttons.marker : tooldef.buttons.marker;
      L.drawLocal.draw.toolbar.buttons.circlemarker = rtool.buttons.circlemarker ? rtool.buttons.circlemarker : tooldef.buttons.circlemarker;

      L.drawLocal.draw.toolbar.actions.title = rtool.actions.title ? rtool.actions.rectangle : tooldef.actions.title;
      L.drawLocal.draw.toolbar.actions.text = rtool.actions.text ? rtool.actions.text : tooldef.actions.text;

      L.drawLocal.draw.toolbar.finish.title = rtool.finish.title ? rtool.finish.rectangle : tooldef.finish.title;
      L.drawLocal.draw.toolbar.finish.text = rtool.finish.text ? rtool.finish.text : tooldef.finish.text;

      L.drawLocal.draw.toolbar.undo.title = rtool.undo.title ? rtool.undo.rectangle : tooldef.undo.title;
      L.drawLocal.draw.toolbar.undo.text = rtool.undo.text ? rtool.undo.text : tooldef.undo.text;
    }
    if (options && options.handlers) {
      var rhand = options.handlers;
      var handldef = L.drawLocal.draw.handlers;
      L.drawLocal.draw.handlers.circle.radius = rhand.circle.radius ? rhand.circle.radius : handldef.circle.radius;
      L.drawLocal.draw.handlers.circle.tooltip.start = rhand.circle.tooltip.start ? rhand.circle.tooltip.start : handldef.circle.tooltip.start;

      L.drawLocal.draw.handlers.circlemarker.tooltip.start = rhand.circlemarker.tooltip.start ? rhand.circlemarker.tooltip.start : handldef.circlemarker.tooltip.start;

      L.drawLocal.draw.handlers.marker.tooltip.start = rhand.marker.tooltip.start ? rhand.marker.tooltip.start : handldef.marker.tooltip.start;

      L.drawLocal.draw.handlers.polygon.tooltip.start = rhand.polygon.tooltip.start ? rhand.polygon.tooltip.start : handldef.polygon.tooltip.start;
      L.drawLocal.draw.handlers.polygon.tooltip.cont = rhand.polygon.tooltip.cont ? rhand.polygon.tooltip.cont : handldef.polygon.tooltip.cont;
      L.drawLocal.draw.handlers.polygon.tooltip.end = rhand.polygon.tooltip.end ? rhand.polygon.tooltip.end : handldef.polygon.tooltip.end;

      L.drawLocal.draw.handlers.polyline.error = rhand.polyline.error ? rhand.polyline.error : handldef.polyline.error;
      L.drawLocal.draw.handlers.polyline.tooltip.start = rhand.polyline.tooltip.start ? rhand.polyline.tooltip.start : handldef.polyline.tooltip.start;
      L.drawLocal.draw.handlers.polyline.tooltip.cont = rhand.polyline.tooltip.cont ? rhand.polyline.tooltip.cont : handldef.polyline.tooltip.cont;
      L.drawLocal.draw.handlers.polyline.tooltip.end = rhand.polyline.tooltip.end ? rhand.polyline.tooltip.end : handldef.polyline.tooltip.end;

      L.drawLocal.draw.handlers.rectangle.tooltip.start = rhand.rectangle.tooltip.start ? rhand.rectangle.tooltip.start : handldef.rectangle.tooltip.start;
    }

    // Create new Drawing Control
    map.drawToolbar =  new L.Control.Draw(options);
    map.drawToolbar.addTo(map);

    // Event Listeners
    map.on(L.Draw.Event.DRAWSTART, function(e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_start', {'feature_type': e.layerType, 'nonce': Math.random()});
    });

    map.on(L.Draw.Event.DRAWSTOP, function(e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_draw_stop', {'feature_type': e.layerType,'nonce': Math.random()});
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
      map.drawToolbar.remove(map);
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
