/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
LeafletWidget.methods.addOpacityControl = function(layerId, opacitygroup, buttons, slider, init_opac, options) {
  (function() {
    var map = this;

    // Add opacity control to a specific layer
    var opacity_layer =  map.layerManager.getLayerGroup(opacitygroup).getLayers()[0];

    // Button Controls
    if (buttons) {
      // TODO - This errors.. The `map` is not accessible for lfx-control-opacity.js
      //map.doubleClickZoom.disable(); locally fixed and PR 10 opened
      var higherOpacity = new L.Control.higherOpacity(options);
      var lowerOpacity = new L.Control.lowerOpacity(options);
      map.controls.add(higherOpacity, layerId+"_high");
      map.controls.add(lowerOpacity, layerId+"_low");
      if ((buttons && slider) || (buttons && !slider)) {
        higherOpacity.setOpacityLayer(opacity_layer);
      }
    }

    // Slider Control
    if (slider) {
      if (init_opac) options.init_opac = init_opac;
      var opacitySlider = new L.Control.opacitySlider(options);
      map.controls.add(opacitySlider, layerId+"_slide");
      if ((slider && buttons) || (slider && !buttons)) {
        opacitySlider.setOpacityLayer(opacity_layer);
      }
    }

    // Set initial opacity
    if (init_opac) {opacity_layer.setOpacity(init_opac)}

  }).call(this);
};


LeafletWidget.methods.removeOpacityControl = function(layerId) {
  this.controls.remove(layerId+"_high");
  this.controls.remove(layerId+"_low");
  this.controls.remove(layerId+"_slide");
};
