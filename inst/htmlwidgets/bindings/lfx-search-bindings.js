/* global $, LeafletWidget, L, Shiny, HTMLWidgets, google */

import { unpackStrings } from './utils.js';

// helper function to conver JS event to Shiny Event
function eventToShiny(e) {
  var shinyEvent = {};
  shinyEvent.latlng = {};
  shinyEvent.latlng.lat = e.latlng.lat;
  shinyEvent.latlng.lng = e.latlng.lng;
  if (!$.isEmptyObject(e.title)) {
    shinyEvent.title = e.title;
  }

  if (!$.isEmptyObject(e.layer)) {
    shinyEvent.layer = e.layer.toGeoJSON();
  }

  return shinyEvent;
}

function adaptIcon(options) {
  if (options.marker && options.marker.icon) {
    var icon = options.marker.icon;
    if (icon.awesomemarker) {
      if (icon.squareMarker) {
        icon.className = 'awesome-marker awesome-marker-square';
      }

      if (!icon.prefix) {
        icon.prefix = icon.library;
      }

      return new L.AwesomeMarkers.icon(icon);
    } else if (icon === true) {
      return new L.Icon.Default();
    } else {
      // Unpack icons
      icon.iconUrl = unpackStrings(icon.iconUrl);
      icon.iconRetinaUrl = unpackStrings(icon.iconRetinaUrl);
      icon.shadowUrl = unpackStrings(icon.shadowUrl);
      icon.shadowRetinaUrl = unpackStrings(icon.shadowRetinaUrl);

      if (icon.iconWidth) {
        icon.iconSize = [icon.iconWidth, icon.iconHeight];
      }
      if (icon.shadowWidth) {
        icon.shadowSize = [icon.shadowWidth, icon.shadowHeight];
      }
      if (icon.iconAnchorX) {
        icon.iconAnchor = [icon.iconAnchorX, icon.iconAnchorY];
      }
      if (icon.shadowAnchorX) {
        icon.shadowAnchor = [icon.shadowAnchorX, icon.shadowAnchorY];
      }
      if (icon.popupAnchorX) {
        icon.popupAnchor = [icon.popupAnchorX, icon.popupAnchorY];
      }
      return new L.Icon(icon);
    }
  }
}

function normalizeLongitude(longitude) {
  while (longitude > 180) {
    longitude -= 360;
  }
  while (longitude < -180) {
    longitude += 360;
  }
  return longitude;
}

LeafletWidget.methods.addSearchOSM = function(options) {
  (function() {
    var map = this;

    if (map.searchControlOSM) {
      map.searchControlOSM.remove(map);
      delete map.searchControlOSM;
    }

    options = options || {};
    options.textPlaceholder = options.textPlaceholder
      ? options.textPlaceholder
      : 'Search using OSM Geocoder';
    options.url = options.url
      ? options.url
      : 'https://nominatim.openstreetmap.org/search?format=json&q={s}';
    options.jsonpParam = options.jsonpParam
      ? options.jsonpParam
      : 'json_callback';
    options.propertyName = options.propertyName
      ? options.propertyName
      : 'display_name';
    options.propertyLoc = options.propertyLoc
      ? options.propertyLoc
      : ['lat', 'lon'];

    // https://github.com/stefanocudini/leaflet-search/issues/129
    //options.marker = L.circleMarker([0, 0], {radius: 30});
    options.marker.icon = adaptIcon(options);

    if (options.moveToLocation) {
      options.moveToLocation = function(latlng, title, map) {
        var zoom = options.zoom || 16;
        var maxZoom = map.getMaxZoom();
        if (maxZoom && zoom > maxZoom) {
          zoom = maxZoom;
        }

        map.setView(latlng, zoom);
      };
    }

    map.searchControlOSM = new L.Control.Search(options);
    map.searchControlOSM.addTo(map);

    map.searchControlOSM.on('search:locationfound', function(e) {
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_search_location_found', eventToShiny(e));
    });

  }).call(this);
};

