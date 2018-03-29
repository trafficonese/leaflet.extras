library(leaflet.extras)

#' ### Minimal code

#+ eval=FALSE
leaflet() %>%
  enableTileCaching() %>%
  addTiles(options = tileOptions(useCache = TRUE, crossOrigin = TRUE))

#' ### With Console Debugging
#' This is just some fancy javascript to show you caching in progress.
#' Open Developer Console, and see log messages for cache hit/miss.<br/><br/>

leaflet() %>% setView(0, 0, 2)  %>%
  enableTileCaching() %>%
  addTiles(options = tileOptions(useCache = TRUE, crossOrigin = TRUE),
           layerId = "tile1") %>%
  htmlwidgets::onRender(
    "function(el,t){
      layer = this.layerManager._byLayerId[\"tile\\ntile1\"];

      // Listen to cache hits and misses and spam the console
      // The cache hits and misses are only from this layer, not from the WMS layer.
      layer.on(\"tilecachehit\",function(ev){
        console.log(\"Cache hit: \", ev.url);
      });
      layer.on(\"tilecachemiss\",function(ev){
        console.log(\"Cache miss: \", ev.url);
      });
      layer.on(\"tilecacheerror\",function(ev){
        console.log(\"Cache error: \", ev.tile, ev.error);
      });
    }")
