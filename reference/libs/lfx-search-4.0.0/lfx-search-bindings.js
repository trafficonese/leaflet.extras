(()=>{"use strict";function e(e){return e instanceof Array?e:[e]}function o(o){return o?void 0===o.index?o:(o.data=e(o.data),o.index=e(o.index),$.map(o.index,(function(e){return o.data[e]}))):o}function t(e){var o={latlng:{}};return o.latlng.lat=e.latlng.lat,o.latlng.lng=e.latlng.lng,$.isEmptyObject(e.title)||(o.title=e.title),$.isEmptyObject(e.layer)||(o.layer=e.layer.toGeoJSON()),o}function r(e){if(e.marker&&e.marker.icon){var t=e.marker.icon;return t.awesomemarker?(t.squareMarker&&(t.className="awesome-marker awesome-marker-square"),t.prefix||(t.prefix=t.library),new L.AwesomeMarkers.icon(t)):!0===t?new L.Icon.Default:(t.iconUrl=o(t.iconUrl),t.iconRetinaUrl=o(t.iconRetinaUrl),t.shadowUrl=o(t.shadowUrl),t.shadowRetinaUrl=o(t.shadowRetinaUrl),t.iconWidth&&(t.iconSize=[t.iconWidth,t.iconHeight]),t.shadowWidth&&(t.shadowSize=[t.shadowWidth,t.shadowHeight]),t.iconAnchorX&&(t.iconAnchor=[t.iconAnchorX,t.iconAnchorY]),t.shadowAnchorX&&(t.shadowAnchor=[t.shadowAnchorX,t.shadowAnchorY]),t.popupAnchorX&&(t.popupAnchor=[t.popupAnchorX,t.popupAnchorY]),new L.Icon(t))}}var a,n;LeafletWidget.methods.addSearchOSM=function(e){(function(){var o=this;o.searchControlOSM&&(o.searchControlOSM.remove(o),delete o.searchControlOSM),(e=e||{}).textPlaceholder=e.textPlaceholder?e.textPlaceholder:"Search using OSM Geocoder",e.url=e.url?e.url:"https://nominatim.openstreetmap.org/search?format=json&q={s}",e.jsonpParam=e.jsonpParam?e.jsonpParam:"json_callback",e.propertyName=e.propertyName?e.propertyName:"display_name",e.propertyLoc=e.propertyLoc?e.propertyLoc:["lat","lon"],e.marker.icon=r(e),e.moveToLocation&&(e.moveToLocation=function(o,t,r){var a=e.zoom||16,n=r.getMaxZoom();n&&a>n&&(a=n),r.setView(o,a)}),o.searchControlOSM=new L.Control.Search(e),o.searchControlOSM.addTo(o),o.searchControlOSM.on("search:locationfound",(function(e){HTMLWidgets.shinyMode&&Shiny.onInputChange(o.id+"_search_location_found",t(e))}))}).call(this)},LeafletWidget.methods.removeSearchOSM=function(){(function(){var e=this;e.searchControlOSM&&(e.searchControlOSM._markerSearch&&e.removeLayer(e.searchControlOSM._markerSearch),e.searchControlOSM.remove(e),delete e.searchControlOSM);var o=document.getElementById("reverseSearchOSM");o&&(o.remove(),e.off("click",a))}).call(this)},LeafletWidget.methods.clearSearchOSM=function(){(function(){var e=this;e.searchControlOSM&&e.searchControlOSM._markerSearch&&e.removeLayer(e.searchControlOSM._markerSearch)}).call(this)},LeafletWidget.methods.addReverseSearchOSM=function(e,o){(function(){var t=this;o=o||"reverse_search_osm",t.layerManager.clearGroup(o);var n=document.getElementById("reverseSearchOSM");a=function(a){var s=a.latlng;s.lng=function(e){for(;e>180;)e-=360;for(;e<-180;)e+=360;return e}(s.lng);var i=L.featureGroup(),l=L.stamp(i);if(e.showSearchLocation){var c=r(e);void 0===c&&(c=new L.Icon.Default);var h=L.marker(a.latlng,{icon:c,type:"query"}).bindTooltip("lat="+s.lat+" lng="+s.lng+"</P>");L.stamp(h),i.addLayer(h)}var u="https://nominatim.openstreetmap.org/reverse?format=json&polygon_geojson=1&lat="+s.lat+"&lon="+s.lng;$.ajax({url:u,dataType:"json"}).done((function(r){if(r.error&&"Unable to geocode"===r.error)n.innerHTML="Unable to geocode";else{if(!$.isEmptyObject(n)){var a="<div>";a=a+"Display Name: "+(r.display_name?r.display_name:"")+"<br/>",a+="</div>",n.innerHTML=a}var c=L.latLngBounds(L.latLng(r.boundingbox[0],r.boundingbox[2]),L.latLng(r.boundingbox[1],r.boundingbox[3]));if(e.showBounds){var u=e.showBoundsOptions.fillOpacity?e.showBoundsOptions.fillOpacity:.2,d=e.showBoundsOptions.opacity?e.showBoundsOptions.opacity:.5,p=e.showBoundsOptions.weight?e.showBoundsOptions.weight:2,g=e.showBoundsOptions.color?e.showBoundsOptions.color:"#444444",y=e.showBoundsOptions.dashArray?e.showBoundsOptions.dashArray:"5,10",m=L.rectangle(c,{weight:p,color:g,dashArray:y,fillOpacity:u,opacity:d,clickable:!1,type:"result_boundingbox"});L.stamp(m),i.addLayer(m)}if(e.showFeature){var f=e.showFeatureOptions.fillOpacity?e.showFeatureOptions.fillOpacity:.2,v=e.showFeatureOptions.opacity?e.showFeatureOptions.opacity:.5,w=e.showFeatureOptions.weight?e.showFeatureOptions.weight:2,O=e.showFeatureOptions.color?e.showFeatureOptions.color:"red",S=e.showFeatureOptions.dashArray?e.showFeatureOptions.dashArray:"5,10",C=L.geoJson(r.geojson,{weight:w,color:O,dashArray:S,fillOpacity:f,opacity:v,clickable:!1,type:"result_feature",pointToLayer:function(e,o){return L.circleMarker(o,{weight:w,color:O,dashArray:S,fillOpacity:f,opacity:v,clickable:!1})}});L.stamp(C),i.addLayer(C)}var M=i.getLayers();!$.isEmptyObject(M)&&M.length>=0&&($.isEmptyObject(h)||(h.on("mouseover",(function(){var o=e.showHighlightOptions.fillOpacity?e.showHighlightOptions.fillOpacity:.5,t=e.showHighlightOptions.opacity?e.showFeatureOptions.opacity:.8,r=e.showHighlightOptions.weight?e.showHighlightOptions.weight:5;$.isEmptyObject(m)||(m.setStyle({fillOpacity:o,opacity:t,weight:r}),m.bringToFront()),$.isEmptyObject(C)||(C.setStyle({fillOpacity:o,opacity:t,weight:r}),C.bringToFront())})),h.on("mouseout",(function(){var o=e.showBoundsOptions.fillOpacity?e.showBoundsOptions.fillOpacity:.2,t=e.showBoundsOptions.opacity?e.showBoundsOptions.opacity:.5,r=e.showBoundsOptions.weight?e.showBoundsOptions.weight:2;$.isEmptyObject(m)||(m.setStyle({fillOpacity:o,opacity:t,weight:r}),m.bringToBack()),$.isEmptyObject(C)||(C.setStyle({fillOpacity:o,opacity:t,weight:r}),C.bringToBack())}))),t.layerManager.addLayer(i,"search",l,o),e.fitBounds&&t.fitBounds(i.getBounds())),HTMLWidgets.shinyMode&&Shiny.onInputChange(t.id+"_reverse_search_feature_found",{query:{lat:s.lat,lng:s.lng},result:r})}}))},t.on("click",a)}).call(this)},LeafletWidget.methods.searchOSMText=function(e){(function(){this.searchControlOSM&&this.searchControlOSM.searchText(e)}).call(this)},LeafletWidget.methods.addSearchGoogle=function(e){(function(){var o=this;o.searchControlGoogle&&(o.searchControlGoogle.remove(o),delete o.searchControlGoogle);var a=new google.maps.Geocoder;(e=e||{}).markerLocation=!0,e.textPlaceholder=e.textPlaceholder?e.textPlaceholder:"Search using Google Geocoder",e.moveToLocation&&(e.moveToLocation=function(o,t,r){var a=e.zoom||16,n=r.getMaxZoom();n&&a>n&&(a=n),r.setView(o,a)}),e.sourceData=function(e,o){a.geocode({address:e},o)},e.formatData=function(e){var o,t,r={};for(var a in e)o=e[a].formatted_address,t=L.latLng(e[a].geometry.location.lat(),e[a].geometry.location.lng()),r[o]=t;return r},e.marker.icon=r(e),o.searchControlGoogle=new L.Control.Search(e),o.searchControlGoogle.addTo(o),o.searchControlGoogle.on("search:locationfound",(function(e){HTMLWidgets.shinyMode&&Shiny.onInputChange(o.id+"_search_location_found",t(e))}))}).call(this)},LeafletWidget.methods.removeSearchGoogle=function(){(function(){var e=this;e.searchControlGoogle&&(e.searchControlGoogle.remove(e),delete e.searchControlGoogle);var o=document.getElementById("reverseSearchGoogle");o&&(o.remove(),e.off("click",n))}).call(this)},LeafletWidget.methods.addReverseSearchGoogle=function(e,o){(function(){var t=this;o=o||"reverse_search_google",t.layerManager.clearGroup(o);var r=document.getElementById("reverseSearchGoogle"),a=new google.maps.Geocoder;n=function(n){var s=n.latlng,i=L.featureGroup(),l=L.stamp(i);if(e.showSearchLocation){var c=L.marker(n.latlng,{type:"query"}).bindTooltip("lat="+s.lat+" lng="+s.lng+"</P>");L.stamp(c),i.addLayer(c)}a.geocode({location:{lat:s.lat,lng:s.lng}},(function(a,n){if("OK"===n)if(a[0]){var h=a[0];if(!$.isEmptyObject(r)){var u="<div>";u=u+"Address: "+(h.formatted_address?h.formatted_address:"")+"<br/>",u+="</div>",r.innerHTML=u}var d=L.latLngBounds(L.latLng(h.geometry.viewport.f.f,h.geometry.viewport.b.b),L.latLng(h.geometry.viewport.f.b,h.geometry.viewport.b.f));if(e.showBounds){var p=L.rectangle(d,{weight:2,color:"#444444",clickable:!1,dashArray:"5,10",type:"result_boundingbox"});L.stamp(p),i.addLayer(p)}if(e.showFeature){var g=L.circleMarker(L.latLng(h.geometry.location.lat(),h.geometry.location.lng()),{weight:2,color:"red",dashArray:"5,10",clickable:!1,type:"result_feature"});L.stamp(g),i.addLayer(g)}var y=i.getLayers();!$.isEmptyObject(y)&&y.length>=0&&($.isEmptyObject(c)||(c.on("mouseover",(function(e){$.isEmptyObject(p)||(p.setStyle({fillOpacity:.5,opacity:.8,weight:5}),p.bringToFront()),$.isEmptyObject(g)||(g.setStyle({fillOpacity:.5,opacity:.8,weight:5}),g.bringToFront())})),c.on("mouseout",(function(e){$.isEmptyObject(p)||(p.setStyle({fillOpacity:.2,opacity:.5,weight:2}),p.bringToBack()),$.isEmptyObject(g)||(g.setStyle({fillOpacity:.2,opacity:.5,weight:2}),g.bringToBack())}))),t.layerManager.addLayer(i,"search",l,o),e.fitBounds&&t.fitBounds(i.getBounds())),HTMLWidgets.shinyMode&&Shiny.onInputChange(t.id+"_reverse_search_feature_found",{query:{lat:s.lat,lng:s.lng},result:h})}else $.isEmptyObject(r)||(r.innerHTML="No Results Found"),console.error("No Results Found");else $.isEmptyObject(r)||(r.innerHTML="Reverse Geocoding failed due to: "+n),console.error("Reverse Geocoing failed due to: "+n)}))},t.on("click",n)}).call(this)},LeafletWidget.methods.addSearchUSCensusBureau=function(e){(function(){var o=this;o.searchControlUSCensusBureau&&(o.searchControlUSCensusBureau.remove(o),delete o.searchControlUSCensusBureau),(e=e||{}).url=e.url?e.url:"https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?benchmark=Public_AR_Current&format=jsonp&address={s}",e.textPlaceholder=e.textPlaceholder?e.textPlaceholder:"Search using US Census Bureau TEST",e.jsonpParam=e.jsonpParam?e.jsonpParam:"callback",e.formatData=function(e){var o,t,r={};for(var a in e.result.addressMatches)o=e.result.addressMatches[a].matchedAddress,t=L.latLng(e.result.addressMatches[a].coordinates.y,e.result.addressMatches[a].coordinates.x),r[o]=t;return r},e.moveToLocation&&(e.moveToLocation=function(o,t,r){var a=e.zoom||16,n=r.getMaxZoom();n&&a>n&&(a=n),r.setView(o,a)}),e.marker.icon=r(e),o.searchControlUSCensusBureau=new L.Control.Search(e),o.searchControlUSCensusBureau.addTo(o),o.searchControlUSCensusBureau.on("search:locationfound",(function(e){HTMLWidgets.shinyMode&&Shiny.onInputChange(o.id+"_search_location_found",t(e))}))}).call(this)},LeafletWidget.methods.removeSearchUSCensusBureau=function(){(function(){var e=this;e.searchControlUSCensusBureau&&(e.searchControlUSCensusBureau.remove(e),delete e.searchControlUSCensusBureau)}).call(this)},LeafletWidget.methods.addSearchFeatures=function(e,o){(function(){var a,n=this;if(n.searchControl&&(n.searchControl.remove(n),delete n.searchControl),(o=o||{}).moveToLocation&&(o.moveToLocation=function(e,t,r){var a=o.zoom||16,n=r.getMaxZoom();n&&a>n&&(a=n),Array.isArray(e)?r.fitBounds(L.latLngBounds(e)):r.setView(e,a)}),L.Util.isArray(e))a=n.layerManager.getLayerGroup("search",!0),n._searchFeatureGroupName="search",$.each(e,(function(e,o){var t=n.layerManager.getLayerGroup(o,!1);t?a.addLayer(t):console.warn('Group with ID "'+o+'" not Found, skipping')}));else{var s=n.layerManager.getLayerGroup(e,!1);if(!s)throw'Group with ID "'+e+'" not found';a=s,n._searchFeatureGroupName=e}o.marker.icon=r(o),L.stamp(a),o.layer=a,n.searchControl=new L.Control.Search(o),n.searchControl.addTo(n),n.searchControl.on("search:cancel",(function(e){e.target.options.hideMarkerOnCollapse&&e.target._map.removeLayer(this._markerSearch)})),n.searchControl.on("search:locationfound",(function(e){e.layer._layers?Object.values(e.layer._layers).some((e=>{e._popup&&(e._popup.options.autoClose=!1,e.openPopup())})):e.layer._popup&&e.layer.openPopup(),HTMLWidgets.shinyMode&&Shiny.onInputChange(n.id+"_search_location_found",t(e))}))}).call(this)},LeafletWidget.methods.removeSearchFeatures=function(e){(function(){var o=this;o.searchControl&&(o.searchControl.remove(o),delete o.searchControl),e&&o._searchFeatureGroupName&&(o.layerManager.clearGroup(o._searchFeatureGroupName),delete o._searchFeatureGroupName)}).call(this)},LeafletWidget.methods.clearSearchFeatures=function(){(function(){var e=this;e.searchControl&&e.removeLayer(e.searchControl._markerSearch)}).call(this)}})();