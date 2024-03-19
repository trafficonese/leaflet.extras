/* global LeafletWidget */

LeafletWidget.methods.setMeasurementOptions = function(measurementOptions) {
  (function() {
    var map = this;
    map.measurementOptions = measurementOptions;
  }).call(this);
};

LeafletWidget.methods.enableMeasurements = function() {
  (function() {
    var map = this;
    var measurementOptions = map.measurementOptions || {};
    map.eachLayer(function(layer) {
      if (typeof layer.showMeasurements === 'function') {
        layer.showMeasurements(measurementOptions);
      }
    });

  }).call(this);
};

LeafletWidget.methods.disableMeasurements = function() {
  (function() {
    var map = this;
    map.eachLayer(function(layer) {
      if (typeof layer.hideMeasurements === 'function') {
        layer.hideMeasurements();
      }
    });

  }).call(this);
};

LeafletWidget.methods.refreshMeasurements = function() {
  (function() {
    var map = this;
    map.eachLayer(function(layer) {
      if (typeof layer.updateMeasurements === 'function') {
        layer.updateMeasurements();
      }
    });

  }).call(this);
};
