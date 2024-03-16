/******/ (() => { // webpackBootstrap
var __webpack_exports__ = {};
/*!****************************************************************!*\
  !*** ./inst/htmlwidgets/bindings/lfx-bouncemarker-bindings.js ***!
  \****************************************************************/
/* global LeafletWidget, L */

LeafletWidget.methods.addBounceMarkers = function(lat, lng, duration, height) {
  (
    function() {
      L.marker(
        [lat, lng],
        {
          bounceOnAdd: true,
          bounceOnAddOptions: {
            duration: duration,
            height: height
          }
        }
      ).addTo(this);
    }
  ).call(this);
};

/******/ })()
;
//# sourceMappingURL=lfx-bouncemarker-bindings.js.map