/**
 * Leaflet vector features drag functionality
 * @author Alexander Milevski <info@w8r.name>
 * @preserve
 */

/**
 * Matrix transform path for SVG/VML
 * Renderer-independent
 */
L.Path.include({

	/**
	 * Applies matrix transformation to SVG
	 * @param {Array.<Number>?} matrix
	 */
	_transform: function(matrix) {
		if (this._renderer) {
			if (matrix) {
				this._renderer.transformPath(this, matrix);
			} else {
				// reset transform matrix
				this._renderer._resetTransformPath(this);
				this._update();
			}
		}
		return this;
	},

	/**
	 * Check if the feature was dragged, that'll supress the click event
	 * on mouseup. That fixes popups for example
	 *
	 * @param  {MouseEvent} e
	 */
	_onMouseClick: function(e) {
		if ((this.dragging && this.dragging.moved()) ||
			(this._map.dragging && this._map.dragging.moved())) {
			return;
		}

		this._fireMouseEvent(e);
	}

});
/**
 * Drag handler
 * @class L.Path.Drag
 * @extends {L.Handler}
 */
L.Handler.PathDrag = L.Handler.extend( /** @lends  L.Path.Drag.prototype */ {

  statics: {
    DRAGGING_CLS: 'leaflet-path-draggable',
  },


  /**
   * @param  {L.Path} path
   * @constructor
   */
  initialize: function(path) {

    /**
     * @type {L.Path}
     */
    this._path = path;

    /**
     * @type {Array.<Number>}
     */
    this._matrix = null;

    /**
     * @type {L.Point}
     */
    this._startPoint = null;

    /**
     * @type {L.Point}
     */
    this._dragStartPoint = null;

    /**
     * @type {Boolean}
     */
    this._mapDraggingWasEnabled = false;

  },

  /**
   * Enable dragging
   */
  addHooks: function() {
    this._path.on('mousedown', this._onDragStart, this);

    this._path.options.className = this._path.options.className ?
        (this._path.options.className + ' ' + L.Handler.PathDrag.DRAGGING_CLS) :
         L.Handler.PathDrag.DRAGGING_CLS;

    if (this._path._path) {
      L.DomUtil.addClass(this._path._path, L.Handler.PathDrag.DRAGGING_CLS);
    }
  },

  /**
   * Disable dragging
   */
  removeHooks: function() {
    this._path.off('mousedown', this._onDragStart, this);

    this._path.options.className = this._path.options.className
      .replace(new RegExp('\\s+' + L.Handler.PathDrag.DRAGGING_CLS), '');
    if (this._path._path) {
      L.DomUtil.removeClass(this._path._path, L.Handler.PathDrag.DRAGGING_CLS);
    }
  },

  /**
   * @return {Boolean}
   */
  moved: function() {
    return this._path._dragMoved;
  },

  /**
   * Start drag
   * @param  {L.MouseEvent} evt
   */
  _onDragStart: function(evt) {
    var eventType = evt.originalEvent._simulated ? 'touchstart' : evt.originalEvent.type;

    this._mapDraggingWasEnabled = false;
    this._startPoint = evt.containerPoint.clone();
    this._dragStartPoint = evt.containerPoint.clone();
    this._matrix = [1, 0, 0, 1, 0, 0];
    L.DomEvent.stop(evt.originalEvent);

    L.DomUtil.addClass(this._path._renderer._container, 'leaflet-interactive');
    L.DomEvent
      .on(document, L.Draggable.MOVE[eventType], this._onDrag,    this)
      .on(document, L.Draggable.END[eventType],  this._onDragEnd, this);

    if (this._path._map.dragging.enabled()) {
      // I guess it's required because mousdown gets simulated with a delay
      //this._path._map.dragging._draggable._onUp(evt);

      this._path._map.dragging.disable();
      this._mapDraggingWasEnabled = true;
    }
    this._path._dragMoved = false;

    if (this._path._popup) { // that might be a case on touch devices as well
      this._path._popup._close();
    }

    this._replaceCoordGetters(evt);
  },

  /**
   * Dragging
   * @param  {L.MouseEvent} evt
   */
  _onDrag: function(evt) {
    L.DomEvent.stop(evt);

    var first = (evt.touches && evt.touches.length >= 1 ? evt.touches[0] : evt);
    var containerPoint = this._path._map.mouseEventToContainerPoint(first);

    // skip taps
    if (evt.type === 'touchmove' && !this._path._dragMoved) {
      var totalMouseDragDistance = this._dragStartPoint.distanceTo(containerPoint);
      if (totalMouseDragDistance <= this._path._map.options.tapTolerance) {
        return;
      }
    }

    var x = containerPoint.x;
    var y = containerPoint.y;

    var dx = x - this._startPoint.x;
    var dy = y - this._startPoint.y;

    // Send events only if point was moved
    if (dx || dy) {
      if (!this._path._dragMoved) {
        this._path._dragMoved = true;
        this._path.fire('dragstart', evt);
        // we don't want that to happen on click
        this._path.bringToFront();
      }

      this._matrix[4] += dx;
      this._matrix[5] += dy;

      this._startPoint.x = x;
      this._startPoint.y = y;

      this._path.fire('predrag', evt);
      this._path._transform(this._matrix);
      this._path.fire('drag', evt);
    }
  },

  /**
   * Dragging stopped, apply
   * @param  {L.MouseEvent} evt
   */
  _onDragEnd: function(evt) {
    var containerPoint = this._path._map.mouseEventToContainerPoint(evt);
    var moved = this.moved();

    // apply matrix
    if (moved) {
      this._transformPoints(this._matrix);
      this._path._updatePath();
      this._path._project();
      this._path._transform(null);

      L.DomEvent.stop(evt);
    }


    L.DomEvent
      .off(document, 'mousemove touchmove', this._onDrag, this)
      .off(document, 'mouseup touchend',    this._onDragEnd, this);

    this._restoreCoordGetters();

    // consistency
    if (moved) {
      this._path.fire('dragend', {
        distance: Math.sqrt(
          L.LineUtil._sqDist(this._dragStartPoint, containerPoint)
        )
      });

      // hack for skipping the click in canvas-rendered layers
      var contains = this._path._containsPoint;
      this._path._containsPoint = L.Util.falseFn;
      L.Util.requestAnimFrame(function() {
        L.DomEvent._skipped({ type: 'click' });
        this._path._containsPoint = contains;
      }, this);
    }

    this._matrix          = null;
    this._startPoint      = null;
    this._dragStartPoint  = null;
    this._path._dragMoved = false;

    if (this._mapDraggingWasEnabled) {
      if (moved) L.DomEvent._fakeStop({ type: 'click' });
      this._path._map.dragging.enable();
    }
  },


  /**
   * Applies transformation, does it in one sweep for performance,
   * so don't be surprised about the code repetition.
   *
   * [ x ]   [ a  b  tx ] [ x ]   [ a * x + b * y + tx ]
   * [ y ] = [ c  d  ty ] [ y ] = [ c * x + d * y + ty ]
   *
   * @param {Array.<Number>} matrix
   */
  _transformPoints: function(matrix, dest) {
    var path = this._path;
    var i, len, latlng;

    var px = L.point(matrix[4], matrix[5]);

    var crs = path._map.options.crs;
    var transformation = crs.transformation;
    var scale = crs.scale(path._map.getZoom());
    var projection = crs.projection;

    var diff = transformation.untransform(px, scale)
      .subtract(transformation.untransform(L.point(0, 0), scale));
    var applyTransform = !dest;

    path._bounds = new L.LatLngBounds();

    // console.time('transform');
    // all shifts are in-place
    if (path._point) { // L.Circle
      dest = projection.unproject(
        projection.project(path._latlng)._add(diff));
      if (applyTransform) {
        path._latlng = dest;
        path._point._add(px);
      }
    } else if (path._rings || path._parts) { // everything else
      var rings   = path._rings || path._parts;
      var latlngs = path._latlngs;
      dest = dest || latlngs;
      if (!L.Util.isArray(latlngs[0])) { // polyline
        latlngs = [latlngs];
        dest    = [dest];
      }
      for (i = 0, len = rings.length; i < len; i++) {
        dest[i] = dest[i] || [];
        for (var j = 0, jj = rings[i].length; j < jj; j++) {
          latlng     = latlngs[i][j];
          dest[i][j] = projection
            .unproject(projection.project(latlng)._add(diff));
          if (applyTransform) {
            path._bounds.extend(latlngs[i][j]);
            rings[i][j]._add(px);
          }
        }
      }
    }
    return dest;
    // console.timeEnd('transform');
  },



  /**
   * If you want to read the latlngs during the drag - your right,
   * but they have to be transformed
   */
  _replaceCoordGetters: function() {
    if (this._path.getLatLng) { // Circle, CircleMarker
      this._path.getLatLng_ = this._path.getLatLng;
      this._path.getLatLng = L.Util.bind(function() {
        return this.dragging._transformPoints(this.dragging._matrix, {});
      }, this._path);
    } else if (this._path.getLatLngs) {
      this._path.getLatLngs_ = this._path.getLatLngs;
      this._path.getLatLngs = L.Util.bind(function() {
        return this.dragging._transformPoints(this.dragging._matrix, []);
      }, this._path);
    }
  },


  /**
   * Put back the getters
   */
  _restoreCoordGetters: function() {
    if (this._path.getLatLng_) {
      this._path.getLatLng = this._path.getLatLng_;
      delete this._path.getLatLng_;
    } else if (this._path.getLatLngs_) {
      this._path.getLatLngs = this._path.getLatLngs_;
      delete this._path.getLatLngs_;
    }
  }

});


