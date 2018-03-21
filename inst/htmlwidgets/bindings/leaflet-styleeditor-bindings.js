/* global LeafletWidget, L */
LeafletWidget.methods.addStyleEditor = function(options) {
  (function(){

    var map = this;

    if(map.styleEditor) {
      map.styleEditor.removeFrom(map);
      map.styleEditor = null;
    }
    
    var styleEditor = L.control.styleEditor(options);
    styleEditor.addTo(map);
    map.styleEditor = styleEditor;
  }).call(this);
};

LeafletWidget.methods.removeStyleEditor = function() {
  (function(){

    var map = this;

    if(map.styleEditor) {
      map.styleEditor.removeFrom(map);
      map.styleEditor = null;
    }
  }).call(this);

};