var clickOSMEventHandler;
LeafletWidget.methods.removeSearchOSM = function() {
  (function() {
    var map = this;

    if (map.searchControlOSM) {
      if (map.searchControlOSM._markerSearch) {
        map.removeLayer(map.searchControlOSM._markerSearch);
      }
      map.searchControlOSM.remove(map);
      delete map.searchControlOSM;
    }

    var revsear = document.getElementById('reverseSearchOSM');
    if (revsear) {
      revsear.remove();
      map.off('click', clickOSMEventHandler);
    }
  }).call(this);
};

LeafletWidget.methods.clearSearchOSM = function() {
  (function() {
    var map = this;
    if (map.searchControlOSM) {
      if (map.searchControlOSM._markerSearch) {
        map.removeLayer(map.searchControlOSM._markerSearch);
      }
    }
  }).call(this);
};

LeafletWidget.methods.addReverseSearchOSM = function(options, group) {
  (function() {

    var map = this;

    group = group || 'reverse_search_osm' ;
    map.layerManager.clearGroup(group);

    var displayControl = document.getElementById('reverseSearchOSM');

    var searchURL = 'https://nominatim.openstreetmap.org/reverse?format=json&polygon_geojson=1';

    clickOSMEventHandler = function(e) {
      var latlng = e.latlng;
      latlng.lng = normalizeLongitude(latlng.lng);

      // This will hold the query, boundingbox, and found feature layers
      var container = L.featureGroup();
      var layerID = L.stamp(container);

      if (options.showSearchLocation) {
        var icon = adaptIcon(options);
        if (icon === undefined) {
          icon = new L.Icon.Default();
        }
        var marker = L.marker(e.latlng, {icon: icon, 'type': 'query'}).bindTooltip('lat=' + latlng.lat + ' lng=' + latlng.lng + '</P>');
        /* eslint-disable no-unused-vars */
        var m_layerID = L.stamp(marker);
        /* eslint-enable no-unused-vars */
        container.addLayer(marker);
      }

      var query = searchURL + '&lat=' + latlng.lat + '&lon=' + latlng.lng;

      $.ajax({url: query, dataType: 'json'}).done(function(result) {
        // Check if the response contains an error
        if (result.error && result.error === 'Unable to geocode') {
          displayControl.innerHTML = 'Unable to geocode';
          return;
        }

        if (!$.isEmptyObject(displayControl)) {
          var displayText = '<div>';
          displayText = displayText + 'Display Name: ' +
            ( (result.display_name)
              ? result.display_name
              : '' ) + '<br/>';
          displayText = displayText + '</div>';
          displayControl.innerHTML = displayText;
        }

        var bb = L.latLngBounds(L.latLng(result.boundingbox[0], result.boundingbox[2]),
          L.latLng(result.boundingbox[1], result.boundingbox[3]));

        if (options.showBounds) {
          var fillOpacityBound = options.showBoundsOptions.fillOpacity
            ? options.showBoundsOptions.fillOpacity
            : 0.2;
          var opacityBound = options.showBoundsOptions.opacity
            ? options.showBoundsOptions.opacity
            : 0.5;
          var weightBound = options.showBoundsOptions.weight
            ? options.showBoundsOptions.weight
            : 2;
          var colorBound = options.showBoundsOptions.color
            ? options.showBoundsOptions.color
            : '#444444';
          var dashArrayBound = options.showBoundsOptions.dashArray
            ? options.showBoundsOptions.dashArray
            : '5,10';
          var rect = L.rectangle(bb, {
            weight: weightBound,
            color: colorBound,
            dashArray: dashArrayBound,
            fillOpacity: fillOpacityBound,
            opacity: opacityBound,
            clickable: false,
            'type': 'result_boundingbox'});
            /* eslint-disable no-unused-vars */
          var bb_layerID = L.stamp(rect);
          /* eslint-enable no-unused-vars */
          container.addLayer(rect);
        }

        if (options.showFeature) {
          var fillOpacity = options.showFeatureOptions.fillOpacity
            ? options.showFeatureOptions.fillOpacity
            : 0.2;
          var opacity = options.showFeatureOptions.opacity
            ? options.showFeatureOptions.opacity
            : 0.5;
          var weight = options.showFeatureOptions.weight
            ? options.showFeatureOptions.weight
            : 2;
          var color = options.showFeatureOptions.color
            ? options.showFeatureOptions.color
            : 'red';
          var dashArray = options.showFeatureOptions.dashArray
            ? options.showFeatureOptions.dashArray
            : '5,10';
          var feature = L.geoJson(result.geojson,
            {
              weight: weight,
              color: color,
              dashArray: dashArray,
              fillOpacity: fillOpacity,
              opacity: opacity,
              clickable: false,
              'type': 'result_feature',
              pointToLayer: function(feature, latlng) {
                return L.circleMarker(latlng, {
                  weight: weight,
                  color: color,
                  dashArray: dashArray,
                  fillOpacity: fillOpacity,
                  opacity: opacity,
                  clickable: false});
              }
            });

          /* eslint-disable no-unused-vars */
          var f_layerID = L.stamp(feature);
          /* eslint-enable no-unused-vars */
          container.addLayer(feature);
        }

        var tmp = container.getLayers();
        if (!$.isEmptyObject(tmp) && tmp.length >= 0) {

          if (!$.isEmptyObject(marker)) {

            marker.on('mouseover', function() {
              var fillOpacity = options.showHighlightOptions.fillOpacity
                ? options.showHighlightOptions.fillOpacity
                : 0.5;
              var opacity = options.showHighlightOptions.opacity
                ? options.showFeatureOptions.opacity
                : 0.8;
              var weight = options.showHighlightOptions.weight
                ? options.showHighlightOptions.weight
                : 5;
              if (!$.isEmptyObject(rect)) {
                rect.setStyle({fillOpacity: fillOpacity,
                  opacity: opacity,
                  weight: weight});
                rect.bringToFront();
              }

              if (!$.isEmptyObject(feature)) {
                feature.setStyle({fillOpacity: fillOpacity,
                  opacity: opacity,
                  weight: weight});
                feature.bringToFront();
              }
            });
            marker.on('mouseout', function() {
              var fillOpacity = options.showBoundsOptions.fillOpacity
                ? options.showBoundsOptions.fillOpacity
                : 0.2;
              var opacity = options.showBoundsOptions.opacity
                ? options.showBoundsOptions.opacity
                : 0.5;
              var weight = options.showBoundsOptions.weight
                ? options.showBoundsOptions.weight
                : 2;
              if (!$.isEmptyObject(rect)) {
                rect.setStyle({fillOpacity: fillOpacity,
                  opacity: opacity,
                  weight: weight});
                rect.bringToBack();
              }

              if (!$.isEmptyObject(feature)) {
                feature.setStyle({fillOpacity: fillOpacity,
                  opacity: opacity,
                  weight: weight});
                feature.bringToBack();
              }
            });
          }

          map.layerManager.addLayer(container, 'search', layerID, group);
          if (options.fitBounds)
            map.fitBounds(container.getBounds());
        }

        if (HTMLWidgets.shinyMode) {
          Shiny.onInputChange(map.id + '_reverse_search_feature_found', {
            'query': {'lat': latlng.lat, 'lng': latlng.lng},
            'result': result
          });
        }

      });
    };

    map.on('click', clickOSMEventHandler);

  }).call(this);
};