/**
 * @param  {L.Path} layer
 * @return {L.Path}
 */
L.Handler.PathDrag.makeDraggable = function(layer) {
  layer.dragging = new L.Handler.PathDrag(layer);
  return layer;
};


/**
 * Also expose as a method
 * @return {L.Path}
 */
L.Path.prototype.makeDraggable = function() {
  return L.Handler.PathDrag.makeDraggable(this);
};


L.Path.addInitHook(function() {
  if (this.options.draggable) {
    // ensure interactive
    this.options.interactive = true;

    if (this.dragging) {
      this.dragging.enable();
    } else {
      L.Handler.PathDrag.makeDraggable(this);
      this.dragging.enable();
    }
  } else if (this.dragging) {
    this.dragging.disable();
  }
});
L.SVG.include({

	/**
	 * Reset transform matrix
	 */
	_resetTransformPath: function(layer) {
		layer._path.setAttributeNS(null, 'transform', '');
	},

	/**
	 * Applies matrix transformation to SVG
	 * @param {L.Path}         layer
	 * @param {Array.<Number>} matrix
	 */
	transformPath: function(layer, matrix) {
		layer._path.setAttributeNS(null, 'transform',
			'matrix(' + matrix.join(' ') + ')');
	}

});
L.SVG.include(!L.Browser.vml ? {} : {

	/**
	 * Reset transform matrix
	 */
	_resetTransformPath: function(layer) {
		if (layer._skew) {
			// super important! workaround for a 'jumping' glitch:
			// disable transform before removing it
			layer._skew.on = false;
			layer._path.removeChild(layer._skew);
			layer._skew = null;
		}
	},

	/**
	 * Applies matrix transformation to VML
	 * @param {L.Path}         layer
	 * @param {Array.<Number>} matrix
	 */
	transformPath: function(layer, matrix) {
		var skew = layer._skew;

		if (!skew) {
			skew = L.SVG.create('skew');
			layer._path.appendChild(skew);
			skew.style.behavior = 'url(#default#VML)';
			layer._skew = skew;
		}

		// handle skew/translate separately, cause it's broken
		var mt = matrix[0].toFixed(8) + ' ' + matrix[1].toFixed(8) + ' ' +
			matrix[2].toFixed(8) + ' ' + matrix[3].toFixed(8) + ' 0 0';
		var offset = Math.floor(matrix[4]).toFixed() + ', ' +
			Math.floor(matrix[5]).toFixed() + '';

		var s = this._path.style;
		var l = parseFloat(s.left);
		var t = parseFloat(s.top);
		var w = parseFloat(s.width);
		var h = parseFloat(s.height);

		if (isNaN(l))       l = 0;
		if (isNaN(t))       t = 0;
		if (isNaN(w) || !w) w = 1;
		if (isNaN(h) || !h) h = 1;

		var origin = (-l / w - 0.5).toFixed(8) + ' ' + (-t / h - 0.5).toFixed(8);

		skew.on = 'f';
		skew.matrix = mt;
		skew.origin = origin;
		skew.offset = offset;
		skew.on = true;
	}

});
L.Util.trueFn = function() {
  return true;
};

