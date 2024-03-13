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


// from https://github.com/rstudio/leaflet/blob/dc772e780317481e25335449b957c5f50082bcfd/javascript/src/methods.js#L221
function unpackStrings(iconset) {
  if (!iconset) {
    return iconset;
  }
  if (typeof(iconset.index) === "undefined") {
    return iconset;
  }

  iconset.data = asArray(iconset.data);
  iconset.index = asArray(iconset.index);

  return $.map(iconset.index, function(e, i) {
    return iconset.data[e];
  });
}

LeafletWidget.methods.addGreatCircles  = function(
  lat, lng, radius, layerId, group, options, icon, popup, popupOptions,
  label, labelOptions, highlightOptions, markerOptions) {
  if(!($.isEmptyObject(lat) || $.isEmptyObject(lng)) ||
      ($.isNumeric(lat) && $.isNumeric(lng))) {
    const map = this;

    let icondf;
    let getIcon;

    if (icon) {
      // Unpack icons
      icon.iconUrl         = unpackStrings(icon.iconUrl);
      icon.iconRetinaUrl   = unpackStrings(icon.iconRetinaUrl);
      icon.shadowUrl       = unpackStrings(icon.shadowUrl);
      icon.shadowRetinaUrl = unpackStrings(icon.shadowRetinaUrl);

      // This cbinds the icon URLs and any other icon options; they're all
      // present on the icon object.
      icondf = new LeafletWidget.DataFrame().cbind(icon);

      // Constructs an icon from a specified row of the icon dataframe.
      getIcon = function(i) {
        let opts = icondf.get(i);
        if (!opts.iconUrl) {
          return new L.Icon.Default();
        }

        // Composite options (like points or sizes) are passed from R with each
        // individual component as its own option. We need to combine them now
        // into their composite form.
        if (opts.iconWidth) {
          opts.iconSize = [opts.iconWidth, opts.iconHeight];
        }
        if (opts.shadowWidth) {
          opts.shadowSize = [opts.shadowWidth, opts.shadowHeight];
        }
        if (opts.iconAnchorX) {
          opts.iconAnchor = [opts.iconAnchorX, opts.iconAnchorY];
        }
        if (opts.shadowAnchorX) {
          opts.shadowAnchor = [opts.shadowAnchorX, opts.shadowAnchorY];
        }
        if (opts.popupAnchorX) {
          opts.popupAnchor = [opts.popupAnchorX, opts.popupAnchorY];
        }

        return new L.Icon(opts);
      };
    }
    if (icon) icondf.effectiveLength = lat.length;

    // Function to normalize access to values, either from arrays or scalars
    const getValue = (prop, index) => Array.isArray(prop) ? (prop[index] || prop[prop.length - 1]) : prop;

    const locations = [];
    for (let i = 0; i < lat.length; i++) {
        locations.push({
            lat: getValue(lat, i),
            lng: getValue(lng, i),
            layerId: getValue(layerId, i),
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
    locations.forEach((location, i) => {
      const latlong = new L.LatLng(location.lat, location.lng)

      // Create a geodesic circle for each location
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
      })
        //.addTo(map);
      map.layerManager.addLayer(geodesicCircle, "shape", location.layerId, group)

      if (label !== null) {
        if (labelOptions !== null) {
          geodesicCircle.bindTooltip(location.label, labelOptions)
        } else {
          geodesicCircle.bindTooltip(location.label)
        }
      }
      if (popup !== null) {
        if (popupOptions  !== null) {
          geodesicCircle.bindPopup(location.popup, popupOptions)
        } else {
          geodesicCircle.bindPopup(location.popup)
        }
      }

      if (icon) markerOptions.icon = getIcon(i);

      // Create a marker for each location
      const marker = L.marker(latlong, markerOptions)
        .addTo(map);
      if (label !== null) {
        if (labelOptions !== null) {
          marker.bindTooltip(location.label, labelOptions)
        } else {
          marker.bindTooltip(location.label)
        }
      }
      if (popup !== null) {
        if (popupOptions  !== null) {
          marker.bindPopup(location.popup, popupOptions)
        } else {
          marker.bindPopup(location.popup)
        }
      }

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
      marker.on('click', (e) => {
        console.log("click");console.log(e);
        // Listen for Events in Shinymode
        if (HTMLWidgets.shinyMode) {
          Shiny.onInputChange(map.id + "_geodesic_click", geodesicCircle.statistics);
        }
      });

      // Highlight -
      let highlightStyle = highlightOptions;
      if(!$.isEmptyObject(highlightStyle)) {
        let defaultStyle = {};
        $.each(highlightStyle, function (k, v) {
          if (k != "bringToFront" && k != "sendToBack"){
            if (location[k]) {
              defaultStyle[k] = location[k];
            }
          }
        });

        geodesicCircle.on("mouseover", function(e) {
            this.setStyle(highlightStyle);
            if(highlightStyle.bringToFront) {
              this.bringToFront();
            }
          });
        geodesicCircle.on("mouseout", function(e) {
            this.setStyle(defaultStyle);
            if(highlightStyle.sendToBack) {
              this.bringToBack();
            }
          });
      }

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
