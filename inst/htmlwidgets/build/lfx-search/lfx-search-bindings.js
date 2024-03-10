/******/ (() => { // webpackBootstrap
var __webpack_exports__ = {};
/*!**********************************************************!*\
  !*** ./inst/htmlwidgets/bindings/lfx-search-bindings.js ***!
  \**********************************************************/
/* global $, LeafletWidget, L, Shiny, HTMLWidgets, google */

// helper function to conver JS event to Shiny Event
function eventToShiny(e) {
  var shinyEvent = {};
  shinyEvent.latlng = {};
  shinyEvent.latlng.lat = e.latlng.lat;
  shinyEvent.latlng.lng = e.latlng.lng;
  if(!$.isEmptyObject(e.title)) {
    shinyEvent.title = e.title;
  }
  if(!$.isEmptyObject(e.layer)) {
    shinyEvent.layer = e.layer.toGeoJSON();
  }
  return shinyEvent;
}

LeafletWidget.methods.addSearchOSM = function(options) {

  (function(){
    var map = this;

    if(map.searchControlOSM) {
      map.searchControlOSM.remove(map);
      delete map.searchControlOSM;
    }

    options = options || {};
    options.textPlaceholder = options.textPlaceholder ? options.textPlaceholder : 'Search using OSM Geocoder';
    options.url = options.url ? options.url : 'https://nominatim.openstreetmap.org/search?format=json&q={s}';
    options.jsonpParam = options.jsonpParam ? options.jsonpParam : 'json_callback';
    options.propertyName = options.propertyName ? options.propertyName : 'display_name';
    options.propertyLoc = options.propertyLoc ? options.propertyLoc : ['lat','lon'];

    // https://github.com/stefanocudini/leaflet-search/issues/129
    options.marker = L.circleMarker([0,0],{radius:30});

    if(options.moveToLocation) {
      options.moveToLocation = function(latlng, title, map) {
        var zoom = options.zoom || 16;
        var maxZoom = map.getMaxZoom();
        if(maxZoom && zoom > maxZoom) {
          zoom = maxZoom;
        }
        map.setView(latlng, zoom);
      };
    }

    map.searchControlOSM = new L.Control.Search(options);
    map.searchControlOSM.addTo(map);

    map.searchControlOSM.on('search:locationfound', function(e){
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_search_location_found', eventToShiny(e));
    });

  }).call(this);
};

LeafletWidget.methods.removeSearchOSM = function() {
  (function(){

    var map = this;

    if(map.searchControlOSM) {
      map.searchControlOSM.remove(map);
      delete map.searchControlOSM;
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

    map.on('click', function(e){

      var latlng = e.latlng;

      // This will hold the query, boundingbox, and found feature layers
      var container = L.featureGroup();
      var layerID = L.stamp(container);

      if(options.showSearchLocation) {
        var marker = L.marker(e.latlng,{'type': 'query'}).bindTooltip(
          'lat='+latlng.lat+' lng='+latlng.lng+'</P>');
        /* eslint-disable no-unused-vars */
        var m_layerID = L.stamp(marker);
        /* eslint-enable no-unused-vars */
        container.addLayer(marker);
      }

      var query = searchURL + '&lat=' + latlng.lat + '&lon=' + latlng.lng;

      $.ajax({url: query, dataType: 'json'}).done(function(result){

        if(!$.isEmptyObject(displayControl)) {
          var displayText = '<div>';
          displayText = displayText + 'Display Name: ' +
            ( (result.display_name) ?  result.display_name : '' ) + '<br/>';
          displayText =  displayText + '</div>';
          displayControl.innerHTML = displayText;
        }

        var bb = L.latLngBounds(
          L.latLng(result.boundingbox[0],result.boundingbox[2]),
          L.latLng(result.boundingbox[1], result.boundingbox[3]));

        if(options.showBounds) {
          var rect = L.rectangle(bb, {
            weight:2, color: '#444444', clickable: false,
            dashArray: '5,10', 'type': 'result_boundingbox'});
          /* eslint-disable no-unused-vars */
          var bb_layerID = L.stamp(rect);
          /* eslint-enable no-unused-vars */
          container.addLayer(rect);
        }

        if(options.showFeature) {
          var feature = L.geoJson(result.geojson,
            {
              weight:2, color: 'red', dashArray: '5,10',
              clickable : false, 'type': 'result_feature',
              pointToLayer: function(feature, latlng) {
                return L.circleMarker(latlng,{
                  weight:2, color: 'red', dashArray: '5,10', clickable : false});
              }
            });

          /* eslint-disable no-unused-vars */
          var f_layerID = L.stamp(feature);
          /* eslint-enable no-unused-vars */
          container.addLayer(feature);
        }

        var tmp = container.getLayers();
        if(!$.isEmptyObject(tmp) && tmp.length >= 0) {

          if(!$.isEmptyObject(marker)) {
            marker.on('mouseover', function(e){
              if(!$.isEmptyObject(rect)) {
                rect.setStyle({fillOpacity: 0.5, opacity: 0.8, weight: 5});
                rect.bringToFront();
              }
              if(!$.isEmptyObject(feature)) {
                feature.setStyle({fillOpacity: 0.5, opacity: 0.8, weight: 5});
                feature.bringToFront();
              }
            });
            marker.on('mouseout', function(e){
              if(!$.isEmptyObject(rect)) {
                rect.setStyle({fillOpacity: 0.2, opacity: 0.5, weight: 2});
                rect.bringToBack();
              }
              if(!$.isEmptyObject(feature)) {
                feature.setStyle({fillOpacity: 0.2, opacity: 0.5, weight: 2});
                feature.bringToBack();
              }
            });
          }

          map.layerManager.addLayer(container, 'search', layerID, group);
          if(options.fitBounds)
            map.fitBounds(container.getBounds());
        }

        if (HTMLWidgets.shinyMode) {
          Shiny.onInputChange(map.id+'_reverse_search_feature_found',{
            'query': {'lat': latlng.lat, 'lng': latlng.lng},
            'result': result
          });
        }

      });
    });

  }).call(this);
};

LeafletWidget.methods.addSearchGoogle = function(options) {

  (function(){
    var map = this;

    if(map.searchControlGoogle) {
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

      for(var i in rawjson) {
        key = rawjson[i].formatted_address;
        loc = L.latLng( rawjson[i].geometry.location.lat(), rawjson[i].geometry.location.lng() );
        json[ key ]= loc; //key,value format
      }
      return json;
    }

    options = options || {};
    options.markerLocation = true;
    options.textPlaceholder = options.textPlaceholder ? options.textPlaceholder : 'Search using Google Geocoder';

    // https://github.com/stefanocudini/leaflet-search/issues/129
    options.marker = L.circleMarker([0,0],{radius:30});

    if(options.moveToLocation) {
      options.moveToLocation = function(latlng, title, map) {
        var zoom = options.zoom || 16;
        var maxZoom = map.getMaxZoom();
        if(maxZoom && zoom > maxZoom) {
          zoom = maxZoom;
        }
        map.setView(latlng, zoom);
      };
    }

    options.sourceData = googleGeocoding;
    options.formatData = formatJSON;

    map.searchControlGoogle = new L.Control.Search(options);
    map.searchControlGoogle.addTo(map);

    map.searchControlGoogle.on('search:locationfound', function(e){
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_search_location_found', eventToShiny(e));
    });

  }).call(this);
};

LeafletWidget.methods.removeSearchGoogle = function() {
  (function(){

    var map = this;

    if(map.searchControlGoogle) {
      map.searchControlGoogle.remove(map);
      delete map.searchControlGoogle;
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

    map.on('click', function(e){

      var latlng = e.latlng;

      // This will hold the query, boundingbox, and found feature layers
      var container = L.featureGroup();
      var layerID = L.stamp(container);

      if(options.showSearchLocation) {
        var marker = L.marker(e.latlng,{'type': 'query'}).bindTooltip(
          'lat='+latlng.lat+' lng='+latlng.lng+'</P>');
        /* eslint-disable no-unused-vars */
        var m_layerID = L.stamp(marker);
        /* eslint-enable no-unused-vars */
        container.addLayer(marker);
      }

      geocoder.geocode(
        {'location': {'lat': latlng.lat, 'lng': latlng.lng}},
        function(results, status) {

          if(status === 'OK') {
            if(results[0]) {
              var result = results[0];

              if(!$.isEmptyObject(displayControl)) {
                var displayText = '<div>';
                displayText = displayText + 'Address: ' +
                  ( (result.formatted_address) ?  result.formatted_address : '' ) + '<br/>';
                displayText =  displayText + '</div>';
                displayControl.innerHTML = displayText;
              }

              var bb = L.latLngBounds(
                L.latLng(result.geometry.viewport.f.f,
                  result.geometry.viewport.b.b),
                L.latLng(result.geometry.viewport.f.b,
                  result.geometry.viewport.b.f));

              if(options.showBounds) {
                var rect = L.rectangle(bb, {
                  weight:2, color: '#444444', clickable: false,
                  dashArray: '5,10', 'type': 'result_boundingbox'});
                /* eslint-disable no-unused-vars */
                var bb_layerID = L.stamp(rect);
                /* eslint-enable no-unused-vars */
                container.addLayer(rect);
              }

              if(options.showFeature) {
                var feature = L.circleMarker(
                  L.latLng(
                    result.geometry.location.lat(),
                    result.geometry.location.lng()
                  ), {
                    weight:2, color: 'red', dashArray: '5,10',
                    clickable : false, 'type': 'result_feature'
                  }
                );

                /* eslint-disable no-unused-vars */
                var f_layerID = L.stamp(feature);
                /* eslint-disable no-unused-vars */
                container.addLayer(feature);
              }

              var tmp = container.getLayers();
              if(!$.isEmptyObject(tmp) && tmp.length >= 0) {

                if(!$.isEmptyObject(marker)) {
                  marker.on('mouseover', function(e){
                    if(!$.isEmptyObject(rect)) {
                      rect.setStyle({fillOpacity: 0.5, opacity: 0.8, weight: 5});
                      rect.bringToFront();
                    }
                    if(!$.isEmptyObject(feature)) {
                      feature.setStyle({fillOpacity: 0.5, opacity: 0.8, weight: 5});
                      feature.bringToFront();
                    }
                  });
                  marker.on('mouseout', function(e){
                    if(!$.isEmptyObject(rect)) {
                      rect.setStyle({fillOpacity: 0.2, opacity: 0.5, weight: 2});
                      rect.bringToBack();
                    }
                    if(!$.isEmptyObject(feature)) {
                      feature.setStyle({fillOpacity: 0.2, opacity: 0.5, weight: 2});
                      feature.bringToBack();
                    }
                  });
                }

                map.layerManager.addLayer(container, 'search', layerID, group);
                if(options.fitBounds)
                  map.fitBounds(container.getBounds());
              }

              if (HTMLWidgets.shinyMode) {
                Shiny.onInputChange(map.id+'_reverse_search_feature_found',{
                  'query': {'lat': latlng.lat, 'lng': latlng.lng},
                  'result': result
                });
              }
            } else {
              if(!$.isEmptyObject(displayControl))
                displayControl.innerHTML = 'No Results Found';
              /* eslint-disable no-console */
              console.error('No Results Found');
              /* eslint-enable no-console */
            }
          } else {
            if(!$.isEmptyObject(displayControl))
              displayControl.innerHTML = 'Reverse Geocoding failed due to: ' + status;
            /* eslint-disable no-console */
            console.error('Reverse Geocoing failed due to: ' + status);
            /* eslint-enable no-console */
          }
        }
      );
    });
  }).call(this);
};


LeafletWidget.methods.addSearchUSCensusBureau = function(options) {
  (function(){
    var map = this;

    if(map.searchControlUSCensusBureau) {
      map.searchControlUSCensusBureau.remove(map);
      delete map.searchControlUSCensusBureau;
    }

    function formatJSON(rawjson) {
      var json = {}, key, loc;

      for (var i in rawjson.result.addressMatches) {
        key = rawjson.result.addressMatches[i].matchedAddress;
        loc = L.latLng(rawjson.result.addressMatches[i].coordinates.y, rawjson.result.addressMatches[i].coordinates.x);
        json[key] = loc; //key,value format
      }
      return json;
    }

    options = options || {};

    options.url = options.url ? options.url : 'https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?benchmark=Public_AR_Current&format=jsonp&address={s}';
    options.textPlaceholder = options.textPlaceholder ? options.textPlaceholder : 'Search using US Census Bureau TEST';

    options.jsonpParam = options.jsonpParam ? options.jsonpParam : 'callback';
    options.formatData = formatJSON;

    // https://github.com/stefanocudini/leaflet-search/issues/129
    options.marker = L.circleMarker([0,0],{radius:30});

    if(options.moveToLocation) {
      options.moveToLocation = function(latlng, title, map) {
        var zoom = options.zoom || 16;
        var maxZoom = map.getMaxZoom();
        if(maxZoom && zoom > maxZoom) {
          zoom = maxZoom;
        }
        map.setView(latlng, zoom);
      };
    }

    map.searchControlUSCensusBureau = new L.Control.Search(options);
    map.searchControlUSCensusBureau.addTo(map);

    map.searchControlUSCensusBureau.on('search:locationfound', function(e){
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_search_location_found', eventToShiny(e));
    });

  }).call(this);
};

LeafletWidget.methods.removeSearchUSCensusBureau = function() {
  (function(){

    var map = this;

    if(map.searchControlUSCensusBureau) {
      map.searchControlUSCensusBureau.remove(map);
      delete map.searchControlUSCensusBureau;
    }
  }).call(this);
};


LeafletWidget.methods.addSearchFeatures = function(targetGroups, options){

  (function(){
    var map = this;

    if(map.searchControl) {
      map.searchControl.remove(map);
      delete map.searchControl;
    }

    options = options || {};

    if(options.moveToLocation) {
      options.moveToLocation = function(latlng, title, map) {
        var zoom = options.zoom || 16;
        var maxZoom = map.getMaxZoom();
        if(maxZoom && zoom > maxZoom) {
          zoom = maxZoom;
        }
        map.setView(latlng, zoom);
      };
    }

    // FeatureGroup that will be searched
    var searchFeatureGroup;

    // if we have just one group to search use it.
    if(!L.Util.isArray(targetGroups)) {
      var target = map.layerManager.getLayerGroup(targetGroups, false);
      if(target) {
        searchFeatureGroup = target;
        map._searchFeatureGroupName = targetGroups;
      } else {
        // throw an error if we can't find the target FeatureGroup layer
        throw 'Group with ID "'+targetGroups+'" not found';
      }
    } else { // if we have more than one groups to search create a new seach group with them.

      searchFeatureGroup = map.layerManager.getLayerGroup('search', true);
      map._searchFeatureGroupName = 'search';

      $.each(targetGroups, function(k, v) {
        var target = map.layerManager.getLayerGroup(v, false);
        // may be remove target from map before adding to searchFeatureGroup
        if(target) {
          searchFeatureGroup.addLayer(target);
        } else {
          /* eslint-disable no-console */
          console.warn('Group with ID "' + v + '" not Found, skipping');
          /* eslint-enable no-console */
        }
      });
    }

    L.stamp(searchFeatureGroup);
    options.layer = searchFeatureGroup;
    map.searchControl = new L.Control.Search(options);
    map.searchControl.addTo(map);

    map.searchControl.on('search:locationfound', function(e){
      if(options.openPopup && e.layer._popup) {
        e.layer.openPopup();
      }
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_search_location_found', eventToShiny(e));
    });

  }).call(this);
};

LeafletWidget.methods.removeSearchFeatures = function(clearFeatures) {
  (function(){

    var map = this;

    if(map.searchControl) {
      map.searchControl.remove(map);
      delete map.searchControl;
    }
    if(clearFeatures && map._searchFeatureGroupName) {
      map.layerManager.clearGroup(map._searchFeatureGroupName);
      delete map._searchFeatureGroupName ;
    }
  }).call(this);

};

/******/ })()
;
//# sourceMappingURL=lfx-search-bindings.js.map