/* global $, LeafletWidget, L, Shiny, HTMLWidgets */

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
      map.searchControlOSM.removeFrom(map);
      delete map.searchControlOSM;
    }

    options = options || {};
    options.textPlaceholder = "Search using OSM Geocoder";
    options.url = 'https://nominatim.openstreetmap.org/search?format=json&q={s}';
    options.jsonpParam = 'json_callback';
    options.propertyName = 'display_name';
    options.propertyLoc = ['lat','lon'];

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
      map.searchControlOSM.removeFrom(map);
      delete map.searchControlOSM;
    }
  }).call(this);
};

LeafletWidget.methods.addSearchGoogle = function(options) {

  (function(){
    var map = this;

    if(map.searchControlGoogle) {
      map.searchControlGoogle.removeFrom(map);
      delete map.searchControlGoogle;
    }

    var geocoder = new google.maps.Geocoder();

  	function googleGeocoding(text, callResponse) {
  		geocoder.geocode({address: text}, callResponse);
  	}

  	function formatJSON(rawjson) {
  		var json = {},
  			key, loc, disp = [];

  		for(var i in rawjson) {
  			key = rawjson[i].formatted_address;
  			loc = L.latLng( rawjson[i].geometry.location.lat(), rawjson[i].geometry.location.lng() );
  			json[ key ]= loc;	//key,value format
  		}
  		return json;
  	}

    options = options || {};
    options.markerLocation = true;
    options.textPlaceholder = "Search using Google Geocoder";

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
      map.searchControlGoogle.removeFrom(map);
      delete map.searchControlGoogle;
    }
  }).call(this);
};

LeafletWidget.methods.addSearchUSCensusBureau = function(options) {

  (function(){
    var map = this;

    if(map.searchControlUSCensusBureau) {
      map.searchControlUSCensusBureau.removeFrom(map);
      delete map.searchControlUSCensusBureau;
    }

    function formatJSON(rawjson) {
      var json = {},
        key, loc, disp = [];

      for (var i in rawjson.result.addressMatches) {
        key = rawjson.result.addressMatches[i].matchedAddress;
        loc = L.latLng(rawjson.result.addressMatches[i].coordinates.y, rawjson.result.addressMatches[i].coordinates.x);
        json[key] = loc; //key,value format
      }
      return json;
    }

    options = options || {};

    options.url = 'https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?benchmark=Public_AR_Current&format=jsonp&address={s}';
    options.textPlaceholder = "Search using US Census Bureau";
    options.jsonpParam = 'callback';
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
      map.searchControlUSCensusBureau.removeFrom(map);
      delete map.searchControlUSCensusBureau;
    }
  }).call(this);
};


LeafletWidget.methods.addSearchFeatures = function(targetGroups, options){

  (function(){
    var map = this;

    if(map.searchControl) {
      map.searchControl.removeFrom(map);
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

      searchFeatureGroup = map.layerManager.getLayerGroup("search", true);
      map._searchFeatureGroupName = "search";

      $.each(targetGroups, function(k, v) {
        var target = map.layerManager.getLayerGroup(v, false);
        // may be remove target from map before adding to searchFeatureGroup
        if(target) {
          searchFeatureGroup.addLayer(target);
        } else {
          console.warn('Group with ID "' + v + '" not Found, skipping');
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
      map.searchControl.removeFrom(map);
      delete map.searchControl;
    }
    if(clearFeatures && map._searchFeatureGroupName) {
      map.layerManager.clearGroup(map._searchFeatureGroupName);
      delete map._searchFeatureGroupName ;
    }
  }).call(this);

};
