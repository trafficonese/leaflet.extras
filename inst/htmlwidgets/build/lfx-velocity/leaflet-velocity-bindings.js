LeafletWidget.methods.addVelocity = function(layerId, group, content, options) {

  var velocityLayer = L.velocityLayer({
        // REQUIRED !!
        data: content,

        // Display Options
        displayValues: (options && options.displayValues) ? options.displayValues : true,
        displayOptions: {
          velocityType: (options && options.velocityType) ? options.velocityType : 'Global Wind',
          position: (options && options.position) ? options.position : 'bottomleft',
      		emptyString: (options && options.emptyString) ? options.emptyString : 'No velocity data',
      		angleConvention: (options && options.angleConvention) ? options.angleConvention : 'bearingCW',
      		speedUnit: (options && options.speedUnit) ? options.speedUnit : 'm/s',
          displayPosition: (options && options.displayPosition) ? options.displayPosition : 'bottomleft',
          displayEmptyString: (options && options.displayEmptyString) ? options.displayEmptyString : 'No wind data'
        },

        // OPTIONAL
      	minVelocity: (options && options.minVelocity) ? options.minVelocity : 0,
      	maxVelocity: (options && options.maxVelocity) ? options.maxVelocity : 10,
      	velocityScale:  (options && options.velocityScale) ? options.velocityScale : 0.005,
      	particleAge: (options && options.particleAge) ? options.particleAge : 90,
      	lineWidth: (options && options.lineWidth) ? options.lineWidth : 1,
      	particleMultiplier: (options && options.particleMultiplier) ? options.particleMultiplier : 1/300,
      	frameRate: (options && options.frameRate) ? options.frameRate : 15,
      	colorScale:  (options && options.colorScale) ? options.colorScale : null,       // define your own array of hex/rgb colors

      	onAdd: null,          // callback function
      	onRemove: null,       // callback function

      	// optional pane to add the layer, will be created if doesn't exist
      	paneName: (options && options.paneName) ? options.paneName : 'overlayPane'
      });

  this.layerManager.addLayer(velocityLayer, "velocity", layerId, group);
};

LeafletWidget.methods.removeVelocity  = function(layerId) {
  this.layerManager.removeLayer("velocity", layerId);
};



