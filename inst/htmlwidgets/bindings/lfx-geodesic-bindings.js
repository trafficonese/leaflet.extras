/* global $, LeafletWidget, L */

import { unpackStrings, handleEvent } from './utils.js';

LeafletWidget.methods.addGeodesicPolylines = function(polygons, layerId, group,
  options, icon, popup, popupOptions, label, labelOptions, highlightOptions,
  markerOptions) {

  if (polygons.length > 0) {

    const map = this;

    // Show Statistics in InfoControl
    var info = L.control();
    info.onAdd = function() {
      this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
      return this._div;
    };

    const updateInfo = function(stats, statsFunction) {
      if (!options.showStats) return;

      var infoHTML = '';
      if (typeof statsFunction === 'function') {
        // If additionalInput is a function, use it to generate content exclusively
        infoHTML = statsFunction(stats);
      } else {
        const totalDistance = (stats.totalDistance
          ? (stats.totalDistance > 10000) ?
            (stats.totalDistance / 1000).toFixed(0) + ' km' :
            (stats.totalDistance).toFixed(0) + ' m'
          : 'invalid');
        infoHTML = '<h4>Statistics</h4><b>totalDistance</b><br/>' + totalDistance +
            '<br/><br/><b>Points</b><br/>' + stats.points +
            '<br/><br/><b>Vertices</b><br/>' + stats.vertices;
      }

      // Update the innerHTML of the info div with the constructed info HTML or leave it empty
      info._div.innerHTML = infoHTML;
    };

    info.update = updateInfo;
    if (options.showStats) {
      info.addTo(map);
    }

    // Save Lines in DataFrame
    const df = new LeafletWidget.DataFrame()
      .col('polygons', polygons)
      .col('popup', popup)
      .col('layerId', layerId)
      .col('label', label)
      .col('group', group)
      .col('highlightOptions', highlightOptions)
      .cbind(options);

    // Array to store Geodesic objects
    const geodesics = [];

    // Get Leaflet or AwesomeMarker Icons
    let icondf;
    let getIcon;
    if (icon) {
      // Unpack icons
      if (!icon.awesomemarker) {
        icon.iconUrl = unpackStrings(icon.iconUrl);
        icon.iconRetinaUrl = unpackStrings(icon.iconRetinaUrl);
        icon.shadowUrl = unpackStrings(icon.shadowUrl);
        icon.shadowRetinaUrl = unpackStrings(icon.shadowRetinaUrl);
      }

      // This cbinds the icon URLs and any other icon options; they're all
      // present on the icon object.
      icondf = new LeafletWidget.DataFrame().cbind(icon);

      // Constructs an icon from a specified row of the icon dataframe.
      getIcon = function(id) {
        const opts = icondf.get(id);
        if (!opts) {
          if (opts.awesomemarker) {
            return new L.AwesomeMarkers.icon();
          } else {
            return new L.Icon.Default();
          }
        }

        if (opts.awesomemarker) {
          delete opts.awesomemarker;
          if (opts.squareMarker) {
            opts.className = 'awesome-marker awesome-marker-square';
          }

          if (!opts.prefix) {
            opts.prefix = icon.library;
          }

          return new L.AwesomeMarkers.icon(opts);
        } else {
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
        }
      };
    }

    if (icon) icondf.effectiveLength = polygons.length;

    for (let i = 0; i < df.nrow(); i++) {
      // Add L.geodesic for every Polyline
      const geogesic_coords = df.get(i, 'polygons')[0].flatMap(obj =>
        obj.lat.map((lat, i) => ({lat, lng: obj.lng[i]})));
      const Geodesic = L.geodesic(geogesic_coords, df.get(i));
      updateInfo.call(info, Geodesic.statistics);
      map.layerManager.addLayer(Geodesic, 'shape', df.get(i, 'layerId'), df.get(i, 'group'), null, null);

      // Add Node Markers
      if (options.showMarker) {
        var markers = [];
        for (const place of geogesic_coords) {
          // Get markerOptions and add Icon
          markerOptions = markerOptions
            ? markerOptions
            : {};
          if (options.showMarker && icon) markerOptions.icon = getIcon(i);

          // Create Marker and append label / popup if present
          var marker = L.marker(place, markerOptions);
          if (label !== null) {
            if (labelOptions !== null) {
              marker.bindTooltip(df.get(i, 'label'), labelOptions);
            } else {
              marker.bindTooltip(df.get(i, 'label'));
            }
          }

          if (popup !== null) {
            if (popupOptions !== null) {
              marker.bindPopup(df.get(i, 'popup'), popupOptions);
            } else {
              marker.bindPopup(df.get(i, 'popup'));
            }
          }

          // Add Markers to Map
          map.layerManager.addLayer(marker, 'markers', null, group, null, null);

          // Add/Remove Markers when its Geodesic is added/removed (Using fake ID)
          map.on('layeradd', function(e) {
            if (e.layer === Geodesic) {
              map.layerManager.addLayer(marker, 'marker', '______fake_layerid', group, null, null);
            }
          });
          map.on('layerremove', function(e) {
            if (e.layer === Geodesic) {
              map.layerManager.removeLayer('marker', '______fake_layerid');
            }
          });
          // Use Drag event and trigger custom `geodesicdrag` event for updating
          marker.on('drag', () => {
            map.fire('geodesicdrag', { index: i });
          });
          markers.push(marker);
        }
      }

      // Push to Geodesics Array
      geodesics.push({ Geodesic, markers });


      // Highlight
      let highlightStyle = df.get(i,"highlightOptions");
      if(!$.isEmptyObject(highlightStyle)) {
        let defaultStyle = {};
        $.each(highlightStyle, function (k, v) {
          if(k != "bringToFront" && k != "sendToBack"){
            if(df.get(i, k)) {
              defaultStyle[k] = df.get(i, k);
            }
          }
        });

        Geodesic.on("mouseover",
          function(e) {
            this.setStyle(highlightStyle);
            if(highlightStyle.bringToFront) {
              this.bringToFront();
            }
          });
        Geodesic.on("mouseout",
          function(e) {
            this.setStyle(defaultStyle);
            if(highlightStyle.sendToBack) {
              this.bringToBack();
            }
          });
      }
    }

    // Update a Geodesic LatLong and update Stats Control on custom `geodesicdrag` event
    const updateGeodesic = function(e) {
      const { index } = e;
      const currentLine = [];
      for (const point of geodesics[index].markers) {
        currentLine.push(point.getLatLng());
      }

      geodesics[index].Geodesic.setLatLngs(currentLine);
      updateInfo.call(info, geodesics[index].Geodesic.statistics);
    };

    map.on('geodesicdrag', updateGeodesic);
  }

};

