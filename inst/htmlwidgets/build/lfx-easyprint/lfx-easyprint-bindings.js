/* global LeafletWidget, $, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addEasyprint = function(options) {
  (function(){
    var map = this;
    if (map.easyprint) {
      map.easyprint.remove();
      delete map.easyprint;
    }

    map.easyprint =  new L.Control.EasyPrint(options);
    map.controls.add(map.easyprint);

  }).call(this);
};

LeafletWidget.methods.removeEasyprint = function() {
  (function(){
    var map = this;
    if(map.easyprint) {
      map.easyprint.remove();
      delete map.easyprint;
    }
  }).call(this);
};

LeafletWidget.methods.easyprintMap = function(sizeModes, filename) {
  (function(){
    if (this.easyprint) {
      // Hack based on @urakovaliaskar in https://github.com/rowanwins/leaflet-easyPrint/issues/105#issuecomment-550370793_
      this.easyprint.printMap(sizeModes + " page", filename);
    }
  }).call(this);
};