L.Canvas.include({

  /**
   * Do nothing
   * @param  {L.Path} layer
   */
  _resetTransformPath: function(layer) {
    if (!this._containerCopy) return;

    delete this._containerCopy;

    if (layer._containsPoint_) {
      layer._containsPoint = layer._containsPoint_;
      delete layer._containsPoint_;

      this._requestRedraw(layer);
    }
  },


  /**
   * Algorithm outline:
   *
   * 1. pre-transform - clear the path out of the canvas, copy canvas state
   * 2. at every frame:
   *    2.1. save
   *    2.2. redraw the canvas from saved one
   *    2.3. transform
   *    2.4. draw path
   *    2.5. restore
   * 3. Repeat
   *
   * @param  {L.Path}         layer
   * @param  {Array.<Number>} matrix
   */
  transformPath: function(layer, matrix) {
    var copy   = this._containerCopy;
    var ctx    = this._ctx, copyCtx;
    var m      = L.Browser.retina ? 2 : 1;
    var bounds = this._bounds;
    var size   = bounds.getSize();
    var pos    = bounds.min;

    if (!copy) { // get copy of all rendered layers
      copy = this._containerCopy = document.createElement('canvas');
      copyCtx = copy.getContext('2d');
      // document.body.appendChild(copy);

      copy.width  = m * size.x;
      copy.height = m * size.y;

      this._removePath(layer);
      this._redraw();

      copyCtx.translate(m * bounds.min.x, m * bounds.min.y);
      copyCtx.drawImage(this._container, 0, 0);
      this._initPath(layer);

      // avoid flickering because of the 'mouseover's
      layer._containsPoint_ = layer._containsPoint;
      layer._containsPoint = L.Util.trueFn;
    }

    ctx.save();
    ctx.clearRect(pos.x, pos.y, size.x * m, size.y * m);
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.restore();
    ctx.save();

    ctx.drawImage(this._containerCopy, 0, 0, size.x, size.y);
    ctx.transform.apply(ctx, matrix);

    // now draw one layer only
    this._drawing = true;
    layer._updatePath();
    this._drawing = false;

    ctx.restore();
  }

});

