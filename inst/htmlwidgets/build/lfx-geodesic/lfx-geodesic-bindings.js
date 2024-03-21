(()=>{"use strict";function e(e){return e instanceof Array?e:[e]}function o(o){return o?void 0===o.index?o:(o.data=e(o.data),o.index=e(o.index),$.map(o.index,(function(e){return o.data[e]}))):o}function t(e,o,t,n,a,r,i){t.showStats&&i(r);var l=n.get(a,"group");if(HTMLWidgets.shinyMode){let t=e.target.getLatLng?e.target.getLatLng():e.latlng;if(t){const e=L.latLng(t);t={lat:e.lat,lng:e.lng}}const i=$.extend({id:n.get(a,"layerId"),".nonce":Math.random()},null!==l?{group:l}:null,t,r);Shiny.onInputChange(map.id+o,i)}}LeafletWidget.methods.addGeodesicPolylines=function(e,t,n,a,r,i,l,s,c,d,h){if(e.length>0){const m=this;var g=L.control();g.onAdd=function(){return this._div=L.DomUtil.create("div","info"),this._div};const f=function(e,o){if(a.showStats){var t="";t="function"==typeof o?o(e):"<h4>Statistics</h4><b>totalDistance</b><br/>"+(e.totalDistance?e.totalDistance>1e4?(e.totalDistance/1e3).toFixed(0)+" km":e.totalDistance.toFixed(0)+" m":"invalid")+"<br/><br/><b>Points</b><br/>"+e.points+"<br/><br/><b>Vertices</b><br/>"+e.vertices,g._div.innerHTML=t}};g.update=f,a.showStats&&g.addTo(m);const w=(new LeafletWidget.DataFrame).col("polygons",e).col("popup",i).col("layerId",t).col("label",s).col("group",n).col("highlightOptions",d).cbind(a),b=[];let y,k;r&&(r.awesomemarker||(r.iconUrl=o(r.iconUrl),r.iconRetinaUrl=o(r.iconRetinaUrl),r.shadowUrl=o(r.shadowUrl),r.shadowRetinaUrl=o(r.shadowRetinaUrl)),y=(new LeafletWidget.DataFrame).cbind(r),k=function(e){const o=y.get(e);return o?o.awesomemarker?(delete o.awesomemarker,o.squareMarker&&(o.className="awesome-marker awesome-marker-square"),o.prefix||(o.prefix=r.library),new L.AwesomeMarkers.icon(o)):(o.iconWidth&&(o.iconSize=[o.iconWidth,o.iconHeight]),o.shadowWidth&&(o.shadowSize=[o.shadowWidth,o.shadowHeight]),o.iconAnchorX&&(o.iconAnchor=[o.iconAnchorX,o.iconAnchorY]),o.shadowAnchorX&&(o.shadowAnchor=[o.shadowAnchorX,o.shadowAnchorY]),o.popupAnchorX&&(o.popupAnchor=[o.popupAnchorX,o.popupAnchorY]),new L.Icon(o)):o.awesomemarker?new L.AwesomeMarkers.icon:new L.Icon.Default}),r&&(y.effectiveLength=e.length);for(let e=0;e<w.nrow();e++){const o=w.get(e,"polygons")[0].flatMap((e=>e.lat.map(((o,t)=>({lat:o,lng:e.lng[t]}))))),t=L.geodesic(o,w.get(e));if(f.call(g,t.statistics),m.layerManager.addLayer(t,"shape",w.get(e,"layerId"),w.get(e,"group"),null,null),a.showMarker){var u=[];for(const d of o){h=h||{},a.showMarker&&r&&(h.icon=k(e));var p=L.marker(d,h);null!==s&&(null!==c?p.bindTooltip(w.get(e,"label"),c):p.bindTooltip(w.get(e,"label"))),null!==i&&(null!==l?p.bindPopup(w.get(e,"popup"),l):p.bindPopup(w.get(e,"popup"))),m.layerManager.addLayer(p,"markers",null,n,null,null),m.on("layeradd",(function(e){e.layer===t&&m.layerManager.addLayer(p,"marker","______fake_layerid",n,null,null)})),m.on("layerremove",(function(e){e.layer===t&&m.layerManager.removeLayer("marker","______fake_layerid")})),p.on("drag",(()=>{m.fire("geodesicdrag",{index:e})})),u.push(p)}}b.push({Geodesic:t,markers:u});let d=w.get(e,"highlightOptions");if(!$.isEmptyObject(d)){let o={};$.each(d,(function(t,n){"bringToFront"!=t&&"sendToBack"!=t&&w.get(e,t)&&(o[t]=w.get(e,t))})),t.on("mouseover",(function(e){this.setStyle(d),d.bringToFront&&this.bringToFront()})),t.on("mouseout",(function(e){this.setStyle(o),d.sendToBack&&this.bringToBack()}))}}const v=function(e){const{index:o}=e,t=[];for(const e of b[o].markers)t.push(e.getLatLng());b[o].Geodesic.setLatLngs(t),f.call(g,b[o].Geodesic.statistics)};m.on("geodesicdrag",v)}},LeafletWidget.methods.addLatLng=function(e,o,t){const n=this,a=n.layerManager.getLayer("shape",t);if(a){a.addLatLng({lat:e,lng:o});var r=L.marker({lat:e,lng:o});n.layerManager.addLayer(r,"markers",null,null,null,null)}else console.error("Geodesic object is not initialized.")},LeafletWidget.methods.addGreatCircles=function(e,n,a,r,i,l,s,c,d,h,g,u,p){if(!$.isEmptyObject(e)&&!$.isEmptyObject(n)||$.isNumeric(e)&&$.isNumeric(n)){const f=this;let w,b;s&&(s.awesomemarker||(s.iconUrl=o(s.iconUrl),s.iconRetinaUrl=o(s.iconRetinaUrl),s.shadowUrl=o(s.shadowUrl),s.shadowRetinaUrl=o(s.shadowRetinaUrl)),w=(new LeafletWidget.DataFrame).cbind(s),b=function(e){const o=w.get(e);return o?o.awesomemarker?(delete o.awesomemarker,o.squareMarker&&(o.className="awesome-marker awesome-marker-square"),o.prefix||(o.prefix=s.library),new L.AwesomeMarkers.icon(o)):(o.iconWidth&&(o.iconSize=[o.iconWidth,o.iconHeight]),o.shadowWidth&&(o.shadowSize=[o.shadowWidth,o.shadowHeight]),o.iconAnchorX&&(o.iconAnchor=[o.iconAnchorX,o.iconAnchorY]),o.shadowAnchorX&&(o.shadowAnchor=[o.shadowAnchorX,o.shadowAnchorY]),o.popupAnchorX&&(o.popupAnchor=[o.popupAnchorX,o.popupAnchorY]),new L.Icon(o)):o.awesomemarker?new L.AwesomeMarkers.icon:new L.Icon.Default}),s&&(w.effectiveLength=e.length);const y=(new LeafletWidget.DataFrame).col("lat",e).col("lng",n).col("radius",a).col("layerId",r).col("group",i).col("popup",c).col("popupOptions",d).col("label",h).col("labelOptions",g).col("highlightOptions",u).col("markerOptions",p).cbind(l);let k;if(l.showStats){var m=L.control();m.onAdd=function(){return this._div=L.DomUtil.create("div","info"),this._div},m.addTo(f),k=function(e,o){var t="";t="function"==typeof o?o(e):"<h4>Statistics</h4><b>Total Distance</b><br/>"+(e.totalDistance?e.totalDistance>1e4?(e.totalDistance/1e3).toFixed(0)+" km":e.totalDistance.toFixed(0)+" m":"invalid")+"<br/><br/><b>Points</b><br/>"+e.points+"<br/><br/><b>Vertices</b><br/>"+e.vertices,m._div.innerHTML=t}}LeafletWidget.methods.addGenericLayers(this,"shape",y,(function(e,o){var n=e.get(o);const a=new L.LatLng(e.get(o,"lat"),e.get(o,"lng")),r=new L.GeodesicCircle(a,n);if(n.showMarker){p=p||{},n.showMarker&&s&&(p.icon=b(o));const i=L.marker(a,p);null!==h&&(null!==g?i.bindTooltip(e.get(o,"label"),g):i.bindTooltip(e.get(o,"label"))),null!==c&&(null!==d?i.bindPopup(e.get(o,"popup"),d):i.bindPopup(e.get(o,"popup"))),f.on("layeradd",(function(t){t.layer===r&&f.layerManager.addLayer(i,"marker",e.get(o,"layerId"),e.get(o,"group"),null,null)})),f.on("layerremove",(function(t){t.layer===r&&f.layerManager.removeLayer("marker",e.get(o,"layerId"))})),i.on("drag",(a=>{r.setLatLng(a.latlng),t(a,"_geodesic_stats",n,e,o,r.statistics,k)})),i.on("click",(a=>{t(a,"_geodesic_click",n,e,o,r.statistics,k)}))}return r.on("click",(a=>{t(a,"_geodesic_click",n,e,o,r.statistics,k)})),r.on("mouseover",(a=>{t(a,"_geodesic_mouseover",n,e,o,r.statistics,k)})),r}))}}})();