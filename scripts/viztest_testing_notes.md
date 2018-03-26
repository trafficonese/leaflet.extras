## Known Issues
* Add bounce marker was added
* Geodesic polylines does not work for viztest. Works if you load the new/addGeodesicPolylines.html
* The top left corner css / styling changed for every photo
* The star/pen icon does not appear for draw-1.png. It does appear in new/draw.html
* style-editor-1.png top right corner css changed


# Validate
Each new/*.html file should have the following features within the html file.

* addBounceMarker.html
  - should contain a marker that bounces on open

* addGeodesicPolylines.html
  - should contain a connection of lines from europe to alaska

* addResetMapButton.html
  - should contain a button that "resets" to the world view if clicked. (zoom in the map before clicking)

* draw.html
  - should have three extra groups of icons.
  - first group has 6 shapes
  - second group can edit and delete the shapes
  - third group can change the style of the shapes

* fullscreen.html
  - fullscreen icon should make map full screen on computer

* gps.html
  - clicking the gps icon and allowing to access your location will add a marker to where you are. (~ 5 seconds)

* heatmap.html
  - (should produce a heatmap)

* leaflethash.html
  - as you zoom within the map, the "hash" of the url changes.
  - If you refresh, the map should appear in the same location as before the refresh

* measure-path.html
  - polygon areas within the map should contain total acres

* omnivore.html
  - 1 - should produce a heatmap that changes value as you zoom
  - 2 - should be the same as measure-path.html
  - 3 - should produce a heatmap from kml data that changes value as you zoom
  - 4 - should contain a map of the US that hovers and clicks for each state
  - 5 - should be a map of red dots
  - 6 - should contain a heatmap of Maryland airports whose heatmap does NOT change on zoom

* pulseMarkers.html
  - the single red marker should pulse

* search-geocoding.html
  - should be able to use the search icon to search for a city. such as "boston"

* sleep.html
  - should have a "Click or Hover to Wake" overlay until you click or hover

* style-editor.html
  - should be the exact same as draw.html

* TileCaching.html
  - tiles should appear MUCH faster on the second visit.

* utils.html
  - a grey globe looking thing should appear
  - a white globe looking thing should appear

* weatherMarkers.html
  - should have a blue icon with a half-sun on the top half and "wiggly bacon" on the bottom half

* webglheatmap.html
  - 1 - should have a heatmap that doesn't change on zoom
  - 2 - should have a heatmap that changes on zoom
  - 3 - should have a heatmap that changes on zoom
  - 4 - should have a world heatmap that changes on zoom
  - 5 - should have a heatmap that doesn't change on zoom

* wms-legend.html
  - should contain a colorful topographical map with a legend starting in the top right