/**
 * Drag feature functionality for Leaflet.draw
 * @preserve
 * @license MIT
 * @author Alexander Milevski <info@w8r.name>
 */


/**
 * Static flag for move markers
 * @type {Boolean}
 */
L.EditToolbar.Edit.MOVE_MARKERS = false;

L.EditToolbar.Edit.include( /** @lends L.EditToolbar.Edit.prototype */ {

  /**
   * @override
   */
  initialize: function(map, options) {
    if(options && options.selectedPathOptions) {
      L.EditToolbar.Edit.MOVE_MARKERS = !!options.selectedPathOptions.moveMarkers;
    }
    this._initialize(map, options);
  },

  /**
   * @param  {L.Map}  map
   * @param  {Object} options
   */
  _initialize: L.EditToolbar.Edit.prototype.initialize

});
/**
 * Mainly central marker routines
 */

L.Edit.SimpleShape.include( /** @lends L.Edit.SimpleShape.prototype */ {

  /**
   * Put move marker into center
   */
  _updateMoveMarker: function() {
    if (this._moveMarker) {
      this._moveMarker.setLatLng(this._getShapeCenter());
    }
  },

  /**
   * Shape centroid
   * @return {L.LatLng}
   */
  _getShapeCenter: function() {
    return this._shape.getBounds().getCenter();
  },

  /**
   * @override
   */
  _createMoveMarker: function() {
    if (L.EditToolbar.Edit.MOVE_MARKERS) {
      this._moveMarker = this._createMarker(this._getShapeCenter(),
        this.options.moveIcon);
    }
  }

});

