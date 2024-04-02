(()=>{function e(e){var o={latlng:{}};return o.latlng.lat=e.latlng.lat,o.latlng.lng=e.latlng.lng,$.isEmptyObject(e.title)||(o.title=e.title),$.isEmptyObject(e.layer)||(o.layer=e.layer.toGeoJSON()),o}var o,r;LeafletWidget.methods.addSearchOSM=function(o){(function(){var r=this;r.searchControlOSM&&(r.searchControlOSM.remove(r),delete r.searchControlOSM),(o=o||{}).textPlaceholder=o.textPlaceholder?o.textPlaceholder:"Search using OSM Geocoder",o.url=o.url?o.url:"https://nominatim.openstreetmap.org/search?format=json&q={s}",o.jsonpParam=o.jsonpParam?o.jsonpParam:"json_callback",o.propertyName=o.propertyName?o.propertyName:"display_name",o.propertyLoc=o.propertyLoc?o.propertyLoc:["lat","lon"],o.marker=L.circleMarker([0,0],{radius:30}),o.moveToLocation&&(o.moveToLocation=function(e,r,t){var a=o.zoom||16,n=t.getMaxZoom();n&&a>n&&(a=n),t.setView(e,a)}),r.searchControlOSM=new L.Control.Search(o),r.searchControlOSM.addTo(r),r.searchControlOSM.on("search:locationfound",(function(o){HTMLWidgets.shinyMode&&Shiny.onInputChange(r.id+"_search_location_found",e(o))}))}).call(this)},LeafletWidget.methods.removeSearchOSM=function(){(function(){var e=this;e.searchControlOSM&&(e.searchControlOSM.remove(e),delete e.searchControlOSM);var r=document.getElementById("reverseSearchOSM");r&&(r.remove(),e.off("click",o))}).call(this)},LeafletWidget.methods.addReverseSearchOSM=function(e,r){(function(){var t=this;r=r||"reverse_search_osm",t.layerManager.clearGroup(r);var a=document.getElementById("reverseSearchOSM");o=function(o){var n=o.latlng,l=L.featureGroup(),s=L.stamp(l);if(e.showSearchLocation){var c=L.marker(o.latlng,{type:"query"}).bindTooltip("lat="+n.lat+" lng="+n.lng+"</P>");L.stamp(c),l.addLayer(c)}var i="https://nominatim.openstreetmap.org/reverse?format=json&polygon_geojson=1&lat="+n.lat+"&lon="+n.lng;$.ajax({url:i,dataType:"json"}).done((function(o){if(o.error&&"Unable to geocode"===o.error)a.innerHTML="Unable to geocode";else{if(!$.isEmptyObject(a)){var i="<div>";i=i+"Display Name: "+(o.display_name?o.display_name:"")+"<br/>",i+="</div>",a.innerHTML=i}var d=L.latLngBounds(L.latLng(o.boundingbox[0],o.boundingbox[2]),L.latLng(o.boundingbox[1],o.boundingbox[3]));if(e.showBounds){var u=L.rectangle(d,{weight:2,color:"#444444",clickable:!1,dashArray:"5,10",type:"result_boundingbox"});L.stamp(u),l.addLayer(u)}if(e.showFeature){var h=L.geoJson(o.geojson,{weight:2,color:"red",dashArray:"5,10",clickable:!1,type:"result_feature",pointToLayer:function(e,o){return L.circleMarker(o,{weight:2,color:"red",dashArray:"5,10",clickable:!1})}});L.stamp(h),l.addLayer(h)}var g=l.getLayers();!$.isEmptyObject(g)&&g.length>=0&&($.isEmptyObject(c)||(c.on("mouseover",(function(){$.isEmptyObject(u)||(u.setStyle({fillOpacity:.5,opacity:.8,weight:5}),u.bringToFront()),$.isEmptyObject(h)||(h.setStyle({fillOpacity:.5,opacity:.8,weight:5}),h.bringToFront())})),c.on("mouseout",(function(){$.isEmptyObject(u)||(u.setStyle({fillOpacity:.2,opacity:.5,weight:2}),u.bringToBack()),$.isEmptyObject(h)||(h.setStyle({fillOpacity:.2,opacity:.5,weight:2}),h.bringToBack())}))),t.layerManager.addLayer(l,"search",s,r),e.fitBounds&&t.fitBounds(l.getBounds())),HTMLWidgets.shinyMode&&Shiny.onInputChange(t.id+"_reverse_search_feature_found",{query:{lat:n.lat,lng:n.lng},result:o})}}))},t.on("click",o)}).call(this)},LeafletWidget.methods.searchOSMText=function(e){(function(){this.searchControlOSM&&this.searchControlOSM.searchText(e)}).call(this)},LeafletWidget.methods.addSearchGoogle=function(o){(function(){var r=this;r.searchControlGoogle&&(r.searchControlGoogle.remove(r),delete r.searchControlGoogle);var t=new google.maps.Geocoder;(o=o||{}).markerLocation=!0,o.textPlaceholder=o.textPlaceholder?o.textPlaceholder:"Search using Google Geocoder",o.marker=L.circleMarker([0,0],{radius:30}),o.moveToLocation&&(o.moveToLocation=function(e,r,t){var a=o.zoom||16,n=t.getMaxZoom();n&&a>n&&(a=n),t.setView(e,a)}),o.sourceData=function(e,o){t.geocode({address:e},o)},o.formatData=function(e){var o,r,t={};for(var a in e)o=e[a].formatted_address,r=L.latLng(e[a].geometry.location.lat(),e[a].geometry.location.lng()),t[o]=r;return t},r.searchControlGoogle=new L.Control.Search(o),r.searchControlGoogle.addTo(r),r.searchControlGoogle.on("search:locationfound",(function(o){HTMLWidgets.shinyMode&&Shiny.onInputChange(r.id+"_search_location_found",e(o))}))}).call(this)},LeafletWidget.methods.removeSearchGoogle=function(){(function(){var e=this;e.searchControlGoogle&&(e.searchControlGoogle.remove(e),delete e.searchControlGoogle);var o=document.getElementById("reverseSearchGoogle");o&&(o.remove(),e.off("click",r))}).call(this)},LeafletWidget.methods.addReverseSearchGoogle=function(e,o){(function(){var t=this;o=o||"reverse_search_google",t.layerManager.clearGroup(o);var a=document.getElementById("reverseSearchGoogle"),n=new google.maps.Geocoder;r=function(r){var l=r.latlng,s=L.featureGroup(),c=L.stamp(s);if(e.showSearchLocation){var i=L.marker(r.latlng,{type:"query"}).bindTooltip("lat="+l.lat+" lng="+l.lng+"</P>");L.stamp(i),s.addLayer(i)}n.geocode({location:{lat:l.lat,lng:l.lng}},(function(r,n){if("OK"===n)if(r[0]){var d=r[0];if(!$.isEmptyObject(a)){var u="<div>";u=u+"Address: "+(d.formatted_address?d.formatted_address:"")+"<br/>",u+="</div>",a.innerHTML=u}var h=L.latLngBounds(L.latLng(d.geometry.viewport.f.f,d.geometry.viewport.b.b),L.latLng(d.geometry.viewport.f.b,d.geometry.viewport.b.f));if(e.showBounds){var g=L.rectangle(h,{weight:2,color:"#444444",clickable:!1,dashArray:"5,10",type:"result_boundingbox"});L.stamp(g),s.addLayer(g)}if(e.showFeature){var m=L.circleMarker(L.latLng(d.geometry.location.lat(),d.geometry.location.lng()),{weight:2,color:"red",dashArray:"5,10",clickable:!1,type:"result_feature"});L.stamp(m),s.addLayer(m)}var y=s.getLayers();!$.isEmptyObject(y)&&y.length>=0&&($.isEmptyObject(i)||(i.on("mouseover",(function(e){$.isEmptyObject(g)||(g.setStyle({fillOpacity:.5,opacity:.8,weight:5}),g.bringToFront()),$.isEmptyObject(m)||(m.setStyle({fillOpacity:.5,opacity:.8,weight:5}),m.bringToFront())})),i.on("mouseout",(function(e){$.isEmptyObject(g)||(g.setStyle({fillOpacity:.2,opacity:.5,weight:2}),g.bringToBack()),$.isEmptyObject(m)||(m.setStyle({fillOpacity:.2,opacity:.5,weight:2}),m.bringToBack())}))),t.layerManager.addLayer(s,"search",c,o),e.fitBounds&&t.fitBounds(s.getBounds())),HTMLWidgets.shinyMode&&Shiny.onInputChange(t.id+"_reverse_search_feature_found",{query:{lat:l.lat,lng:l.lng},result:d})}else $.isEmptyObject(a)||(a.innerHTML="No Results Found"),console.error("No Results Found");else $.isEmptyObject(a)||(a.innerHTML="Reverse Geocoding failed due to: "+n),console.error("Reverse Geocoing failed due to: "+n)}))},t.on("click",r)}).call(this)},LeafletWidget.methods.addSearchUSCensusBureau=function(o){(function(){var r=this;r.searchControlUSCensusBureau&&(r.searchControlUSCensusBureau.remove(r),delete r.searchControlUSCensusBureau),(o=o||{}).url=o.url?o.url:"https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?benchmark=Public_AR_Current&format=jsonp&address={s}",o.textPlaceholder=o.textPlaceholder?o.textPlaceholder:"Search using US Census Bureau TEST",o.jsonpParam=o.jsonpParam?o.jsonpParam:"callback",o.formatData=function(e){var o,r,t={};for(var a in e.result.addressMatches)o=e.result.addressMatches[a].matchedAddress,r=L.latLng(e.result.addressMatches[a].coordinates.y,e.result.addressMatches[a].coordinates.x),t[o]=r;return t},o.marker=L.circleMarker([0,0],{radius:30}),o.moveToLocation&&(o.moveToLocation=function(e,r,t){var a=o.zoom||16,n=t.getMaxZoom();n&&a>n&&(a=n),t.setView(e,a)}),r.searchControlUSCensusBureau=new L.Control.Search(o),r.searchControlUSCensusBureau.addTo(r),r.searchControlUSCensusBureau.on("search:locationfound",(function(o){HTMLWidgets.shinyMode&&Shiny.onInputChange(r.id+"_search_location_found",e(o))}))}).call(this)},LeafletWidget.methods.removeSearchUSCensusBureau=function(){(function(){var e=this;e.searchControlUSCensusBureau&&(e.searchControlUSCensusBureau.remove(e),delete e.searchControlUSCensusBureau)}).call(this)},LeafletWidget.methods.addSearchFeatures=function(o,r){(function(){var t,a=this;if(a.searchControl&&(a.searchControl.remove(a),delete a.searchControl),(r=r||{}).moveToLocation&&(r.moveToLocation=function(e,o,t){var a=r.zoom||16,n=t.getMaxZoom();n&&a>n&&(a=n),t.setView(e,a)}),L.Util.isArray(o))t=a.layerManager.getLayerGroup("search",!0),a._searchFeatureGroupName="search",$.each(o,(function(e,o){var r=a.layerManager.getLayerGroup(o,!1);r?t.addLayer(r):console.warn('Group with ID "'+o+'" not Found, skipping')}));else{var n=a.layerManager.getLayerGroup(o,!1);if(!n)throw'Group with ID "'+o+'" not found';t=n,a._searchFeatureGroupName=o}L.stamp(t),r.layer=t,a.searchControl=new L.Control.Search(r),a.searchControl.addTo(a),a.searchControl.on("search:cancel",(function(e){e.target.options.hideMarkerOnCollapse&&e.target._map.removeLayer(this._markerSearch)})),a.searchControl.on("search:locationfound",(function(o){r.openPopup&&o.layer._popup&&o.layer.openPopup(),HTMLWidgets.shinyMode&&Shiny.onInputChange(a.id+"_search_location_found",e(o))}))}).call(this)},LeafletWidget.methods.removeSearchFeatures=function(e){(function(){var o=this;o.searchControl&&(o.searchControl.remove(o),delete o.searchControl),e&&o._searchFeatureGroupName&&(o.layerManager.clearGroup(o._searchFeatureGroupName),delete o._searchFeatureGroupName)}).call(this)},LeafletWidget.methods.clearSearchFeatures=function(){(function(){var e=this;e.searchControl&&e.removeLayer(e.searchControl._markerSearch)}).call(this)}})();