/* global $, LeafletWidget, L */

import { unpackStrings, handleEvent } from './utils.js';

function formatMeters(value) {
  if (value === null || value === undefined || isNaN(value)) {
    return 'invalid';
  }

  return value > 10000
    ? (value / 1000).toFixed(0) + ' km'
    : value.toFixed(0) + ' m';
}

function circleStats(geodesic) {
  const stats = geodesic.statistics
    ? Object.assign({}, geodesic.statistics)
    : {};
  stats.radius = geodesic.radius;
  return stats;
}

function radiusHandleLatLng(geodesic) {
  const latlngs = geodesic.getLatLngs();
  if (!latlngs || latlngs.length === 0) {
    return geodesic.center;
  }

  const ring = Array.isArray(latlngs[0])
    ? latlngs[0]
    : latlngs;
  return ring[0];
}

function radiusHandleLayerId(layerId, index) {
  return layerId == null
    ? '__geodesic_radius_' + index
    : String(layerId) + '_radius';
}

function vertexMarkerId(layerId, stamp) {
  return (layerId == null
    ? 'geodesic'
    : String(layerId)) + '_pt_' + stamp;
}

function geodesicStillManaged(map, geodesic) {
  const layerId = geodesic._lfxLayerId;
  if (typeof layerId === 'string') {
    return map.layerManager.getLayer('shape', layerId) === geodesic;
  }

  const stamp = L.Util.stamp(geodesic);
  return !!(map.layerManager._byStamp && map.layerManager._byStamp[stamp]);
}

function removeVertexMarkers(map, geodesic) {
  const markers = geodesic._lfxVertexMarkers || [];
  markers.forEach(function(marker) {
    if (marker._lfxLayerId) {
      map.layerManager.removeLayer('marker', marker._lfxLayerId);
    }
  });
  geodesic._lfxVertexMarkers = [];
}

function bindGeodesicRemoveCleanup(map, geodesic) {
  if (geodesic._lfxRemoveBound) {
    return;
  }

  geodesic._lfxRemoveBound = true;
  geodesic.on('remove', function() {
    setTimeout(function() {
      if (!geodesicStillManaged(map, geodesic)) {
        removeVertexMarkers(map, geodesic);
      }
    }, 0);
  });
}

function addVertexMarker(map, geodesic, latlng, markerOptions, group, layerId) {
  const marker = L.marker(latlng, markerOptions || {});
  const markerId = vertexMarkerId(layerId, L.stamp(marker));
  marker._lfxLayerId = markerId;
  map.layerManager.addLayer(marker, 'marker', markerId, group, null, null);
  if (!geodesic._lfxVertexMarkers) {
    geodesic._lfxVertexMarkers = [];
  }

  geodesic._lfxVertexMarkers.push(marker);
  marker.on('drag', function() {
    if (!geodesic._lfxShowMarker) {
      return;
    }

    geodesic.setLatLngs(geodesic._lfxVertexMarkers.map(function(m) {
      return m.getLatLng();
    }));
    if (typeof geodesic._lfxUpdateInfo === 'function') {
      geodesic._lfxUpdateInfo(geodesic.statistics);
    }
  });
  return marker;
}

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

      const lineGroup = df.get(i, 'group');
      const lineId = df.get(i, 'layerId');
      const lineMarkerOptions = markerOptions
        ? Object.assign({}, markerOptions)
        : {};
      if (options.showMarker && icon) {
        lineMarkerOptions.icon = getIcon(i);
      }

      Geodesic._lfxVertexMarkers = [];
      Geodesic._lfxGroup = lineGroup;
      Geodesic._lfxLayerId = lineId;
      Geodesic._lfxShowMarker = !!options.showMarker;
      Geodesic._lfxMarkerOptions = lineMarkerOptions;
      Geodesic._lfxUpdateInfo = function(stats) {
        updateInfo.call(info, stats);
      };
      bindGeodesicRemoveCleanup(map, Geodesic);

      // Add Node Markers
      if (options.showMarker) {
        for (const place of geogesic_coords) {
          const marker = addVertexMarker(map, Geodesic, place, lineMarkerOptions, lineGroup, lineId);
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
        }
      }


      // Highlight
      const highlightStyle = df.get(i, 'highlightOptions');
      if (!$.isEmptyObject(highlightStyle)) {
        const defaultStyle = {};
        $.each(highlightStyle, function (k, v) {
          if (k != 'bringToFront' && k != 'sendToBack') {
            if (df.get(i, k)) {
              defaultStyle[k] = df.get(i, k);
            }
          }
        });

        Geodesic.on('mouseover',
          function(e) {
            this.setStyle(highlightStyle);
            if (highlightStyle.bringToFront) {
              this.bringToFront();
            }
          });
        Geodesic.on('mouseout',
          function(e) {
            this.setStyle(defaultStyle);
            if (highlightStyle.sendToBack) {
              this.bringToBack();
            }
          });
      }
    }
  }

};