/**
 * Override this if you don't want the central marker
 * @type {Boolean}
 */
L.Edit.SimpleShape.mergeOptions({
  moveMarker: false
});
/**
 * Dragging routines for circle
 */

L.Edit.Circle.include( /** @lends L.Edit.Circle.prototype */ {

  /**
   * @override
   */
  addHooks: function() {
    if (this._shape._map) {
      this._map = this._shape._map;
      this._shape.setStyle(this._shape.options.editing);
      if (!this._markerGroup) {
        this._enableDragging();
        this._initMarkers();
      }
      this._shape._map.addLayer(this._markerGroup);
    }
  },

  /**
   * @override
   */
  removeHooks: function() {
    this._shape.setStyle(this._shape.options.original);
    if (this._shape._map) {
      for (var i = 0, l = this._resizeMarkers.length; i < l; i++) {
        this._unbindMarker(this._resizeMarkers[i]);
      }

      this._disableDragging();
      this._resizeMarkers = null;
      this._map.removeLayer(this._markerGroup);
      delete this._markerGroup;
    }

    this._map = null;
  },

  /**
   * @override
   */
  _createMoveMarker: L.Edit.SimpleShape.prototype._createMoveMarker,

  /**
   * Change
   * @param  {L.LatLng} latlng
   */
  _resize: function(latlng) {
    var center = this._shape.getLatLng();
    var radius = center.distanceTo(latlng);

    this._shape.setRadius(radius);

    this._updateMoveMarker();

    this._map.fire('draw:editresize', {layer: this._shape});
  },

  /**
   * Adds drag start listeners
   */
  _enableDragging: function() {
    if (!this._shape.dragging) {
      this._shape.dragging = new L.Handler.PathDrag(this._shape);
    }
    this._shape.dragging.enable();
    this._shape
      .on('dragstart', this._onStartDragFeature, this)
      .on('dragend', this._onStopDragFeature, this);
  },

  /**
   * Removes drag start listeners
   */
  _disableDragging: function() {
    this._shape.dragging.disable();
    this._shape
      .off('dragstart', this._onStartDragFeature, this)
      .off('dragend', this._onStopDragFeature, this);
  },

  /**
   * Start drag
   * @param  {L.MouseEvent} evt
   */
  _onStartDragFeature: function() {
    this._shape._map.removeLayer(this._markerGroup);
    this._shape.fire('editstart');
  },

  /**
   * Dragging stopped, apply
   * @param  {L.MouseEvent} evt
   */
  _onStopDragFeature: function() {
    var center = this._shape.getLatLng();

    //this._moveMarker.setLatLng(center);
    this._resizeMarkers[0].setLatLng(this._getResizeMarkerPoint(center));

    // show resize marker
    this._shape._map.addLayer(this._markerGroup);
    this._updateMoveMarker();
    this._fireEdit();
  }
});
/**
 * Dragging routines for poly handler
 */

