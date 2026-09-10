/* global LeafletWidget, $, L, Shiny, HTMLWidgets */

LeafletWidget.methods.addDrawToolbar = function(targetLayerId,
  targetGroup, options) {

  // Copied from: https://github.com/rstudio/leaflet/blob/8b20549eeca9b7b66019f098a380422377666bc6/javascript/src/methods.js#L17
  function mouseHandler(mapId, layerId, group, eventName, extraInfo) {
    return function(e) {
      if (!HTMLWidgets.shinyMode) return;

      var eventInfo = $.extend({
        id: layerId,
        category: extraInfo,
        '.nonce': Math.random() // force reactivity
      },
      group !== null
        ? {group: group}
        : null,
      e.target._latlngs
        ? {latlngs: e.target._latlngs.flat()}
        : e.target._latlng,
      e.target._mRadius !== undefined
        ? { radius: e.target._mRadius }
        : {});

      Shiny.onInputChange(mapId + '_' + eventName, eventInfo);
    };
  }

  (function() {

    var map = this;

    if (map.drawToolbar) {
      map.drawToolbar.remove(map);
      delete map.drawToolbar;
    }

    // FeatureGroup that will hold our drawn shapes/markers
    // This can be an existing GeoJSON layer whose features can be edited/deleted or new ones added.
    // OR an existing FeatureGroup whose features can be edited/deleted or new ones added.
    // OR a new FeatureGroup to hold drawn shapes.
    var editableFeatureGroup;

    if (targetLayerId) {
      // If we're given an existing GeoJSON layer find it and use it
      editableFeatureGroup = map.layerManager.getLayer('geojson', targetLayerId);
      if (editableFeatureGroup) {
        map._editableGeoJSONLayerId = targetLayerId;
      } else {
        // throw an error if we can't find the target GeoJSON layer
        throw 'GeoJSON layer with ID ' + targetLayerId + ' not Found';
      }
    } else {
      // If we're given an existing FeatureLayer use that.
      // In this case we don't throw an error if the specified FeatureGroup is not found,
      // we silently create a new one.
      if (!targetGroup) {
        targetGroup = 'editableFeatureGroup';
      }

      editableFeatureGroup = map.layerManager.getLayerGroup(targetGroup, true);
      map._editableFeatureGroupName = targetGroup;
    }

    // Create appropriate Marker Icon.
    if (options && options.draw && options.draw.marker) {
      if (options.draw.marker.markerIcon &&
        options.draw.marker.markerIconFunction) {
        options.draw.marker.icon =
          options.draw.marker.markerIconFunction(options.draw.marker.markerIcon);
      }
    }

    // create appropriate options
    if (!$.isEmptyObject(options.edit)) {
      var editOptions = {};
      if (!options.edit.remove) {
        editOptions.remove = false;
      }

      if (!options.edit.edit) {
        editOptions.edit = false;
      } else if (!$.isEmptyObject(options.edit.selectedPathOptions)) {
        editOptions.edit = {};
        editOptions.edit.selectedPathOptions =
          options.edit.selectedPathOptions;
      }

      if (!$.isEmptyObject(options.edit.poly)) {
        editOptions.poly = options.edit.poly;
      }

      editOptions.featureGroup = editableFeatureGroup;
      options.edit = editOptions;

      if (options && options.edittoolbar) {
        var edittool = options.edittoolbar;
        var edittooldef = L.drawLocal.edit.toolbar;
        L.drawLocal.edit.toolbar.buttons = Object.assign({}, edittooldef.buttons, edittool.buttons);
        L.drawLocal.edit.toolbar.actions = Object.assign({}, edittooldef.actions, edittool.actions);
      }

      if (options && options.edithandlers) {
        var edithand = options.edithandlers;
        var edithandledef = L.drawLocal.edit.handlers;
        L.drawLocal.edit.handlers.edit = Object.assign({}, edithandledef.buttons, edithand.edit);
        L.drawLocal.edit.handlers.remove = Object.assign({}, edithandledef.actions, edithand.remove);
      }
    }

    // Set Toolbar / Handlers options if provided. Changes the default values.
    if (options && options.toolbar) {
      var rtool = options.toolbar;
      var tooldef = L.drawLocal.draw.toolbar;
      L.drawLocal.draw.toolbar.buttons = Object.assign({}, tooldef.buttons, rtool.buttons);
      L.drawLocal.draw.toolbar.actions = Object.assign({}, tooldef.actions, rtool.actions);
      L.drawLocal.draw.toolbar.finish = Object.assign({}, tooldef.finish, rtool.finish);
      L.drawLocal.draw.toolbar.undo = Object.assign({}, tooldef.undo, rtool.undo);
    }

    if (options && options.handlers) {
      var rhand = options.handlers;
      var handldef = L.drawLocal.draw.handlers;
      L.drawLocal.draw.handlers.circle = Object.assign({}, handldef.circle, rhand.circle);
      L.drawLocal.draw.handlers.circlemarker = Object.assign({}, handldef.circlemarker, rhand.circlemarker);
      L.drawLocal.draw.handlers.marker = Object.assign({}, handldef.marker, rhand.marker);
      L.drawLocal.draw.handlers.polygon = Object.assign({}, handldef.polygon, rhand.polygon);
      L.drawLocal.draw.handlers.polyline = Object.assign({}, handldef.polyline, rhand.polyline);
      L.drawLocal.draw.handlers.rectangle = Object.assign({}, handldef.rectangle, rhand.rectangle);
      L.drawLocal.draw.handlers.simpleshape = Object.assign({}, handldef.simpleshape, rhand.simpleshape);
    }

    // Create new Drawing Control
    map.drawToolbar = new L.Control.Draw(options);
    // Store event handlers in map property
    map.drawToolbar.eventHandler = {};
    map.drawToolbar.addTo(map);

    // Event Listeners
    map.drawToolbar.eventHandler.onDrawStart = function(e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_draw_start', {'feature_type': e.layerType, 'nonce': Math.random()});
    };
    map.on(L.Draw.Event.DRAWSTART, map.drawToolbar.eventHandler.onDrawStart);

    map.drawToolbar.eventHandler.onDrawStop = function(e) {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_draw_stop', {'feature_type': e.layerType, 'nonce': Math.random()});
    };
    map.on(L.Draw.Event.DRAWSTOP, map.drawToolbar.eventHandler.onDrawStop);

    map.drawToolbar.eventHandler.onCreated = function(e) {
      if (options.draw.singleFeature) {
        if (editableFeatureGroup.getLayers().length > 0) {
          editableFeatureGroup.clearLayers();
        }
      }

      var layer = e.layer;
      editableFeatureGroup.addLayer(layer);

      // assign a unique key to the newly created feature
      var featureId = L.stamp(layer);
      layer.feature = {
        'type': 'Feature',
        'properties': {
          '_leaflet_id': featureId,
          'feature_type': e.layerType
        }
      };

      // circles are just Points and toGeoJSON won't store radius by default
      // so we store it inside the properties.
      if (typeof layer.getRadius === 'function') {
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
      layer.on('click', mouseHandler(map.id, featureId, targetGroup, layerCategory + '_draw_click', layerCategory), map);
      layer.on('mouseover', mouseHandler(map.id, featureId, targetGroup, layerCategory + '_draw_mouseover', layerCategory), map);
      layer.on('mouseout', mouseHandler(map.id, featureId, targetGroup, layerCategory + '_draw_mouseout', layerCategory), map);

      Shiny.onInputChange(map.id + '_draw_new_feature',
        layer.toGeoJSON(), {priority: 'event'});
      Shiny.onInputChange(map.id + '_draw_all_features',
        editableFeatureGroup.toGeoJSON(), {priority: 'event'});
    };
    map.on(L.Draw.Event.CREATED, map.drawToolbar.eventHandler.onCreated);

    map.drawToolbar.eventHandler.onEditstart = function() {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_draw_editstart', true, {priority: 'event'});
    };
    map.on(L.Draw.Event.EDITSTART, map.drawToolbar.eventHandler.onEditstart);

    map.drawToolbar.eventHandler.onEditstop = function() {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_draw_editstop', true, {priority: 'event'});
    };
    map.on(L.Draw.Event.EDITSTOP, map.drawToolbar.eventHandler.onEditstop);

    map.drawToolbar.eventHandler.onEdited = function(e) {
      var layers = e.layers;
      layers.eachLayer(function(layer) {
        var featureId = L.stamp(layer);
        if (!layer.feature) {
          layer.feature = {'type': 'Feature'};
        }

        if (!layer.feature.properties) {
          layer.feature.properties = {};
        }

        layer.feature.properties._leaflet_id = featureId;
        layer.feature.properties.layerId = layer.options.layerId;
        if (typeof layer.getRadius === 'function') {
          layer.feature.properties.radius = layer.getRadius();
        }
      });

      if (!HTMLWidgets.shinyMode) return;

      Shiny.onInputChange(map.id + '_draw_edited_features',
        layers.toGeoJSON(), {priority: 'event'});
      Shiny.onInputChange(map.id + '_draw_all_features',
        editableFeatureGroup.toGeoJSON(), {priority: 'event'});
    };
    map.on(L.Draw.Event.EDITED, map.drawToolbar.eventHandler.onEdited);

    map.drawToolbar.eventHandler.onDeletestart = function() {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_draw_deletestart', true, {priority: 'event'});
    };
    map.on(L.Draw.Event.DELETESTART, map.drawToolbar.eventHandler.onDeletestart);

    map.drawToolbar.eventHandler.onDeletestop = function() {
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_draw_deletestop', true, {priority: 'event'});
    };
    map.on(L.Draw.Event.DELETESTOP, map.drawToolbar.eventHandler.onDeletestop);

    map.drawToolbar.eventHandler.onDeleted = function(e) {
      var layers = e.layers;
      layers.eachLayer(function(layer) {
        var featureId = L.stamp(layer);
        if (!layer.feature) {
          layer.feature = {'type': 'Feature'};
        }

        if (!layer.feature.properties) {
          layer.feature.properties = {};
        }

        layer.feature.properties._leaflet_id = featureId;
        layer.feature.properties.layerId = layer.options.layerId;
        if (typeof layer.getRadius === 'function') {
          layer.feature.properties.radius = layer.getRadius();
        }
      });

      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_draw_deleted_features',
        layers.toGeoJSON(), {priority: 'event'});
      Shiny.onInputChange(map.id + '_draw_all_features',
        editableFeatureGroup.toGeoJSON(), {priority: 'event'});
    };
    map.on(L.Draw.Event.DELETED, map.drawToolbar.eventHandler.onDeleted);

  }).call(this);

};

