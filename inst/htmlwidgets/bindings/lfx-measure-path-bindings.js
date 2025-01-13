/* global LeafletWidget */

LeafletWidget.methods.setMeasurementOptions = function(measurementOptions) {
  (function() {
    var map = this;
    map.measurementOptions = measurementOptions;
  }).call(this);
};

function matchesGroup(group, layer) {
  let parsedGroup;
  try {
    // Attempt to parse group if it's a JSON string
    parsedGroup = JSON.parse(group);
  } catch (e) {
    // If parsing fails, assume it's a plain string
    parsedGroup = group;
  }

  // Check if the group matches the layer's group
  return (
    parsedGroup == '' || // No group specified, apply to all layers
    (Array.isArray(parsedGroup) && parsedGroup.includes(layer.options && layer.options.group)) || // Group is an array
    (layer.options && layer.options.group === parsedGroup) // Group is a single string
  );
}

LeafletWidget.methods.enableMeasurements = function(group) {
  (function() {
    var map = this;
    var measurementOptions = map.measurementOptions || {};
    map.eachLayer(function(layer) {
      if (matchesGroup(group, layer)) {
        if (typeof layer.showMeasurements === 'function') {
          layer.showMeasurements(measurementOptions);
        }
      }
    });

  }).call(this);
};

LeafletWidget.methods.disableMeasurements = function(group) {
  (function() {
    var map = this;
    map.eachLayer(function(layer) {
      if (matchesGroup(group, layer)) {
        if (typeof layer.hideMeasurements === 'function') {
          layer.hideMeasurements();
        }
      }
    });

  }).call(this);
};

LeafletWidget.methods.refreshMeasurements = function(group) {
  (function() {
    var map = this;
    map.eachLayer(function(layer) {
      if (matchesGroup(group, layer)) {
        if (typeof layer.updateMeasurements === 'function') {
          layer.updateMeasurements();
        }
      }
    });

  }).call(this);
};