LeafletWidget.methods.searchOSMText = function(text) {
  (function() {
    var map = this;
    if (map.searchControlOSM) {
      map.searchControlOSM.searchText(text);
    }
  }).call(this);
};




LeafletWidget.methods.addSearchGoogle = function(options) {
  (function() {
    var map = this;

    if (map.searchControlGoogle) {
      map.searchControlGoogle.remove(map);
      delete map.searchControlGoogle;
    }

    var geocoder = new google.maps.Geocoder();

    function googleGeocoding(text, callResponse) {
      geocoder.geocode({address: text}, callResponse);
    }

    function formatJSON(rawjson) {
      var json = {},
        key, loc;

      for (var i in rawjson) {
        key = rawjson[i].formatted_address;
        loc = L.latLng(rawjson[i].geometry.location.lat(), rawjson[i].geometry.location.lng());
        json[ key ] = loc; //key,value format
      }

      return json;
    }

    options = options || {};
    options.markerLocation = true;
    options.textPlaceholder = options.textPlaceholder
      ? options.textPlaceholder
      : 'Search using Google Geocoder';

    // https://github.com/stefanocudini/leaflet-search/issues/129
    //options.marker = L.circleMarker([0, 0], {radius: 30});

    if (options.moveToLocation) {
      options.moveToLocation = function(latlng, title, map) {
        var zoom = options.zoom || 16;
        var maxZoom = map.getMaxZoom();
        if (maxZoom && zoom > maxZoom) {
          zoom = maxZoom;
        }

        map.setView(latlng, zoom);
      };
    }

    options.sourceData = googleGeocoding;
    options.formatData = formatJSON;

    options.marker.icon = adaptIcon(options);
    map.searchControlGoogle = new L.Control.Search(options);
    map.searchControlGoogle.addTo(map);

    map.searchControlGoogle.on('search:locationfound', function(e) {
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_search_location_found', eventToShiny(e));
    });

  }).call(this);
};

