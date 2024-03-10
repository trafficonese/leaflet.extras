/******/ (() => { // webpackBootstrap
var __webpack_exports__ = {};
/*!************************************************************!*\
  !*** ./inst/htmlwidgets/bindings/lfx-geodesic-bindings.js ***!
  \************************************************************/
/* global $, LeafletWidget, L, HTMLWidgets */
LeafletWidget.methods.addGeodesicPolylines  = function(
  polygons, layerId, group, options, popup, popupOptions,
  label, labelOptions, highlightOptions) {
  if(polygons.length > 0) {
    var df = new LeafletWidget.DataFrame()
      .col('shapes', polygons)
      .col('layerId', layerId)
      .col('group', group)
      .col('popup', popup)
      .col('popupOptions', popupOptions)
      .col('label', label)
      .col('labelOptions', labelOptions)
      .col('highlightOptions', highlightOptions)
      .cbind(options);

    LeafletWidget.methods.addGenericLayers(this, 'shape', df,
      function(df, i) {
        var shapes = df.get(i, 'shapes');
        var ret_shapes = [];
        for (var j = 0; j < shapes.length; j++) {
          for (var k = 0; k < shapes[j].length; k++) {
            ret_shapes.push(
              HTMLWidgets.dataframeToD3(shapes[j][k])
            );
          }
        }
        return L.geodesic(ret_shapes, df.get(i));
      });
  }
};


LeafletWidget.methods.addGreatCircles  = function(
  lat, lng, radius, layerId, group, options, popup, popupOptions,
  label, labelOptions, highlightOptions) {
  if(!($.isEmptyObject(lat) || $.isEmptyObject(lng)) ||
      ($.isNumeric(lat) && $.isNumeric(lng))) {
    var df = new LeafletWidget.DataFrame()
      .col('lat', lat)
      .col('lng', lng)
      .col('radius', radius)
      .col('layerId', layerId)
      .col('group', group)
      .col('popup', popup)
      .col('popupOptions', popupOptions)
      .col('label', label)
      .col('labelOptions', labelOptions)
      .col('highlightOptions', highlightOptions)
      .cbind(options);

    var map = this;

    LeafletWidget.methods.addGenericLayers(this, 'shape', df,
      function(df, i) {
        var options = df.get(i);
        var Geodesic = L.geodesic([], options);
        var center = L.marker([df.get(i, 'lat'), df.get(i, 'lng')], {
          draggable: true,
          autoPan: false,
          autoPanPadding: L.Point(50, 50),
          autoPanSpeed: 10
        });

        console.log("addGenericLayers inside addGreatCircles is called");
        debugger;
        map.on('layeradd', function(e) {
          console.log("e"); console.log(e);
          debugger;
          if(e.layer === Geodesic) {
            center.on('dragend', function(e) {
              debugger;
              if(e.layer === Geodesic) {
                console.log("dragend is triggered")
              }
            });
            center.on('moveend', function(e) {
              debugger;
              if(e.layer === Geodesic) {
                console.log("moveend is triggered")
              }
            });
            center.addTo(map);
          }
        });

        map.on('layerremove', function(e) {
          if(e.layer === Geodesic) {
            map.removeLayer(center);
          }
        });

        Geodesic.createCircle([df.get(i, 'lat'), df.get(i, 'lng')], df.get(i, 'radius'));
        return Geodesic;
      });
  }
};

/******/ })()
;
//# sourceMappingURL=lfx-geodesic-bindings.js.map