L.Edit.Rectangle.include( /** @lends L.Edit.Rectangle.prototype */ {

  /**
   * @override
   */
  addHooks: function() {
    if (this._shape._map) {
      this._map = this._shape._map;
      this._shape.setStyle(this._shape.options.editing);
      if (!this._markerGroup) {
        this._enableDragging();
        this._initMarkers();
      }
      this._shape._map.addLayer(this._markerGroup);
    }
  },

  /**
   * @override
   */
  removeHooks: function() {
    this._shape.setStyle(this._shape.options.original);
    if (this._shape._map) {
      this._shape._map.removeLayer(this._markerGroup);
      this._disableDragging();
      delete this._markerGroup;
      delete this._markers;
    }
    this._map = null;
  },

  /**
   * @override
   */
  _resize: function(latlng) {
    // Update the shape based on the current position of
    // this corner and the opposite point
    this._shape.setBounds(L.latLngBounds(latlng, this._oppositeCorner));
    this._updateMoveMarker();

    this._shape._map.fire('draw:editresize', { layer: this._shape });
  },

  /**
   * @override
   */
  _onMarkerDragEnd: function(e) {
    this._toggleCornerMarkers(1);
    this._repositionCornerMarkers();

    L.Edit.SimpleShape.prototype._onMarkerDragEnd.call(this, e);
  },

  /**
   * Adds drag start listeners
   */
  _enableDragging: function() {
    if (!this._shape.dragging) {
      this._shape.dragging = new L.Handler.PathDrag(this._shape);
    }
    this._shape.dragging.enable();
    this._shape
      .on('dragstart', this._onStartDragFeature, this)
      .on('dragend', this._onStopDragFeature, this);
  },

  /**
   * Removes drag start listeners
   */
  _disableDragging: function() {
    this._shape.dragging.disable();
    this._shape
      .off('dragstart', this._onStartDragFeature, this)
      .off('dragend', this._onStopDragFeature, this);
  },

  /**
   * Start drag
   * @param  {L.MouseEvent} evt
   */
  _onStartDragFeature: function() {
    this._shape._map.removeLayer(this._markerGroup);
    this._shape.fire('editstart');
  },

  /**
   * Dragging stopped, apply
   * @param  {L.MouseEvent} evt
   */
  _onStopDragFeature: function() {
    var polygon = this._shape;
    for (var j = 0, jj = polygon._latlngs.length; j < jj; j++) {
      for (var i = 0, len = polygon._latlngs[j].length; i < len; i++) {
        // update marker
        var marker = this._resizeMarkers[i];
        marker.setLatLng(polygon._latlngs[j][i]);

        // this one's needed to update the path
        marker._origLatLng = polygon._latlngs[j][i];
        if (marker._middleLeft) {
          marker._middleLeft.setLatLng(this._getMiddleLatLng(marker._prev, marker));
        }
        if (marker._middleRight) {
          marker._middleRight.setLatLng(this._getMiddleLatLng(marker, marker._next));
        }
      }
    }
    // this._moveMarker.setLatLng(polygon.getBounds().getCenter());

    // show vertices
    this._shape._map.addLayer(this._markerGroup);
    this._updateMoveMarker();

    this._repositionCornerMarkers();
    this._fireEdit();
  }
});
/**
 * Dragging routines for poly handler
 */

