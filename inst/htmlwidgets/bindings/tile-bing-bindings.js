/* global LeafletWidget, L */

LeafletWidget.methods.addBingTiles = function(layerId, group, options) {
  (function() {
    var map = this;
    var apikey = options.apikey;
    delete options.apikey;

    map.layerManager.addLayer(L.bingLayer(apikey, options), 'tile', layerId, group);

  }).call(this);
};