LeafletWidget.methods.addLatLng = function(lat, lng, layerId) {
  const map = this;
  const geodesic = map.layerManager.getLayer('shape', layerId);
  if (!geodesic) {
    console.error('Geodesic object is not initialized.');
    return;
  }

  geodesic.addLatLng({ lat: lat, lng: lng });
  if (!geodesic._lfxVertexMarkers) {
    geodesic._lfxVertexMarkers = [];
  }

  bindGeodesicRemoveCleanup(map, geodesic);
  addVertexMarker(map, geodesic, { lat: lat, lng: lng }, geodesic._lfxMarkerOptions || {}, geodesic._lfxGroup, layerId);
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
        const fn = typeof statsFunction === 'function'
          ? statsFunction
          : options.statsFunction;
        var infoHTML = '';
        if (typeof fn === 'function') {
          infoHTML = fn(stats);
        } else {
          infoHTML = '<h4>Statistics</h4>' +
            '<b>Radius</b><br/>' + formatMeters(stats.radius) +
            '<br/><br/><b>Circumference</b><br/>' + formatMeters(stats.totalDistance) +
            '<br/><br/><b>Vertices</b><br/>' + stats.vertices;
        }

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
        const stats = circleStats(Geodesic);

        let radiusHandle = null;
        let handleOffset = { lat: 0, lng: 0 };

        const emit = function(e, eventName) {
          handleEvent(e, eventName, options, df, i, circleStats(Geodesic), updateInfo);
        };

        if (options.showStats && updateInfo) {
          updateInfo(stats, options.statsFunction);
        }

        if (options.editable) {
          radiusHandle = L.marker(radiusHandleLatLng(Geodesic), {
            draggable: true,
            title: 'Drag to resize radius'
          });
          const handleId = radiusHandleLayerId(df.get(i, 'layerId'), i);

          map.on('layeradd', function(e) {
            if (e.layer === Geodesic) {
              map.layerManager.addLayer(radiusHandle, 'marker', handleId, df.get(i, 'group'), null, null);
            }
          });
          map.on('layerremove', function(e) {
            if (e.layer === Geodesic) {
              map.layerManager.removeLayer('marker', handleId);
            }
          });

          radiusHandle.on('drag', (e) => {
            Geodesic.setRadius(Geodesic.distanceTo(e.latlng));
            emit(e, '_geodesic_stats');
          });
        }

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

          if (radiusHandle) {
            marker.on('dragstart', () => {
              const center = marker.getLatLng();
              const handleLatLng = radiusHandle.getLatLng();
              handleOffset = {
                lat: center.lat - handleLatLng.lat,
                lng: center.lng - handleLatLng.lng
              };
            });
          }

          marker.on('drag', (e) => {
            Geodesic.setLatLng(e.latlng);
            if (radiusHandle) {
              radiusHandle.setLatLng({
                lat: Math.max(-90, Math.min(90, e.latlng.lat - handleOffset.lat)),
                lng: e.latlng.lng - handleOffset.lng
              });
            }
            emit(e, '_geodesic_stats');
          });
          marker.on('click', (e) => {
            emit(e, '_geodesic_click');
          });
        }

        Geodesic.on('click', (e) => {
          emit(e, '_geodesic_click');
        });
        Geodesic.on('mouseover', (e) => {
          emit(e, '_geodesic_mouseover');
        });

        return Geodesic;
      });
  }

};


