/* global $, LeafletWidget, L */

function asArray(value) {
  if (value instanceof Array)
    return value;
  else
    return [value];
}

LeafletWidget.methods.addGroupedLayersControl = function(baseGroups, overlayGroups, options) {
  (function() {
    var map = this;
    // Only allow one layers control at a time
    LeafletWidget.methods.removeGroupedLayersControl.call(map);

    let firstLayer = true;
    const base = {};
    $.each(asArray(baseGroups), (i, g) => {
      const layer = map.layerManager.getLayerGroup(g, true);
      if (layer) {
        base[g] = layer;

        // Check if >1 base layers are visible; if so, hide all but the first one
        if (map.hasLayer(layer)) {
          if (firstLayer) {
            firstLayer = false;
          } else {
            map.removeLayer(layer);
          }
        }
      }
    });

    const groupedOverlays = {};
    Object.keys(overlayGroups).forEach(function(group) {
      // Initialize the group as an empty object
      groupedOverlays[group] = {};

      Object.keys(overlayGroups[group]).forEach(function(key) {
        var layerName = overlayGroups[group][key];
        // Assign the layer object to the groupedOverlays
        const layer = map.layerManager.getLayerGroup(layerName, true);
        if (layer) {
          groupedOverlays[group][key] = layer
        }
      });
    });

    if (options.exclusiveGroups) {
      options.exclusiveGroups = asArray(options.exclusiveGroups)
    }

    map.currentLayersControl = L.control.groupedLayers(base, groupedOverlays, options);
    map.addControl(map.currentLayersControl);

  }).call(this);
};

LeafletWidget.methods.addGroupedOverlay = function(group, name, groupname) {
  (function() {
    if (this.currentLayersControl) {
      var map = this;
      let layer = map.layerManager.getLayerGroup(group, true);
      if (layer) {
        map.currentLayersControl.addOverlay(layer, name, groupname);
      }
    }
  }).call(this);
};


LeafletWidget.methods.removeGroupedLayersControl = function() {
  (function() {
    if (this.currentLayersControl) {
      this.removeControl(this.currentLayersControl);
      this.currentLayersControl = null;
    }
  }).call(this);
};

