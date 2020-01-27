/* global LeafletWidget, $, L, topojson, csv2geojson, toGeoJSON */
LeafletWidget.methods.addReachability = function(options) {
  var map = this;
  var reachability = L.control.reachability(options);
  reachability.addTo(map);
  map.controls.add(reachability);

  // Listen for the event fired when reachability areas are created on the map
  map.on('reachability:displayed', function (e) {
    /*
    console.log("reachability.latestIsolines");console.log(reachability.latestIsolines);
    console.log("reachability.isolinesGroup");console.log(reachability.isolinesGroup);
    console.log("reachability:displayed");
    */
    Shiny.onInputChange(map.id + "_reachability_displayed", null);
  });
  map.on('reachability:delete', function (e) {
    //console.log("reachability:delete");
    Shiny.onInputChange(map.id + "_reachability_delete", null);
  });
  map.on('reachability:error', function (e) {
    //console.log("reachability:error");
    Shiny.onInputChange(map.id + "_reachability_error", null);
  });
};

LeafletWidget.methods.removeReachability = function() {
  this.controls.clear();
};