var clickGOOEventHandler;
LeafletWidget.methods.removeSearchGoogle = function() {
  (function() {
    var map = this;
    if (map.searchControlGoogle) {
      map.searchControlGoogle.remove(map);
      delete map.searchControlGoogle;
    }

    var revsear = document.getElementById('reverseSearchGoogle');
    if (revsear) {
      revsear.remove();
      map.off('click', clickGOOEventHandler);
    }
  }).call(this);
};

LeafletWidget.methods.addReverseSearchGoogle = function(options, group) {
  (function() {

    var map = this;

    group = group || 'reverse_search_google' ;
    map.layerManager.clearGroup(group);

    var displayControl = document.getElementById('reverseSearchGoogle');

    var geocoder = new google.maps.Geocoder();

    clickGOOEventHandler = function(e) {
      var latlng = e.latlng;
      // This will hold the query, boundingbox, and found feature layers
      var container = L.featureGroup();
      var layerID = L.stamp(container);

      if (options.showSearchLocation) {
        var marker = L.marker(e.latlng, {'type': 'query'}).bindTooltip('lat=' + latlng.lat + ' lng=' + latlng.lng + '</P>');
        /* eslint-disable no-unused-vars */
        var m_layerID = L.stamp(marker);
        /* eslint-enable no-unused-vars */
        container.addLayer(marker);
      }

      geocoder.geocode({'location': {'lat': latlng.lat, 'lng': latlng.lng}},
        function(results, status) {

          if (status === 'OK') {
            if (results[0]) {
              var result = results[0];

              if (!$.isEmptyObject(displayControl)) {
                var displayText = '<div>';
                displayText = displayText + 'Address: ' +
                  ( (result.formatted_address)
                    ? result.formatted_address
                    : '' ) + '<br/>';
                displayText = displayText + '</div>';
                displayControl.innerHTML = displayText;
              }

              var bb = L.latLngBounds(L.latLng(result.geometry.viewport.f.f,
                result.geometry.viewport.b.b),
              L.latLng(result.geometry.viewport.f.b,
                result.geometry.viewport.b.f));

              if (options.showBounds) {
                var rect = L.rectangle(bb, {
                  weight: 2, color: '#444444', clickable: false,
                  dashArray: '5,10', 'type': 'result_boundingbox'});
                /* eslint-disable no-unused-vars */
                var bb_layerID = L.stamp(rect);
                /* eslint-enable no-unused-vars */
                container.addLayer(rect);
              }

              if (options.showFeature) {
                var feature = L.circleMarker(L.latLng(result.geometry.location.lat(),
                  result.geometry.location.lng()), {
                  weight: 2, color: 'red', dashArray: '5,10',
                  clickable: false, 'type': 'result_feature'
                });

                /* eslint-disable no-unused-vars */
                var f_layerID = L.stamp(feature);
                /* eslint-disable no-unused-vars */
                container.addLayer(feature);
              }

              var tmp = container.getLayers();
              if (!$.isEmptyObject(tmp) && tmp.length >= 0) {

                if (!$.isEmptyObject(marker)) {
                  marker.on('mouseover', function(e) {
                    if (!$.isEmptyObject(rect)) {
                      rect.setStyle({fillOpacity: 0.5, opacity: 0.8, weight: 5});
                      rect.bringToFront();
                    }

                    if (!$.isEmptyObject(feature)) {
                      feature.setStyle({fillOpacity: 0.5, opacity: 0.8, weight: 5});
                      feature.bringToFront();
                    }
                  });
                  marker.on('mouseout', function(e) {
                    if (!$.isEmptyObject(rect)) {
                      rect.setStyle({fillOpacity: 0.2, opacity: 0.5, weight: 2});
                      rect.bringToBack();
                    }

                    if (!$.isEmptyObject(feature)) {
                      feature.setStyle({fillOpacity: 0.2, opacity: 0.5, weight: 2});
                      feature.bringToBack();
                    }
                  });
                }

                map.layerManager.addLayer(container, 'search', layerID, group);
                if (options.fitBounds)
                  map.fitBounds(container.getBounds());
              }

              if (HTMLWidgets.shinyMode) {
                Shiny.onInputChange(map.id + '_reverse_search_feature_found', {
                  'query': {'lat': latlng.lat, 'lng': latlng.lng},
                  'result': result
                });
              }
            } else {
              if (!$.isEmptyObject(displayControl))
                displayControl.innerHTML = 'No Results Found';
              console.error('No Results Found');
            }
          } else {
            if (!$.isEmptyObject(displayControl))
              displayControl.innerHTML = 'Reverse Geocoding failed due to: ' + status;
            console.error('Reverse Geocoing failed due to: ' + status);
          }
        });
    };

    map.on('click', clickGOOEventHandler);

  }).call(this);
};


