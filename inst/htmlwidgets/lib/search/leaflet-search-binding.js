/* global LeafletWidget, L, Shiny, HTMLWidgets */
LeafletWidget.methods.addSearchOSM = function(options) {

  (function(){
    var map = this;

    if(map.searchControl) {
      map.search.removeFrom(map);
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

    map.searchControl = new L.Control.Search(options);
    map.searchControl.addTo(map);

    map.searchControl.on('search:locationfound', function(e){
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_search_location_found',e);
    });

  }).call(this);
};

LeafletWidget.methods.addSearchMarker = function(targetLayerId, targetGroup, options){

  (function(){
    var map = this;

    if((!targetLayerId || !targetLayerId.trim() ) &&
      (!targetGroup || !targetGroup.trim())) {
      throw 'Need either a targetLayerId or targetGroup';
    }

    if(map.searchControl) {
      map.search.removeFrom(map);
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
    // This can be an existing GeoJSON layer or an existing FeatureGroup
    var searchFeatureGroup;

    if(targetLayerId) {
      // If we're given an existing GeoJSON layer find it and use it
      searchFeatureGroup = map.layerManager.getLayer('geojson', targetLayerId);
      if(searchFeatureGroup) {
        map._searchGeoJSONLayerId = targetLayerId;
      } else {
        // throw an error if we can't find the target GeoJSON layer
        throw 'GeoJSON layer with ID '+targetLayerId+' not Found';
      }
    } else {
      searchFeatureGroup = map.layerManager.getLayerGroup(targetGroup, false);
      if(searchFeatureGroup) {
        map._searchFeatureGroupName = targetGroup;
      } else {
        // throw an error if we can't find the target FeatureGroup layer
        throw 'Feature Group with ID '+targetGroup+' not Found';
      }
    }

    options.layer = searchFeatureGroup;

    map.searchControl = new L.Control.Search(options);
    map.searchControl.addTo(map);

    map.searchControl.on('search:locationfound', function(e){
      if(options.openPopup && e.layer._popup) {
        e.layer.openPopup();
      }
      // Shiny stuff
      if (!HTMLWidgets.shinyMode) return;
      Shiny.onInputChange(map.id+'_search_location_found',e);
    });

  }).call(this);
};

LeafletWidget.methods.removeSearch = function(clearFeatures) {
  (function(){

    var map = this;

    if(map.searchControl) {
      map.searchControl.removeFrom(map);
      delete map.searchControl;
    }
    if(map._searchFeatureGroupName && clearFeatures) {
      map.layerManager.clearGroup(map._searchFeatureGroupName);
    }
    map._searchFeatureGroupName = null;
    if(map._searchGeoJSONLayerId && clearFeatures) {
      map.layerManager.removeLayer('geojson', map._searchGeoJSONLayerId);
    }
    map._searchGeoJSONLayerId = null;
  }).call(this);

};
