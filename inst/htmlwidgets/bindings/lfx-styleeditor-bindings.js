/* global LeafletWidget, L */
LeafletWidget.methods.addStyleEditor = function(options) {
  (function() {
    var map = this;
    if (map.styleEditor) {
      map.styleEditor.remove(map);
      delete map.styleEditor;
    }

    var styleEditor = L.control.styleEditor(options);
    styleEditor.addTo(map);
    map.styleEditor = styleEditor;


    /*
    if (HTMLWidgets.shinyMode) {
      map.on('styleeditor:visible', function(element){
        console.log("visible");console.log(element);
      });
      map.on('styleeditor:hidden', function(element){
        console.log("hidden");console.log(element);
      });
      map.on('styleeditor:changed', function(element){
        console.log("changed");console.log(element);
      });
      map.on('styleeditor:editing', function(element){
        console.log("editing");console.log(element);
      });
      map.on('styleeditor:marker', function(element){
        console.log("marker");
        console.log(element);
      });
      map.on('styleeditor:geometry', function(element){
        console.log("geometry");
        console.log(element);
      });
    };
    */

  }).call(this);
};

LeafletWidget.methods.removeStyleEditor = function() {
  (function() {
    var map = this;
    if (map.styleEditor) {
      map.styleEditor.remove(map);
      delete map.styleEditor;
    }
  }).call(this);
};
