!(function() {
    'use strict';
    // L.Icon.Measurement = L.DivIcon.extend({
    //     initialize: function(measurement, title, options) {
    //         L.Icon.prototype.initialize.call(this, L.extend({
    //             className: 'leaflet-measure-path-measurement',
    //             html: '<div title="' + title + ' ' + measurement + '"><div>' + measurement + '</div>' ,
    //             iconSize: [0, 0]
    //         }, options));
    //     }
    // });

    // L.icon.measurement = function(measurement, title, options) {
    //     return new L.Icon.Measurement(measurement, title, options);
    // };

    // L.Marker.Measurement = L.Marker.extend({
    //     initialize: function(latLng, measurement, title, rotation, options) {
    //         this._rotation = rotation;
    //         var icon = L.icon.measurement(measurement, title, options);
    //         L.Marker.prototype.initialize.call(this, latLng, L.extend({
    //             icon: icon
    //         }, options));
    //     },

    //     _setPos: function() {
    //         L.Marker.prototype._setPos.apply(this, arguments);
    //         this._icon.style.transform += ' rotate(' + this._rotation + 'rad)';
    //     }
    // });

    // L.marker.measurement = function(latLng, measurement, title, rotation, options) {
    //     return new L.Marker.Measurement(latLng, measurement, title, rotation, options);
    // };

    L.Marker.Measurement = L[L.Layer ? 'Layer' : 'Class'].extend({
        options: {
            pane: 'markerPane'
        },

        initialize: function(latlng, measurement, title, rotation, options) {
            L.setOptions(this, options);

            this._latlng = latlng;
            this._measurement = measurement;
            this._title = title;
            this._rotation = rotation;
        },

        addTo: function(map) {
            map.addLayer(this);
            return this;
        },

        onAdd: function(map) {
            this._map = map;
            var pane = this.getPane ? this.getPane() : map.getPanes().markerPane;
            var el = this._element = L.DomUtil.create('div', 'leaflet-zoom-animated leaflet-measure-path-measurement', pane);
            var inner = L.DomUtil.create('div', '', el);
            inner.title = this._title;
            inner.innerHTML = this._measurement;

            map.on('zoomanim', this._animateZoom, this);

            this._setPosition();
        },

        onRemove: function(map) {
            map.off('zoomanim', this._animateZoom, this);
            var pane = this.getPane ? this.getPane() : map.getPanes().markerPane;
            pane.removeChild(this._element);
            this._map = null;
        },

        _setPosition: function() {
            L.DomUtil.setPosition(this._element, this._map.latLngToLayerPoint(this._latlng));
            this._element.style.transform += ' rotate(' + this._rotation + 'rad)';
        },

        _animateZoom: function(opt) {
            var pos = this._map._latLngToNewLayerPoint(this._latlng, opt.zoom, opt.center).round();
            L.DomUtil.setPosition(this._element, pos);
            this._element.style.transform += ' rotate(' + this._rotation + 'rad)';
        }
    });

    L.marker.measurement = function(latLng, measurement, title, rotation, options) {
        return new L.Marker.Measurement(latLng, measurement, title, rotation, options);
    };

    var formatDistance = function(d) {
        var unit,
            feet;

        if (this._measurementOptions.imperial) {
            feet = d / 0.3048;
            if (feet > 3000) {
                d = d / 1609.344;
                unit = 'mi';
            } else {
                d = feet;
                unit = 'ft';
            }
        } else {
            if (d > 1000) {
                d = d / 1000;
                unit = 'km';
            } else {
                unit = 'm';
            }
        }

        if (d < 100) {
            return d.toLocaleString() + ' ' + unit;
        } else {
            return Math.round(d).toLocaleString() + ' ' + unit;
        }
    }

    var formatArea = function(a) {
        var unit,
            sqfeet;

        if (this._measurementOptions.imperial) {
            if(a > 258998.811) {
                a = a / 2589988.11;
                unit = 'sq-mi';
            } else if (a > 404.685642) {
                a = a / 4046.85642;
                unit = 'acres';
            } else {
                a = a / 0.09290304;
                unit = 'sq-ft';
            }
        } else {
            if (a > 100000) {
                a = a / 100000;
                unit = 'sq-km';
            } else {
                unit = 'sq-m';
            }
        }

        if (a < 100) {
            return a.toLocaleString() + ' ' + unit;
        } else {
            return Math.round(a).toLocaleString() + ' ' + unit;
        }
    }

    var RADIUS = 6378137;
    // ringArea function copied from geojson-area
    // (https://github.com/mapbox/geojson-area)
    // This function is distributed under a separate license,
    // see LICENSE.md.
    var ringArea = function ringArea(coords) {
        var rad = function rad(_) {
            return _ * Math.PI / 180;
        };
        var p1, p2, p3, lowerIndex, middleIndex, upperIndex,
        area = 0,
        coordsLength = coords.length;

        if (coordsLength > 2) {
            for (var i = 0; i < coordsLength; i++) {
                if (i === coordsLength - 2) {// i = N-2
                    lowerIndex = coordsLength - 2;
                    middleIndex = coordsLength -1;
                    upperIndex = 0;
                } else if (i === coordsLength - 1) {// i = N-1
                    lowerIndex = coordsLength - 1;
                    middleIndex = 0;
                    upperIndex = 1;
                } else { // i = 0 to N-3
                    lowerIndex = i;
                    middleIndex = i+1;
                    upperIndex = i+2;
                }
                p1 = coords[lowerIndex];
                p2 = coords[middleIndex];
                p3 = coords[upperIndex];
                area += ( rad(p3.lng) - rad(p1.lng) ) * Math.sin( rad(p2.lat));
            }

            area = area * RADIUS * RADIUS / 2;
        }

        return Math.abs(area);
    };

    var circleArea = function circleArea(d) {
        var rho = d / RADIUS;
        return 2 * Math.PI * RADIUS * RADIUS * (1 - Math.cos(rho));
    };

    var override = function(method, fn, hookAfter) {
        if (!hookAfter) {
            return function() {
                method.apply(this, arguments);
                fn.apply(this, arguments);
            }
        } else {
            return function() {
                fn.apply(this, arguments);
                method.apply(this, arguments);
            }
        }
    };

    L.Polyline.include({
        showMeasurements: function(options) {
            if (!this._map || this._measurementLayer) return this;

            this._measurementOptions = L.extend({
                showOnHover: false,
                minPixelDistance: 30,
                showDistances: true,
                showArea: true,
                lang: {
                    totalLength: 'Total length',
                    totalArea: 'Total area',
                    segmentLength: 'Segment length'
                }
            }, options || {});

            this._measurementLayer = L.layerGroup().addTo(this._map);
            this.updateMeasurements();

            this._map.on('zoomend', this.updateMeasurements, this);

            return this;
        },

        hideMeasurements: function() {
            this._map.off('zoomend', this.updateMeasurements, this);

            if (!this._measurementLayer) return this;
            this._map.removeLayer(this._measurementLayer);
            this._measurementLayer = null;

            return this;
        },

        onAdd: override(L.Polyline.prototype.onAdd, function() {
            if (this.options.showMeasurements) {
                this.showMeasurements(this.options.measurementOptions);
            }
        }),

        onRemove: override(L.Polyline.prototype.onRemove, function() {
            this.hideMeasurements();
        }, true),

        setLatLngs: override(L.Polyline.prototype.setLatLngs, function() {
            this.updateMeasurements();
        }),

        spliceLatLngs: override(L.Polyline.prototype.spliceLatLngs, function() {
            this.updateMeasurements();
        }),

        formatDistance: formatDistance,
        formatArea: formatArea,

        updateMeasurements: function() {
            if (!this._measurementLayer) return;

            var latLngs = this.getLatLngs(),
                isPolygon = this instanceof L.Polygon,
                options = this._measurementOptions,
                totalDist = 0,
                formatter,
                ll1,
                ll2,
                p1,
                p2,
                pixelDist,
                dist;

            if (latLngs && latLngs.length && L.Util.isArray(latLngs[0])) {
                // Outer ring is stored as an array in the first element,
                // use that instead.
                latLngs = latLngs[0];
            }

            this._measurementLayer.clearLayers();

            if (this._measurementOptions.showDistances && latLngs.length > 1) {
                formatter = this._measurementOptions.formatDistance || L.bind(this.formatDistance, this);

                for (var i = 1, len = latLngs.length; (isPolygon && i <= len) || i < len; i++) {
                    ll1 = latLngs[i - 1];
                    ll2 = latLngs[i % len];
                    dist = ll1.distanceTo(ll2);
                    totalDist += dist;

                    p1 = this._map.latLngToLayerPoint(ll1);
                    p2 = this._map.latLngToLayerPoint(ll2);

                    pixelDist = p1.distanceTo(p2);

                    if (pixelDist >= options.minPixelDistance) {
                        L.marker.measurement(
                            this._map.layerPointToLatLng([(p1.x + p2.x) / 2, (p1.y + p2.y) / 2]),
                            formatter(dist), options.lang.segmentLength, this._getRotation(ll1, ll2), options)
                            .addTo(this._measurementLayer);
                    }
                }

                // Show total length for polylines
                if (!isPolygon) {
                    L.marker.measurement(ll2, formatter(totalDist), options.lang.totalLength, 0, options)
                        .addTo(this._measurementLayer);
                }
            }

            if (isPolygon && options.showArea && latLngs.length > 2) {
                formatter = options.formatArea || L.bind(this.formatArea, this);
                var area = ringArea(latLngs);
                L.marker.measurement(this.getBounds().getCenter(),
                    formatter(area), options.lang.totalArea, 0, options)
                    .addTo(this._measurementLayer);
            }
        },

        _getRotation: function(ll1, ll2) {
            var p1 = this._map.project(ll1),
                p2 = this._map.project(ll2);

            return Math.atan((p2.y - p1.y) / (p2.x - p1.x));
        }
    });

    L.Polyline.addInitHook(function() {
        if (this.options.showMeasurements) {
            this.showMeasurements();
        }
    });

    L.Circle.include({
        showMeasurements: function(options) {
            if (!this._map || this._measurementLayer) return this;

            this._measurementOptions = L.extend({
                showOnHover: false,
                showArea: true,
                lang: {
                    totalArea: 'Total area',
                }
            }, options || {});

            this._measurementLayer = L.layerGroup().addTo(this._map);
            this.updateMeasurements();

            this._map.on('zoomend', this.updateMeasurements, this);

            return this;
        },

        hideMeasurements: function() {
            this._map.on('zoomend', this.updateMeasurements, this);

            if (!this._measurementLayer) return this;
            this._map.removeLayer(this._measurementLayer);
            this._measurementLayer = null;

            return this;
        },

        onAdd: override(L.Circle.prototype.onAdd, function() {
            if (this.options.showMeasurements) {
                this.showMeasurements(this.options.measurementOptions);
            }
        }),

        onRemove: override(L.Circle.prototype.onRemove, function() {
            this.hideMeasurements();
        }, true),

        setLatLng: override(L.Circle.prototype.setLatLng, function() {
            this.updateMeasurements();
        }),

        setRadius: override(L.Circle.prototype.setRadius, function() {
            this.updateMeasurements();
        }),

        formatArea: formatArea,

        updateMeasurements: function() {
            if (!this._measurementLayer) return;

            var latLng = this.getLatLng(),
                options = this._measurementOptions,
                formatter = options.formatArea || L.bind(this.formatArea, this);

            this._measurementLayer.clearLayers();

            if (options.showArea) {
                formatter = options.formatArea || L.bind(this.formatArea, this);
                var area = circleArea(this.getRadius());
                L.marker.measurement(latLng,
                    formatter(area), options.lang.totalArea, 0, options)
                    .addTo(this._measurementLayer);
            }
        }
    })

    L.Circle.addInitHook(function() {
        if (this.options.showMeasurements) {
            this.showMeasurements();
        }
    });
})();

