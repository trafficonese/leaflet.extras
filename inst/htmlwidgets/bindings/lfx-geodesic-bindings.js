/* global $, LeafletWidget, L, HTMLWidgets */
LeafletWidget.methods.addGeodesicPolylines  = function(
  polygons, layerId, group, options, icon, popup, popupOptions,
  label, labelOptions, highlightOptions, markerOptions, pts) {
  if(polygons.length > 0) {

    const map = this;

    console.log('START'); console.log(polygons);

    // Show Statistics in InfoControl
    var info = L.control();
    info.onAdd = function (map) {
      this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
      return this._div;
    };
    if (options.showStats) {
      info.addTo(map);
      // method that we will use to update the control based on feature properties passed
    }
    info.update = function (stats) {
        const totalDistance = (stats.totalDistance ? (stats.totalDistance > 10000) ? (stats.totalDistance / 1000).toFixed(0) + ' km' : (stats.totalDistance).toFixed(0) + ' m' : 'invalid');
        this._div.innerHTML = '<h4>Statistics</h4><b>totalDistance</b><br/>' + totalDistance +
              '<br/><br/><b>Points</b><br/>' + stats.points +
              '<br/><br/><b>Vertices</b><br/>' + stats.vertices;
      };


    // Add Lines using addGenericLayers
    let df = new LeafletWidget.DataFrame()
      .col("polygons", polygons)
      .col("popup", popup)
      .col("layerId", layerId)
      .col("label", label)
      .col("group", group)
      .cbind(options);

    const geodesics = []; // Array to store Geodesic objects

    for (let i = 0; i < df.nrow(); i++) {
      let geogesic_coords = df.get(i, "polygons")[0].flatMap(obj =>
        obj.lat.map((lat, i) => ({lat, lng: obj.lng[i]}))
      )
      const Geodesic = L.geodesic(geogesic_coords, df.get(i));
      if (options.showStats) {
        info.update(Geodesic.statistics);
      }
      map.layerManager.addLayer(Geodesic, 'shape', df.get(i, "layerId"), df.get(i, "group"), null, null);



      // Icon (Copy form Leaflet)
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
          const opts = icondf.get(i);
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
      if (icon) icondf.effectiveLength = geogesic_coords.length;

      if (options.showCenter) {
        var markers = [];

        for (const place of geogesic_coords) {
          markerOptions = markerOptions ? markerOptions : {};
          if (options.showCenter && icon) markerOptions.icon = getIcon(i);
          var marker = L.marker(place, markerOptions)
            if (label !== null) {
              if (labelOptions !== null) {
                marker.bindTooltip(df.get(i, 'label'), labelOptions);
              } else {
                marker.bindTooltip(df.get(i, 'label'));
              }
            }
            if (popup !== null) {
              if (popupOptions  !== null) {
                marker.bindPopup(df.get(i, 'popup'), popupOptions);
              } else {
                marker.bindPopup(df.get(i, 'popup'));
              }
            }
          map.layerManager.addLayer(marker, "markers", null, group, null, null);
          map.on('layeradd', function(e) {
            if(e.layer === Geodesic) {
              map.layerManager.addLayer(marker, 'marker', 'fake_layerid', group, null, null);
            }
          });
          map.on('layerremove', function(e) {
            if(e.layer === Geodesic) {
              map.layerManager.removeLayer('marker', 'fake_layerid');
            }
          });
          // Define event listeners for the marker
          marker.on('drag', (e) => {
              map.fire('geodesicdrag', { index: i, latlng: e.target.getLatLng() }); // Trigger custom event
          });

          markers.push(marker);
        }

      }

      geodesics.push({ Geodesic, markers });
    }

    function updateGeodesic(e) {
      console.log("updateGeodesic"); console.log(e)
      const { index, latlng } = e;
      const currentLine = [];
      for (const point of geodesics[index].markers) {
        currentLine.push(point.getLatLng());
      }
      geodesics[index].Geodesic.setLatLngs(currentLine);
      if (options.showStats) {
        info.update(geodesics[index].Geodesic.statistics);
      }
    }
    map.on('geodesicdrag', updateGeodesic);



  }
};

LeafletWidget.methods.addLatLng = function(latlng) {
  console.log('addLatLng'); console.log(addLatLng);
  // Check if the geodesic object exists
  if (this.geodesic) {
    // Add the new latlng point to the geodesic object
    this.geodesic.addLatLng(latlng);
  } else {
    console.error('Geodesic object is not initialized.');
  }
};

LeafletWidget.methods.addGreatCircles  = function(
  lat, lng, radius, layerId, group, options, icon, popup, popupOptions,
  label, labelOptions, highlightOptions, markerOptions) {
  if(!($.isEmptyObject(lat) || $.isEmptyObject(lng)) ||
      ($.isNumeric(lat) && $.isNumeric(lng))) {

    const map = this;

    // Icon (Copy form Leaflet)
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
        const opts = icondf.get(i);
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
        var infoHTML = '';
        if (typeof options.statsFunction === 'function') {
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

    // Add Layer using addGenericLayers
    LeafletWidget.methods.addGenericLayers(this, 'shape', df,
      function(df, i) {
        var options = df.get(i);

        // Create LatLong Centers
        const latlong = new L.LatLng(df.get(i, 'lat'), df.get(i, 'lng'));

        // Create Geodesic Circle
        const Geodesic = new L.GeodesicCircle(latlong, options);

        // Create a marker for each location
        if (options.showCenter) {
          markerOptions = markerOptions ? markerOptions : {};
          if (options.showCenter && icon) markerOptions.icon = getIcon(i);
          const marker = L.marker(latlong, markerOptions);

          if (label !== null) {
            if (labelOptions !== null) {
              marker.bindTooltip(df.get(i, 'label'), labelOptions);
            } else {
              marker.bindTooltip(df.get(i, 'label'));
            }
          }
          if (popup !== null) {
            if (popupOptions  !== null) {
              marker.bindPopup(df.get(i, 'popup'), popupOptions);
            } else {
              marker.bindPopup(df.get(i, 'popup'));
            }
          }
          map.on('layeradd', function(e) {
            if(e.layer === Geodesic) {
              map.layerManager.addLayer(marker, 'marker', df.get(i, 'layerId'), df.get(i, 'group'), null, null);
            }
          });
          map.on('layerremove', function(e) {
            if(e.layer === Geodesic) {
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


// from https://github.com/rstudio/leaflet/blob/dc772e780317481e25335449b957c5f50082bcfd/javascript/src/methods.js#L221
function unpackStrings(iconset) {
  if (!iconset) {
    return iconset;
  }
  if (typeof(iconset.index) === 'undefined') {
    return iconset;
  }

  iconset.data = asArray(iconset.data);
  iconset.index = asArray(iconset.index);

  return $.map(iconset.index, function(e, i) {
    return iconset.data[e];
  });
}
function handleEvent(e, eventName, options, df, i, statistics, updateInfo) {
  if (options.showStats) {
    updateInfo(statistics);
  }
  var group = df.get(i, 'group');
  // Pass Events to Shiny
  if (HTMLWidgets.shinyMode) {
    let latLng = e.target.getLatLng ? e.target.getLatLng() : e.latlng;
    if (latLng) {
      const latLngVal = L.latLng(latLng);
      latLng = { lat: latLngVal.lat, lng: latLngVal.lng };
    }
    const eventInfo = $.extend({
      id: df.get(i, 'layerId'),
      '.nonce': Math.random()
    },
    group !== null ? { group: group } : null,
    latLng,
    statistics);
    Shiny.onInputChange(map.id + eventName, eventInfo);
  }
}
