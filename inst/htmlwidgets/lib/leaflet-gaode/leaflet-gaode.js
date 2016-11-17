
LeafletWidget.methods.addTileGaodeMap = function(layerId, group) {
  this.layerManager.addLayer(
      L.tileLayer(
      'http://webrd0{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}', {
          subdomains: "1234"
        }), "tile", layerId, group);
};



LeafletWidget.methods.addTileGaodeSatellite = function(layerId, group) {
  this.layerManager.addLayer(
      L.tileLayer(
      'http://webst0{s}.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}', {
          subdomains: "1234"
        }), "tile", layerId, group);
};
