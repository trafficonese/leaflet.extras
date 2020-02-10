/* global LeafletWidget, $, L, Tangram, gui */
LeafletWidget.methods.addTangram = function(layerId, group, options) {
  var map = this;

  var tangramLayer = Tangram.leafletLayer(options);

  this.layerManager.addLayer(tangramLayer, "tangram-js", layerId, group);

};

