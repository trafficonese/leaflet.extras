/* global LeafletWidget, L */
LeafletWidget.methods.addWMSLegend = function(options) {
  (function(){
    var map = this;
    var wmsLegendControl = new L.Control.WMSLegend(options.options);
    if (options.layerId) {
      map.controls.add(wmsLegendControl, options.layerId);
    } else {
      map.controls.add(wmsLegendControl);
    }
  }).call(this);
};
