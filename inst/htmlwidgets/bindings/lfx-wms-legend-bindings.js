/* global LeafletWidget, L */
LeafletWidget.methods.addWMSLegend = function(options) {
  (function() {
    var map = this;
    var wmsLegendControl = new L.Control.WMSLegend(options.options);

    // Use the layername as ID if possble
    if (!options.layerId) {
      const match = wmsLegendControl.options.uri.match(/layer=([^&]+)/);
      if (match && match[1]) {
        options.layerId = match[1];
      } else {
        options.layerId = L.Util.stamp(wmsLegendControl);
      }
    }

    map.on('layeradd', function(e) {
      const wmslayer = map.layerManager.getLayer('tile', options.layerId);
      if (wmslayer && wmslayer.options) {
        if (e.layer.options.layers == wmslayer.options.layers) {
          map.controls.add(wmsLegendControl, options.layerId);
        }
      }
    });
    map.on('layerremove', function(e) {
      const wmslayer = map.layerManager.getLayer('tile', options.layerId);
      if (wmslayer && wmslayer.options) {
        if (e.layer.options.layers == map.layerManager.getLayer('tile', options.layerId).options.layers) {
          map.controls.remove(options.layerId);
        }
      }
    });

    map.controls.add(wmsLegendControl, options.layerId);

  }).call(this);
};
