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
  label, labelOptions, highlightOptions, markerOptions) {
  if(!($.isEmptyObject(lat) || $.isEmptyObject(lng)) ||
      ($.isNumeric(lat) && $.isNumeric(lng))) {
    const map = this;

    // Function to normalize access to values, either from arrays or scalars
    const getValue = (prop, index) => Array.isArray(prop) ? (prop[index] || prop[prop.length - 1]) : prop;

    const locations = [];
    for (let i = 0; i < lat.length; i++) {
        locations.push({
            lat: getValue(lat, i),
            lng: getValue(lng, i),
            radius: getValue(radius, i),
            popup: getValue(popup, i),
            label: getValue(label, i),
            weight: getValue(options.weight, i),
            color: getValue(options.color, i),
            opacity: getValue(options.opacity, i),
            steps: getValue(options.steps, i),
        });
    }
    console.log("locations"); console.log(locations)
    console.log("options");console.log(options);

    // Add GeodesicCircle and Center Marker
    locations.forEach(location => {
      const latlong = new L.LatLng(location.lat, location.lng)
      // Create a marker for each location
      const marker = L.marker(latlong, markerOptions)
        .bindTooltip(location.label, labelOptions)
        .bindPopup(location.popup, popupOptions)
        .addTo(map);

      // Create a geodesic circle for each marker
      const geodesicCircle = new L.GeodesicCircle(latlong, {
          weight: location.weight,
          opacity: location.opacity,
          color: location.color,
          steps: location.steps,
          fill: options.fill === true,
          wrap: options.wrap === true,
          dashArray: options.dashArray,
          smoothFactor: options.smoothFactor,
          noClip: options.noClip,
      }).addTo(map);

      // Drag event listener for Center marker
      marker.on('drag', (e) => {
          // Update the geodesic circle's position and information
          geodesicCircle.setLatLng(e.latlng);

          // Assuming 'info' and 'updateInfo' function are defined elsewhere to update the control based on new stats
          if (options.showStats) {
            updateInfo(geodesicCircle.statistics); // You need to define or adjust the 'updateInfo' function
          }

          // Listen for Events in Shinymode
          if (HTMLWidgets.shinyMode) {
            Shiny.onInputChange(map.id + "_geodesic_stats", geodesicCircle.statistics);
          }
      });

      // Highlight -
      // TODO - Not working as Circle is a Polyline and therefore `mouseout` is not trigered
      /*
      let highlightStyle = highlightOptions;
      if(!$.isEmptyObject(highlightStyle)) {
        console.log("highlightOptions");console.log(highlightOptions);
        let defaultStyle = {};
        $.each(highlightStyle, function (k, v) {
          console.log("location");console.log(location);
          console.log("k");console.log(k);
          console.log("v");console.log(v);
          if (k != "bringToFront" && k != "sendToBack"){
            if (location[k]) {
              defaultStyle[k] = location[k];
            }
          }
        });

        geodesicCircle.on("mouseover",
          function(e) {
            this.setStyle(highlightStyle);
            if(highlightStyle.bringToFront) {
              this.bringToFront();
            }
          });
        geodesicCircle.on("mouseout",
          function(e) {
            this.setStyle(defaultStyle);
            if(highlightStyle.sendToBack) {
              this.bringToBack();
            }
          });
      }
      */


    });


    if (options.showStats) {
      // Info control
      var info = L.control();
      info.onAdd = function(map) {
          this._div = L.DomUtil.create('div', 'info');
          return this._div;
      };
      info.addTo(map);


      // Define a function to update the info control based on passed statistics
      function updateInfo(stats, statsFunction) {
        console.log("update info"); console.log(stats);
        var infoHTML = "";
        if (typeof options.statsFunction === "function") {
          // If additionalInput is a function, use it to generate content exclusively
          infoHTML = options.statsFunction(stats);
        } else {
          // Default content generation logic
          const totalDistance = stats.totalDistance ? (stats.totalDistance > 10000 ? (stats.totalDistance / 1000).toFixed(0) + ' km' : stats.totalDistance.toFixed(0) + ' m') : 'invalid';
          infoHTML = '<h4>Statistics</h4>' +
            '<b>Total Distance</b><br/>' + totalDistance +
            '<br/><br/><b>Points</b><br/>' + stats.points +
            '<br/><br/><b>Vertices</b><br/>' + stats.vertices;
        }
        // Update the innerHTML of the info div with the constructed info HTML or leave it empty
        info._div.innerHTML = infoHTML;
      }
    }


  }
};

/******/ })()
;
//# sourceMappingURL=lfx-geodesic-bindings.js.map