/* global $, LeafletWidget, L, Shiny, HTMLWidgets */

LeafletWidget.methods.addBingTiles = function(layerId, group, options) {
  (function(){
    var map = this;
    var apiKey = options.apiKey;
    delete options.apiKey;

    map.layerManager.addLayer(L.bingLayer(apiKey, options), "tile", layerId, group);

  }).call(this);
};