LeafletWidget.methods.addSearchUSCensusBureau = function(options) {
  (function() {
    var map = this;

    if (map.searchControlUSCensusBureau) {
      map.searchControlUSCensusBureau.remove(map);
      delete map.searchControlUSCensusBureau;
    }

    function formatJSON(rawjson) {
      var json = {}, key, loc;

      for (var i in rawjson.result.addressMatches) {
        key = rawjson.result.addressMatches[i].matchedAddress;
        loc = L.latLng(rawjson.result.addressMatches[i].coordinates.y,
          rawjson.result.addressMatches[i].coordinates.x);
        json[key] = loc; //key,value format
      }

      return json;
    }

    options = options || {};

    options.url = options.url
      ? options.url
      : 'https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?benchmark=Public_AR_Current&format=jsonp&address={s}';
    options.textPlaceholder = options.textPlaceholder
      ? options.textPlaceholder
      : 'Search using US Census Bureau TEST';

    options.jsonpParam = options.jsonpParam
      ? options.jsonpParam
      : 'callback';
    options.formatData = formatJSON;

    // https://github.com/stefanocudini/leaflet-search/issues/129
    // options.marker = L.circleMarker([0, 0], {radius: 30});

    if (options.moveToLocation) {
      options.moveToLocation = function(latlng, title, map) {
        var zoom = options.zoom || 16;
        var maxZoom = map.getMaxZoom();
        if (maxZoom && zoom > maxZoom) {
          zoom = maxZoom;
        }

        map.setView(latlng, zoom);
      };
    }

    options.marker.icon = adaptIcon(options);

    map.searchControlUSCensusBureau = new L.Control.Search(options);
    map.searchControlUSCensusBureau.addTo(map);

    map.searchControlUSCensusBureau.on('search:locationfound', function(e) {
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_search_location_found', eventToShiny(e));
    });

  }).call(this);
};

