/* global LeafletWidget, L */
LeafletWidget.methods.addWMSLegend = function(options) {
  (function() {
    var map = this;
    var wmsLegendControl = new L.Control.WMSLegend(options.options);

    if (options.group) {
      // Auto generate a layerID if not provided
      if(!options.layerId) {
        options.layerId = L.Util.stamp(wmsLegendControl);
      }

      map.on("overlayadd", function(e){
        if(e.name === options.group) {
          map.controls.add(wmsLegendControl, options.layerId);
        }
      });
      map.on("overlayremove", function(e){
        if(e.name === options.group) {
          map.controls.remove(options.layerId);
        }
      });
      map.on("groupadd", function(e){
        if(e.name === options.group) {
          map.controls.add(wmsLegendControl, options.layerId);
        }
      });
      map.on("groupremove", function(e){
        if(e.name === options.group) {
          map.controls.remove(options.layerId);
        }
      });
    }

    map.controls.add(wmsLegendControl, options.layerId);

  }).call(this);
};
