/******/ (() => { // webpackBootstrap
var __webpack_exports__ = {};
/*!***********************************************************************!*\
  !*** ./inst/htmlwidgets/bindings/lfx-groupedlayercontrol-bindings.js ***!
  \***********************************************************************/
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
    const overlay = {};
    $.each(asArray(overlayGroups), (i, g) => {
      const layer = map.layerManager.getLayerGroup(g, true);
      if (layer) {
        overlay[g] = layer;
      }
    });

    console.log('options'); console.log(options);
    console.log('base'); console.log(base);
    console.log('overlay'); console.log(overlay);

    map.currentLayersControl = L.control.groupedLayers(base, overlay, options);
    map.addControl(map.currentLayersControl);

  });
};

LeafletWidget.methods.addGroupedOverlay = function(layer, name, group) {
  if (this.currentLayersControl) {
    console.log('layer'); console.log(layer);
    console.log('name'); console.log(name);
    console.log('group'); console.log(group);

    this.currentLayersControl.addOverlay(layer, name, group);
  }
};


LeafletWidget.methods.removeGroupedLayersControl = function() {
  if (this.currentLayersControl) {
    this.removeControl(this.currentLayersControl);
    this.currentLayersControl = null;
  }
};


/******/ })()
;