LeafletWidget.methods.removeDrawToolbar = function(clearFeatures) {
  (function() {

    var map = this;

    if (map.drawToolbar) {
      map.off(L.Draw.Event.DRAWSTART, map.drawToolbar.eventHandler.onDrawStart);
      map.off(L.Draw.Event.DRAWSTOP, map.drawToolbar.eventHandler.onDrawStop);
      map.off(L.Draw.Event.CREATED, map.drawToolbar.eventHandler.onCreated);
      map.off(L.Draw.Event.EDITSTART, map.drawToolbar.eventHandler.onEditstart);
      map.off(L.Draw.Event.EDITSTOP, map.drawToolbar.eventHandler.onEditstop);
      map.off(L.Draw.Event.EDITED, map.drawToolbar.eventHandler.onEdited);
      map.off(L.Draw.Event.DELETESTART, map.drawToolbar.eventHandler.onDeletestart);
      map.off(L.Draw.Event.DELETESTOP, map.drawToolbar.eventHandler.onDeletestop);
      map.off(L.Draw.Event.DELETED, map.drawToolbar.eventHandler.onDeleted);
      map.drawToolbar.remove(map);
      delete map.drawToolbar;
    }

    if (map._editableFeatureGroupName && clearFeatures) {
      var featureGroup = map.layerManager.getLayerGroup(map._editableFeatureGroupName, false);
      featureGroup.clearLayers();
    }

    map._editableFeatureGroupName = null;
    if (map._editableGeoJSONLayerId && clearFeatures) {
      map.layerManager.removeLayer('geojson', map._editableGeoJSONLayerId);
    }

    map._editableGeoJSONLayerId = null;
  }).call(this);

};


// TODO - not used for now. Missing R-function..Is it working?
LeafletWidget.methods.getDrawnItems = function() {
  var map = this;

  var featureGroup;
  if (map._editableGeoJSONLayerId) {
    featureGroup = map.layerManager.getLayer('geojson', map._editableGeoJSONLayerId);
  } else if (map._editableFeatureGroupName) {
    featureGroup = map.layerManager.getLayerGroup(map._editableFeatureGroupName, false);
  }

  if (featureGroup) {
    return featureGroup.toGeoJSON();
  } else {
    return null;
  }

};