LeafletWidget.methods.removeSearchUSCensusBureau = function() {
  (function() {
    var map = this;
    if (map.searchControlUSCensusBureau) {
      map.searchControlUSCensusBureau.remove(map);
      delete map.searchControlUSCensusBureau;
    }
  }).call(this);
};


LeafletWidget.methods.addSearchFeatures = function(targetGroups, options) {
  (function() {
    var map = this;

    if (map.searchControl) {
      map.searchControl.remove(map);
      delete map.searchControl;
    }

    options = options || {};

    if (options.moveToLocation) {
      options.moveToLocation = function(latlng, title, map) {
        var zoom = options.zoom || 16;
        var maxZoom = map.getMaxZoom();
        if (maxZoom && zoom > maxZoom) {
          zoom = maxZoom;
        }

        // Check if latlng is an array of coordinates (array of arrays)
        if (Array.isArray(latlng) && latlng.length > 1) {
          // Ignore Zoom and fit Bounds to all found features
          map.fitBounds(L.latLngBounds(latlng));
        } else {
          // Just a single coordinate pair
          map.setView(latlng[0], zoom);
        }
      };
    }

    // FeatureGroup that will be searched
    var searchFeatureGroup;

    // if we have just one group to search use it.
    if (!L.Util.isArray(targetGroups)) {
      var target = map.layerManager.getLayerGroup(targetGroups, false);
      if (target) {
        searchFeatureGroup = target;
        map._searchFeatureGroupName = targetGroups;
      } else {
        // throw an error if we can't find the target FeatureGroup layer
        throw 'Group with ID "' + targetGroups + '" not found';
      }
    } else { // if we have more than one groups to search create a new seach group with them.

      searchFeatureGroup = map.layerManager.getLayerGroup('search', true);
      map._searchFeatureGroupName = 'search';

      $.each(targetGroups, function(k, v) {
        var target = map.layerManager.getLayerGroup(v, false);
        // may be remove target from map before adding to searchFeatureGroup
        if (target) {
          searchFeatureGroup.addLayer(target);
        } else {
          console.warn('Group with ID "' + v + '" not Found, skipping');
        }
      });
    }

    options.marker.icon = adaptIcon(options);

    L.stamp(searchFeatureGroup);
    options.layer = searchFeatureGroup;
    map.searchControl = new L.Control.Search(options);
    map.searchControl.addTo(map);

    map.searchControl.on('search:cancel', function(e) {
      if (e.target.options.hideMarkerOnCollapse) {
        e.target._map.removeLayer(this._markerSearch);
      }
    });

    map.searchControl.on('search:locationfound', function(e) {

      if (e.layer._layers) {
        Object.values(e.layer._layers).some(layer => {
          if (layer._popup) {
            layer._popup.options.autoClose = false;
            layer.openPopup();
          }
        });
      } else if (e.layer._popup) {
        e.layer.openPopup();
      }

      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id + '_search_location_found', eventToShiny(e));
    });

  }).call(this);
};

LeafletWidget.methods.removeSearchFeatures = function(clearFeatures) {
  (function() {
    var map = this;
    if (map.searchControl) {
      map.searchControl.remove(map);
      delete map.searchControl;
    }

    if (clearFeatures && map._searchFeatureGroupName) {
      map.layerManager.clearGroup(map._searchFeatureGroupName);
      delete map._searchFeatureGroupName;
    }
  }).call(this);
};

LeafletWidget.methods.clearSearchFeatures = function() {
  (function() {
    var map = this;
    if (map.searchControl) {
      map.removeLayer(map.searchControl._markerSearch);
    }
  }).call(this);
};
