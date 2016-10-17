

L.TileLayer.addInitHook(function() {

	if (!this.options.useCache) {
		this._db     = null;
		this._canvas = null;
		return;
	}

	this._db = new PouchDB('offline-tiles');
	this._canvas = document.createElement('canvas');

	if (!(this._canvas.getContext && this._canvas.getContext('2d'))) {
		// HTML5 canvas is needed to pack the tiles as base64 data. If
		//   the browser doesn't support canvas, the code will forcefully
		//   skip caching the tiles.
		this._canvas = null;
	}
});

L.TileLayer.prototype.options.useCache     = false;
L.TileLayer.prototype.options.saveToCache  = true;
L.TileLayer.prototype.options.useOnlyCache = false;
L.TileLayer.prototype.options.cacheMaxAge  = 24*3600*1000;


L.TileLayer.include({

	// Overwrites L.TileLayer.prototype._loadTile
	_loadTile: function(tile, tilePoint) {
		tile._layer  = this;
		tile.onerror = this._tileOnError;

		this._adjustTilePoint(tilePoint);

		var tileUrl = this.getTileUrl(tilePoint);
		this.fire('tileloadstart', {
			tile: tile,
			url: tileUrl
		});

		if (this.options.useCache && this._canvas) {
			this._db.get(tileUrl, {revs_info: true}, this._onCacheLookup(tile,tileUrl));
		} else {
			// Fall back to standard behaviour
			tile.onload  = this._tileOnLoad;
			tile.src = tileUrl;
		}
	},

	// Returns a callback (closure over tile/key/originalSrc) to be run when the DB
	//   backend is finished with a fetch operation.
	_onCacheLookup: function(tile,tileUrl) {
		return function(err,data) {
			if (data) {
				this.fire('tilecachehit', {
					tile: tile,
					url: tileUrl
				});
				if (Date.now() > data.timestamp + this.options.cacheMaxAge && !this.options.useOnlyCache) {
					// Tile is too old, try to refresh it
// 					console.log('Tile is too old: ', tileUrl);

					if (this.options.saveToCache) {
						tile.onload = this._saveTile(tileUrl, data._revs_info[0].rev);
					}
					tile.crossOrigin = 'Anonymous';
					tile.src = tileUrl;
					tile.onerror = function(ev) {
						// If the tile is too old but couldn't be fetched from the network,
						//   serve the one still in cache.
						this.src = data.dataUrl;
					}
				} else {
					// Serve tile from cached data
// 					console.log('Tile is cached: ', tileUrl);
					tile.onload  = this._tileOnLoad;
					tile.src = data.dataUrl;    // data.dataUrl is already a base64-encoded PNG image.
				}
			} else {
				this.fire('tilecachemiss', {
					tile: tile,
					url: tileUrl
				});
				if (this.options.useOnlyCache) {
					// Offline, not cached
// 					console.log('Tile not in cache', tileUrl);
					tile.onload  = this._tileOnLoad;
					tile.src = L.Util.emptyImageUrl;
				} else {
					// Online, not cached, request the tile normally
// 					console.log('Requesting tile normally', tileUrl);
					if (this.options.saveToCache) {
						tile.onload = this._saveTile(tileUrl);
					} else {
						tile.onload  = this._tileOnLoad;
					}
					tile.crossOrigin = 'Anonymous';
					tile.src = tileUrl;
				}
			}
		}.bind(this);
	},

	// Returns an event handler (closure over DB key), which runs
	//   when the tile (which is an <img>) is ready.
	// The handler will delete the document from pouchDB if an existing revision is passed.
	//   This will keep just the latest valid copy of the image in the cache.
	_saveTile: function(tileUrl, existingRevision) {
		return function(ev) {
			if (this._canvas === null) return;
			var img = ev.target;
			L.TileLayer.prototype._tileOnLoad.call(img,ev);
			this._canvas.width  = img.naturalWidth  || img.width;
			this._canvas.height = img.naturalHeight || img.height;

			var context = this._canvas.getContext('2d');
			context.drawImage(img, 0, 0);

			var dataUrl = this._canvas.toDataURL('image/png');
			var doc = {_id:tileUrl, dataUrl: dataUrl, timestamp: Date.now()};

			if (existingRevision) {
				//this._db.remove(tileUrl, existingRevision);
				db.get(tileUrl).then(function (doc) {
          return db.remove(doc);
        }).then(function(response) {
          // handle response
        }).catch(function(err) {
          console.log(err);
        });
			}
			//this._db.put(doc, tileUrl, doc.timestamp);
			this._db.put(doc).catch(function(err) {
         if (err.name === 'conflict') {
           // for now ignore conflict errors
         } else {
          console.log(err);
         }
          });
		}.bind(this);
	},


	// Seeds the cache given a bounding box (latLngBounds), and
	//   the minimum and maximum zoom levels
	// Use with care! This can spawn thousands of requests and
	//   flood tileservers!
	seed: function(bbox, minZoom, maxZoom) {
		if (minZoom > maxZoom) return;
		if (!this._map) return;

		var queue = [];

		for (var z = minZoom; z<maxZoom; z++) {

			var northEastPoint = this._map.project(bbox.getNorthEast(),z);
			var southWestPoint = this._map.project(bbox.getSouthWest(),z);

			// Calculate tile indexes as per L.TileLayer._update and
			//   L.TileLayer._addTilesFromCenterOut
			var tileSize   = this._getTileSize();
			var tileBounds = L.bounds(
				northEastPoint.divideBy(tileSize)._floor(),
				southWestPoint.divideBy(tileSize)._floor());

			for (var j = tileBounds.min.y; j <= tileBounds.max.y; j++) {
				for (var i = tileBounds.min.x; i <= tileBounds.max.x; i++) {
					point = new L.Point(i, j);
					point.z = z;
					queue.push(this.getTileUrl(point));
				}
			}
		}

		var seedData = {
			bbox: bbox,
			minZoom: minZoom,
			maxZoom: maxZoom,
			queueLength: queue.length
		}
		this.fire('seedstart', seedData);
		var tile = this._createTile();
		tile._layer = this;
		this._seedOneTile(tile, queue, seedData);
	},

	// Uses a defined tile to eat through one item in the queue and
	//   asynchronously recursively call itself when the tile has
	//   finished loading.
	_seedOneTile: function(tile, remaining, seedData) {
		if (!remaining.length) {
			this.fire('seedend', seedData);
			return;
		}
		this.fire('seedprogress', {
			bbox:    seedData.bbox,
			minZoom: seedData.minZoom,
			maxZoom: seedData.maxZoom,
			queueLength: seedData.queueLength,
			remainingLength: remaining.length
		});

		var url = remaining.pop();

		this._db.get(url, function(err,data){
			if (!data) {
				/// FIXME: Do something on tile error!!
				tile.onload = function(ev){
					this._saveTile(url)(ev);
					this._seedOneTile(tile, remaining, seedData);
				}.bind(this);
				tile.crossOrigin = 'Anonymous';
				tile.src = url;
			} else {
				this._seedOneTile(tile, remaining, seedData);
			}
		}.bind(this));

	}

});


