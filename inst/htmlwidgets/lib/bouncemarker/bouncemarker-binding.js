LeafletWidget.methods.addBounceMarkers = function(lat, lng, duration, height) {
  (function() {
   L.marker([lat, lng],
  {
    bounceOnAdd: true,
    bounceOnAddOptions: {duration: duration, height: height},
    bounceOnAddCallback: function() {console.log("done");}
  }).addTo(this);
  }).call(this);
};

