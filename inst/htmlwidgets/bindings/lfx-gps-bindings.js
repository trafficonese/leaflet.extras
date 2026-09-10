/* global LeafletWidget, L, HTMLWidgets, Shiny */

LeafletWidget.methods.addControlGPS = function(options) {
  (function() {
    var map = this;
    if (map.gpscontrol) {
      map.gpscontrol.remove(map);
      delete map.gpscontrol;
    }

    map.gpscontrol = new L.Control.Gps(options);

    map.gpscontrol.on('gps:located', function(e) {
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_gps_located', {
        'coordinates': e.latlng,
        'radius': e.marker._radius
      });
    });
    map.gpscontrol.on('gps:disabled', function() {
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_gps_disabled', {});
    });
    map.gpscontrol.addTo(map);
  }).call(this);
};

LeafletWidget.methods.removeControlGPS = function() {
  (function() {
    var map = this;
    if (map.gpscontrol) {
      map.gpscontrol.remove(map);
      delete map.gpscontrol;
    }
  }).call(this);
};

LeafletWidget.methods.activateGPS = function() {
  (function() {
    var map = this;
    if (map.gpscontrol) {
      map.gpscontrol.activate();
    }
  }).call(this);
};

LeafletWidget.methods.deactivateGPS = function() {
  (function() {
    var map = this;
    if (map.gpscontrol) {
      map.gpscontrol.deactivate();
    }
  }).call(this);
};

LeafletWidget.methods.getLocation = function() {
  return (function() {
    var map = this;
    if (map.gpscontrol) {
      return map.gpscontrol.getLocation();
    } else {
      throw 'GPS Control not added to the map';
    }
  }).call(this);
};