L.Edit.PolyVerticesEdit.include( /** @lends L.Edit.PolyVerticesEdit.prototype */ {

  // store methods to call them in overrides
  __createMarker: L.Edit.PolyVerticesEdit.prototype._createMarker,
  __removeMarker: L.Edit.PolyVerticesEdit.prototype._removeMarker,

  /**
   * @override
   */
  addHooks: function() {
    var poly = this._poly;

    if (!(poly instanceof L.Polygon)) {
      poly.options.fill = false;
      if (poly.options.editing) {
        poly.options.editing.fill = false;
      }
    }

    poly.setStyle(poly.options.editing);
    if (this._poly._map) {
      this._map = this._poly._map; // Set map
      if (!this._markerGroup) {
        this._enableDragging();
        this._initMarkers();
        // Create center marker
        this._createMoveMarker();
      }
      this._poly._map.addLayer(this._markerGroup);
    }
  },

  /**
   * @override
   */
  _createMoveMarker: function() {
    if (L.EditToolbar.Edit.MOVE_MARKERS && (this._poly instanceof L.Polygon)) {
      this._moveMarker = new L.Marker(this._getShapeCenter(), {
        icon: this.options.moveIcon
      });
      this._moveMarker.on('mousedown', this._delegateToShape, this);
      this._markerGroup.addLayer(this._moveMarker);
    }
  },

  /**
   * Start dragging through the marker
   * @param  {L.MouseEvent} evt
   */
  _delegateToShape: function(evt) {
    var poly = this._shape || this._poly;
    var marker = evt.target;
    poly.fire('mousedown', L.Util.extend(evt, {
      containerPoint: L.DomUtil.getPosition(marker._icon)
        .add(poly._map._getMapPanePos())
    }));
  },

  /**
   * Polygon centroid
   * @return {L.LatLng}
   */
  _getShapeCenter: function() {
    return this._poly.getCenter();
  },

  /**
   * @override
   */
  removeHooks: function() {
    var poly = this._poly;

    poly.setStyle(poly.options.original);
    if (this._poly._map) {
      this._poly._map.removeLayer(this._markerGroup);
      this._disableDragging();
      delete this._markerGroup;
      delete this._markers;
    }
		this._map = null;
  },

  /**
   * Adds drag start listeners
   */
  _enableDragging: function() {
    if (!this._poly.dragging) {
      this._poly.dragging = new L.Handler.PathDrag(this._poly);
    }
    this._poly.dragging.enable();
    this._poly
      .on('dragstart', this._onStartDragFeature, this)
      .on('dragend', this._onStopDragFeature, this);
  },

  /**
   * Removes drag start listeners
   */
  _disableDragging: function() {
    this._poly.dragging.disable();
    this._poly
      .off('dragstart', this._onStartDragFeature, this)
      .off('dragend', this._onStopDragFeature, this);
  },

  /**
   * Start drag
   * @param  {L.MouseEvent} evt
   */
  _onStartDragFeature: function(evt) {
    this._poly._map.removeLayer(this._markerGroup);
    this._poly.fire('editstart');
  },

  /**
   * Dragging stopped, apply
   * @param  {L.MouseEvent} evt
   */
  _onStopDragFeature: function(evt) {
    var polygon = this._poly;
    var latlngs = polygon._latlngs;

    if (!L.Util.isArray(latlngs[0])) {
      latlngs = [latlngs];
    }

    for (var j = 0, jj = latlngs.length; j < jj; j++) {
      for (var i = 0, len = latlngs[j].length; i < len; i++) {
        // update marker
        var marker = this._markers[i];
        marker.setLatLng(latlngs[j][i]);

        // this one's needed to update the path
        marker._origLatLng = latlngs[j][i];
        if (marker._middleLeft) {
          marker._middleLeft.setLatLng(this._getMiddleLatLng(marker._prev, marker));
        }
        if (marker._middleRight) {
          marker._middleRight.setLatLng(this._getMiddleLatLng(marker, marker._next));
        }
      }
    }

    // show vertices
    this._poly._map.addLayer(this._markerGroup);
    L.Edit.SimpleShape.prototype._updateMoveMarker.call(this);
    this._fireEdit();
  },

  /**
   * Copy from simple shape
   */
  _updateMoveMarker: L.Edit.SimpleShape.prototype._updateMoveMarker,

  /**
   * @override
   */
  _createMarker: function(latlng, index) {
    var marker = this.__createMarker(latlng, index);
    marker
      .on('dragstart', this._hideMoveMarker, this)
      .on('dragend', this._showUpdateMoveMarker, this);
    return marker;
  },

  /**
   * @override
   */
  _removeMarker: function(marker) {
    this.__removeMarker(marker);
    marker
      .off('dragstart', this._hideMoveMarker, this)
      .off('dragend', this._showUpdateMoveMarker, this);
  },

  /**
   * Hide move marker while dragging a vertex
   */
  _hideMoveMarker: function() {
    if (this._moveMarker) {
      this._markerGroup.removeLayer(this._moveMarker);
    }
  },

  /**
   * Show and update move marker
   */
  _showUpdateMoveMarker: function() {
    if (this._moveMarker) {
      this._markerGroup.addLayer(this._moveMarker);
      this._updateMoveMarker();
    }
  }

});

/**
 * @type {L.DivIcon}
 */
L.Edit.PolyVerticesEdit.prototype.options.moveIcon = new L.DivIcon({
  iconSize: new L.Point(8, 8),
  className: 'leaflet-div-icon leaflet-editing-icon leaflet-edit-move'
});

/**
 * Override this if you don't want the central marker
 * @type {Boolean}
 */
L.Edit.PolyVerticesEdit.mergeOptions({
  moveMarker: false
});