LeafletWidget.methods.addLatLng = function(lat, lng, layerId) {
  //console.log('lat'); console.log(lat);
  //console.log('lng'); console.log(lng);
  //console.log('layerId'); console.log(layerId);
  // Check if the geodesic object exists
  const map = this;
  const geodesic = map.layerManager.getLayer('shape', layerId);
  if (geodesic) {
    // Add the new latlng point to the geodesic object
    geodesic.addLatLng({'lat': lat, 'lng': lng});
    // Create Marker
    var marker = L.marker({'lat': lat, 'lng': lng});
    map.layerManager.addLayer(marker, 'markers', null, null, null, null);
  } else {
    console.error('Geodesic object is not initialized.');
  }
};

LeafletWidget.methods.addGreatCircles = function(lat, lng, radius, layerId,
  group, options, icon, popup, popupOptions, label, labelOptions,
  highlightOptions, markerOptions) {

  if (!($.isEmptyObject(lat) || $.isEmptyObject(lng)) ||
      ($.isNumeric(lat) && $.isNumeric(lng))) {

    const map = this;

    // Icon (Copy form Leaflet)
    let icondf;
    let getIcon;
    if (icon) {
      // Unpack icons
      if (!icon.awesomemarker) {
        icon.iconUrl = unpackStrings(icon.iconUrl);
        icon.iconRetinaUrl = unpackStrings(icon.iconRetinaUrl);
        icon.shadowUrl = unpackStrings(icon.shadowUrl);
        icon.shadowRetinaUrl = unpackStrings(icon.shadowRetinaUrl);
      }

      // This cbinds the icon URLs and any other icon options; they're all
      // present on the icon object.
      icondf = new LeafletWidget.DataFrame().cbind(icon);

      // Constructs an icon from a specified row of the icon dataframe.
      getIcon = function(i) {
        const opts = icondf.get(i);
        if (!opts) {
          if (opts.awesomemarker) {
            return new L.AwesomeMarkers.icon();
          } else {
            return new L.Icon.Default();
          }
        }

        if (opts.awesomemarker) {
          delete opts.awesomemarker;
          if (opts.squareMarker) {
            opts.className = 'awesome-marker awesome-marker-square';
          }

          if (!opts.prefix) {
            opts.prefix = icon.library;
          }

          return new L.AwesomeMarkers.icon(opts);
        } else {
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

        }
      };
    }

    if (icon) icondf.effectiveLength = lat.length;

    // Make DataFrame
    const df = new LeafletWidget.DataFrame()
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
      .col('markerOptions', markerOptions)
      .cbind(options);

    // Show Statistics in InfoControl
    let updateInfo;
    if (options.showStats) {
      // Info control
      var info = L.control();
      info.onAdd = function() {
        this._div = L.DomUtil.create('div', 'info');
        return this._div;
      };

      info.addTo(map);

      // Define a function to update the info control based on passed statistics
      updateInfo = function(stats, statsFunction) {
        var infoHTML = '';
        if (typeof statsFunction === 'function') {
          // If additionalInput is a function, use it to generate content exclusively
          infoHTML = statsFunction(stats);
        } else {
          // Default content generation logic
          const totalDistance = stats.totalDistance
            ? (stats.totalDistance > 10000
              ? (stats.totalDistance / 1000).toFixed(0) + ' km'
              : stats.totalDistance.toFixed(0) + ' m')
            : 'invalid';
          infoHTML = '<h4>Statistics</h4>' +
            '<b>Total Distance</b><br/>' + totalDistance +
            '<br/><br/><b>Points</b><br/>' + stats.points +
            '<br/><br/><b>Vertices</b><br/>' + stats.vertices;
        }

        // Update the innerHTML of the info div with the constructed info HTML or leave it empty
        info._div.innerHTML = infoHTML;
      };
    }

    // Add Layer using addGenericLayers
    LeafletWidget.methods.addGenericLayers(this,
      'shape',
      df,
      function(df, i) {
        var options = df.get(i);

        // Create LatLong Centers
        const latlong = new L.LatLng(df.get(i, 'lat'), df.get(i, 'lng'));

        // Create Geodesic Circle
        const Geodesic = new L.GeodesicCircle(latlong, options);

        // Create a marker for each location
        if (options.showMarker) {
          markerOptions = markerOptions
            ? markerOptions
            : {};
          if (options.showMarker && icon) markerOptions.icon = getIcon(i);
          const marker = L.marker(latlong, markerOptions);

          if (label !== null) {
            if (labelOptions !== null) {
              marker.bindTooltip(df.get(i, 'label'), labelOptions);
            } else {
              marker.bindTooltip(df.get(i, 'label'));
            }
          }

          if (popup !== null) {
            if (popupOptions !== null) {
              marker.bindPopup(df.get(i, 'popup'), popupOptions);
            } else {
              marker.bindPopup(df.get(i, 'popup'));
            }
          }

          map.on('layeradd', function(e) {
            if (e.layer === Geodesic) {
              map.layerManager.addLayer(marker, 'marker', df.get(i, 'layerId'), df.get(i, 'group'), null, null);
            }
          });
          map.on('layerremove', function(e) {
            if (e.layer === Geodesic) {
              map.layerManager.removeLayer('marker', df.get(i, 'layerId'));
            }
          });

          // Event listener for Center / Circles
          marker.on('drag', (e) => {
            Geodesic.setLatLng(e.latlng);
            handleEvent(e, '_geodesic_stats', options, df, i, Geodesic.statistics, updateInfo);
          });
          marker.on('click', (e) => {
            handleEvent(e, '_geodesic_click', options, df, i, Geodesic.statistics, updateInfo);
          });
        }

        Geodesic.on('click', (e) => {
          handleEvent(e, '_geodesic_click', options, df, i, Geodesic.statistics, updateInfo);
        });
        Geodesic.on('mouseover', (e) => {
          handleEvent(e, '_geodesic_mouseover', options, df, i, Geodesic.statistics, updateInfo);
        });

        return Geodesic;
      });
  }

};


