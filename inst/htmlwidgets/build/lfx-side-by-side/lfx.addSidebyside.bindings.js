/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
LeafletWidget.methods.addSidebyside = function(layerId, leftId, rightId, options) {
  var map = this;

  /*
  The original JS (lfx-side-by-side.js) was modified by replacing all `getContainer` with `getPane`
  Based on this issue/comment https://github.com/digidem/leaflet-side-by-side/issues/4#issuecomment-285058096
  Maybe its possible to adapt the code, so its either possible to use getPane
  or getContainer, based on users wishes?
  */

  var left_pane  = map.layerManager.getLayer("tile", leftId);
  var right_pane = map.layerManager.getLayer("tile", rightId);

  var sidebysidecontrol = L.control.sideBySide(null, null, options)
         .setLeftLayers(left_pane)
         .setRightLayers(right_pane);

  map.controls.add(sidebysidecontrol, layerId);
};

LeafletWidget.methods.removeSidebyside = function(layerId) {
  this.controls.remove(layerId);
};
