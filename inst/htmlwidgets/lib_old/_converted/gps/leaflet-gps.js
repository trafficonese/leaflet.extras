(function (factory) {
    if(typeof define === 'function' && define.amd) {
    //AMD
        define(['leaflet'], factory);
    } else if(typeof module !== 'undefined') {
    // Node/CommonJS
        module.exports = factory(require('leaflet'));
    } else {
    // Browser globals
        if(typeof window.L === 'undefined')
            throw 'Leaflet must be loaded first';
        factory(window.L);
    }
})(function (L) {

L.Control.Gps = L.Control.extend({

	includes: L.Mixin.Events,
	//
	//Managed Events:
	//	Event			Data passed			Description
	//
	//	gps:located		{latlng, marker}	fired after gps marker is located
	//	gps:disabled							fired after gps is disabled
	//
	//Methods exposed:
	//	Method 			Description
	//
	//  getLocation		return Latlng and marker of current position
	//  activate		active tracking on runtime
	//  deactivate		deactive tracking on runtime
	//
	options: {
		autoActive: false,		//activate control at startup
		autoCenter: false,		//move map when gps location change
		maxZoom: null,			//max zoom for autoCenter
		textErr: null,			//error message on alert notification
		callErr: null,			//function that run on gps error activating
		style: {				//default L.CircleMarker styles
			radius: 5,
			weight: 2,
			color: '#c20',
			opacity: 1,
			fillColor: '#f23',
			fillOpacity: 1
		},
		marker: null,			//L.Marker used for location, default use a L.CircleMarker
		accuracy: true,		//show accuracy Circle
		title: 'Center map on your location',
		position: 'topleft',
		transform: function(latlng) { return latlng },
		setView: false
		//TODO add gpsLayer
		//TODO timeout autoCenter
	},

	initialize: function(options) {
		if(options && options.style)
			options.style = L.Util.extend({}, this.options.style, options.style);
		L.Util.setOptions(this, options);
		this._errorFunc = this.options.callErr || this.showAlert;
		this._isActive = false;//global state of gps
		this._firstMoved = false;//global state of gps
		this._currentLocation = null;	//store last location
	},

	onAdd: function (map) {

		this._map = map;

		var container = L.DomUtil.create('div', 'leaflet-control-gps');

		this._button = L.DomUtil.create('a', 'gps-button', container);
		this._button.href = '#';
		this._button.title = this.options.title;
		L.DomEvent
			.on(this._button, 'click', L.DomEvent.stop, this)
			.on(this._button, 'click', this._switchGps, this);

		this._alert = L.DomUtil.create('div', 'gps-alert', container);
		this._alert.style.display = 'none';

		this._gpsMarker = this.options.marker ? this.options.marker : new L.CircleMarker([0,0], this.options.style);
		//if(this.options.accuracy)
		//	this._accuracyCircle = new L.Circle([0,0], this.options.style);

		this._map
			.on('locationfound', this._drawGps, this)
			.on('locationerror', this._errorGps, this);

		if(this.options.autoActive)
			this.activate();

		return container;
	},

	onRemove: function(map) {
		this.deactivate();
	},

	_switchGps: function() {
		if(this._isActive)
			this.deactivate();
		else
			this.activate();
	},

	getLocation: function() {	//get last location
		return this._currentLocation;
	},

	activate: function() {
		this._isActive = true;
		this._map.addLayer( this._gpsMarker );
		this._map.locate({
			enableHighAccuracy: true,
			watch: true,
			//maximumAge:s
			setView: this.options.setView,	//automatically sets the map view to the user location
			maxZoom: this.options.maxZoom
		});
	},

	deactivate: function() {
			this._isActive = false;
		this._firstMoved = false;
		this._map.stopLocate();
		L.DomUtil.removeClass(this._button, 'active');
		this._map.removeLayer( this._gpsMarker );
		//this._gpsMarker.setLatLng([-90,0]);  //move to antarctica!
		//TODO make method .hide() using _icon.style.display = 'none'
		this.fire('gps:disabled');
	},

	_drawGps: function(e) {
		//TODO use e.accuracy for gps circle radius/color
		this._currentLocation = this.options.transform(e.latlng);
			
		this._gpsMarker.setLatLng(this._currentLocation);

		if(this._isActive && (!this._firstMoved || this.options.autoCenter))
			this._moveTo(this._currentLocation);
	//    	if(this._gpsMarker.accuracyCircle)
	//    		this._gpsMarker.accuracyCircle.setRadius((e.accuracy / 2).toFixed(0));
			
		this.fire('gps:located', {latlng: this._currentLocation, marker: this._gpsMarker});
		
		L.DomUtil.addClass(this._button, 'active');
	},

	_moveTo: function(latlng) {
		this._firstMoved = true;
		if(this.options.maxZoom)
			this._map.setView(latlng, Math.min(this._map.getZoom(), this.options.maxZoom) );
		else
			this._map.panTo(latlng);
	},

	_errorGps: function(e) {
		this.deactivate();
		this._errorFunc.call(this, this.options.textErr || e.message);
	},

	/*	_updateAccuracy: function (event) {
			var newZoom = this._map.getZoom(),
				scale = this._map.options.crs.scale(newZoom);
			this._gpsMarker.setRadius(this.options.style.radius * scale);
			this._gpsMarker.redraw();
		},
	*/
	showAlert: function(text) {
		this._alert.style.display = 'block';
		this._alert.innerHTML = text;
		var that = this;
		clearTimeout(this.timerAlert);
		this.timerAlert = setTimeout(function() {
			that._alert.style.display = 'none';
		}, 2000);
	}
});

L.Map.addInitHook(function () {
	if (this.options.gpsControl) {
		this.gpsControl = L.control.gps(this.options.gpsControl);
		this.addControl(this.gpsControl);
	}
});

L.control.gps = function (options) {
	return new L.Control.Gps(options);
};

return L.Control.Gps;

});
