/*
    Created:        2018/06/12 by James Austin - Trafford Data Lab
    Purpose:        Uses openrouteservice API to create isolines showing areas within reach of certain travel times based on different modes of travel or distance. See https://wiki.openstreetmap.org/wiki/Isochrone for more information
    Dependencies:   Leaflet.js (external library), openrouteservice.org API (requires a key - free service available via registration)
    Licence:        https://github.com/traffordDataLab/leaflet.reachability/blob/master/LICENSE
    Notes:          Can be displayed in a collapsed or expanded state. Content for all GUI elements can be html or an icon etc.
                    © Powered by openrouteservice https://openrouteservice.org/
*/
L.Control.Reachability = L.Control.extend({
    options: {
        // Leaflet positioning options
        position: 'topleft',                                                        // Leaflet control pane position
        pane: 'overlayPane',                                                        // Leaflet pane to add the isolines GeoJSON to
        zIndexMouseMarker: 9000,                                                    // Needs to be greater than any other layer in the map - this is an invisible marker tied to the mouse pointer when the control is activated to prevent clicks interacting with other map objects

        // Main control settings and styling
        collapsed: true,                                                            // Operates in a similar way to the Leaflet layer control - can be collapsed into a standard single control which expands on-click (true) or is displayed fully expanded (false)
        controlContainerStyleClass: '',                                             // The container for the plugin control will usually be styled with the standard Leaflet control styling, however this option allows for customisation
        drawActiveMouseClass: 'leaflet-crosshair',                                  // CSS class applied to the mouse pointer when the plugin is in draw mode

        // The containing div to hold the actual user interface controls
        settingsContainerStyleClass: 'reachability-control-settings-container',     // The container holding the user interface controls which is displayed if collapsed is false, or when the user expands the control by clicking on the expand button
        settingsButtonStyleClass: 'reachability-control-settings-button',           // Generic class to style the setting buttons uniformly - further customisation per button is available with specific options below
        activeStyleClass: 'reachability-control-active',                            // Indicate to the user which button is active in the settings and the collapsed state of the control if settings are active
        errorStyleClass: 'reachability-control-error',                              // Gives feedback to the user via the buttons in the user interface that something went wrong

        // If collapsed == true a button is displayed to expand the control onclick/touch
        expandButtonContent: '&#x2609;',                                            // HTML to display within the control if it is collapsed. If you want an icon from services like Fontawesome pass '' for this value and set the StyleClass option
        expandButtonStyleClass: 'reachability-control-expand-button',               // Allow options for styling - if you want to use an icon from services like fontawesome pass the declarations here, e.g. 'fa fa-home' etc.
        expandButtonTooltip: 'Show reachability options',                           // Tooltip to appear on-hover

        // Collapse button displayed within the settings container if collapsed == true
        collapseButtonContent: '^',
        collapseButtonStyleClass: 'reachability-control-collapse-button',
        collapseButtonTooltip: 'Hide reachability options',

        // Draw isochrones button
        drawButtonContent: 'drw',
        drawButtonStyleClass: '',
        drawButtonTooltip: 'Draw reachability',

        // Delete button to remove any current isoline groups drawn on the map
        deleteButtonContent: 'del',
        deleteButtonStyleClass: '',
        deleteButtonTooltip: 'Delete reachability',

        // Isoline calculation mode - either distance or time
        distanceButtonContent: 'dst',
        distanceButtonStyleClass: '',
        distanceButtonTooltip: 'Reachability based on distance',

        timeButtonContent: 'tme',
        timeButtonStyleClass: '',
        timeButtonTooltip: 'Reachability based on time',

        // Travel modes
        travelModeButton1Content: 'car',
        travelModeButton1StyleClass: '',
        travelModeButton1Tooltip: 'Travel mode: car',

        travelModeButton2Content: 'cyc',
        travelModeButton2StyleClass: '',
        travelModeButton2Tooltip: 'Travel mode: cycling',

        travelModeButton3Content: 'wlk',
        travelModeButton3StyleClass: '',
        travelModeButton3Tooltip: 'Travel mode: walking',

        travelModeButton4Content: 'wch',
        travelModeButton4StyleClass: '',
        travelModeButton4Tooltip: 'Travel mode: wheelchair',

        // Control for the range parameter
        rangeControlDistanceTitle: 'Dist.',
        rangeControlDistance: null,                     // Custom range specified as an array which supersedes rangeControlDistanceMax and rangeControlDistanceInterval if not null
        rangeControlDistanceMax: 3,
        rangeControlDistanceInterval: 0.5,
        rangeControlDistanceUnits: 'km',                // Can be either 'm', 'km' or 'mi'

        rangeControlTimeTitle: 'Time',
        rangeControlTime: null,                         // \  Custom range specified as an array which supersedes rangeControlTimeMax and rangeControlTimeInterval if not null
        rangeControlTimeMax: 30,                        //  > All these values will be multiplied by 60 to convert to seconds - no other unit of time is allowed
        rangeControlTimeInterval: 5,                    // /

        rangeTypeDefault: 'time',                       // Range can be either distance or time - any value other than 'distance' passed to the API is assumed to be 'time'
        rangeIntervalsLabel: 'intervals',               // The 'show intervals?' checkbox label

        // API settings
        apiKey: '',                                     // openrouteservice API key - the service which returns the isoline polygons based on the various options/parameters
        travelModeProfile1: 'driving-car',              // \
        travelModeProfile2: 'cycling-regular',          //   API choices are: 'driving-car', 'driving-hgv', 'cycling-regular', 'cycling-road', 'cycling-mountain', 'cycling-electric', 'foot-walking', 'foot-hiking' and 'wheelchair'
        travelModeProfile3: 'foot-walking',             //   Setting any of these to null results in the button not being displayed
        travelModeProfile4: 'wheelchair',               // /
        travelModeDefault: null,                        // Set travel mode default - if this is not equal to one of the 4 profiles above it is set to the value of travelModeProfile1 in the onAdd function
        smoothing: 0,                                   // Determines the level of generalisation applied to the isochrone polygons. Closer to 100 results in a more generalised shape
        attributes: '"area","reachfactor","total_pop"', // Optional data returned from the API: area of the isoline(s), ratio of the area of an isochrone to the theoretical area based on ecludian distance, estimated population living within the area of an isoline

        // Isoline styling and interaction
        styleFn: null,                                  // External function to call which styles the isolines returned from API call
        mouseOverFn: null,                              // External function to call when a mouseover event occurs on an isoline
        mouseOutFn: null,                               // External function to call when a mouseout event occurs on an isoline
        clickFn: null,                                  // External function to call when a click event occurs on an isoline

        // Isoline origin marker styling and interaction
        showOriginMarker: true,                         // If we want a marker to indicate the origin of the isoline
        markerFn: null,                                 // External function to call to create a custom marker at the origin of the isoline if showOriginMarker is true - null creates a default circleMarker
        markerOverFn: null,                             // External function to call when a mouseover event occurs on an origin marker
        markerOutFn: null,                              // External function to call when a mouseout event occurs on an origin marker
        markerClickFn: null                             // External function to call when a click event occurs on an origin marker
    },

    onAdd: function (map) {
        // Initial settings
        this.version = '2.0.0';
        this._map = map;
        this._collapsed = this.options.collapsed;
        this._drawMode = false;
        this._deleteMode = false;
        this._rangeIsDistance = (this.options.rangeTypeDefault == 'distance') ? true : false;

        // Choose the travel mode button which is selected by default
        if (this.options.travelModeProfile1 == null) this.options.travelModeProfile1 = 'driving-car';   // travelModeProfile1 cannot be null as we must ensure we have at least one valid mode of travel to query the API
        this._travelMode = this.options.travelModeDefault;
        if (this._travelMode == null || (this._travelMode != this.options.travelModeProfile1 && this._travelMode != this.options.travelModeProfile2 && this._travelMode != this.options.travelModeProfile3 && this._travelMode != this.options.travelModeProfile4)) this._travelMode = this.options.travelModeProfile1;

        // Invisible Leaflet marker to follow the mouse pointer when control is activated, preventing interactions with map elements which we don't want whilst in draw or delete mode
        this._mouseMarker = null;

        // Holds the latest GeoJSON data returned from the API
        this.latestIsolines = null;

        // Group object to hold each GeoJSON 'set' of isolines return from the API via this.latestIsolines
        this.isolinesGroup = L.geoJSON(null, {
          style: this.options.styleFn,
          pane: this.options.pane,
          attribution: '&copy; Powered by <a href="https://openrouteservice.org/" target="_blank">openrouteservice</a>'
        })

        // Main container for the control - this is added to the map in the Leaflet control pane
        this._container = L.DomUtil.create('div', 'leaflet-bar ' + this.options.controlContainerStyleClass);
        L.DomEvent.disableClickPropagation(this._container);

        // Create the components for the user interface
        this._createUI();

        // Fire event to inform that the control has been added to the map
        this._map.fire('reachability:control_added');

        // Leaflet draws the control on the map
        return this._container;
    },

    onRemove: function (map) {
        // clean up - remove any styles, event listeners, layers etc.
        this._deactivateDraw();
        this.isolinesGroup.removeFrom(this._map);
        this.isolinesGroup.clearLayers();

        // Fire event to inform that the control has been removed from the map
        this._map.fire('reachability:control_removed');
    },

    _decimalPlaces: function (n) {
        // Function to calculate the number of decimal places in a given number.
        // Converts input to a string so won't error if NaN.
        // If a decimal point is found it returns the number of characters to the right, otherwise it returns 0.
    	n = String(n);
      	return (n.indexOf('.') > -1) ? n.length-n.indexOf('.')-1 : 0;
    },

    _createUI: function () {
        // Container for the user interface controls - these will be displayed permanently if the collapsed option is false, otherwise when the user clicks on the collapsed control toggle button
        this._uiContainer = L.DomUtil.create('div', this.options.settingsContainerStyleClass);
        this._container.appendChild(this._uiContainer);

        // Container for the action and mode buttons
        this._actionsAndModesContainer = L.DomUtil.create('div', 'reachability-control-settings-block-container', this._uiContainer);

        // Draw button - to create isolines
        this._drawControl = this._createButton('span', this.options.drawButtonContent, this.options.drawButtonTooltip, this.options.settingsButtonStyleClass + ' ' + this.options.drawButtonStyleClass, this._actionsAndModesContainer, this._toggleDraw);

        // Delete button - to remove isolines
        this._deleteControl = this._createButton('span', this.options.deleteButtonContent, this.options.deleteButtonTooltip, this.options.settingsButtonStyleClass + ' ' + this.options.deleteButtonStyleClass, this._actionsAndModesContainer, this._toggleDelete);

        // Distance setting button - to calculate isolines based on distance (isodistance)
        this._distanceControl = this._createButton('span', this.options.distanceButtonContent, this.options.distanceButtonTooltip, this.options.settingsButtonStyleClass + ' ' + this.options.distanceButtonStyleClass, this._actionsAndModesContainer, this._setRangeByDistance);

        // Time setting button - to calculate isolines based on time (isochrones)
        this._timeControl = this._createButton('span', this.options.timeButtonContent, this.options.timeButtonTooltip, this.options.settingsButtonStyleClass + ' ' + this.options.timeButtonStyleClass, this._actionsAndModesContainer, this._setRangeByTime);


        // Container for the travel mode buttons
        this._modesContainer = L.DomUtil.create('div', 'reachability-control-settings-block-container', this._uiContainer);

        // Travel mode 1 button - this is the only required button as there has to be at least one mode of travel to query the API
        this._travelMode1Control = this._createButton('span', this.options.travelModeButton1Content, this.options.travelModeButton1Tooltip, this.options.settingsButtonStyleClass + ' ' + this.options.travelModeButton1StyleClass, this._modesContainer, this._setTravelMode1);

        // Travel mode 2 button
        this._travelMode2Control = (this.options.travelModeProfile2 != null) ? this._createButton('span', this.options.travelModeButton2Content, this.options.travelModeButton2Tooltip, this.options.settingsButtonStyleClass + ' ' + this.options.travelModeButton2StyleClass, this._modesContainer, this._setTravelMode2) : L.DomUtil.create('span', '');

        // Travel mode 3 button
        this._travelMode3Control = (this.options.travelModeProfile3 != null) ? this._createButton('span', this.options.travelModeButton3Content, this.options.travelModeButton3Tooltip, this.options.settingsButtonStyleClass + ' ' + this.options.travelModeButton3StyleClass, this._modesContainer, this._setTravelMode3) : L.DomUtil.create('span', '');

        // Travel mode 4 button
        this._travelMode4Control = (this.options.travelModeProfile4 != null) ? this._createButton('span', this.options.travelModeButton4Content, this.options.travelModeButton4Tooltip, this.options.settingsButtonStyleClass + ' ' + this.options.travelModeButton4StyleClass, this._modesContainer, this._setTravelMode4) : L.DomUtil.create('span', '');


        // Distance range title
        this._rangeDistanceTitle = L.DomUtil.create('span', 'reachability-control-range-title reachability-control-hide-content', this._uiContainer);
        this._rangeDistanceTitle.innerHTML = this.options.rangeControlDistanceTitle;

        // Distance range control
        this._rangeDistanceList = L.DomUtil.create('select', 'reachability-control-range-list reachability-control-hide-content', this._uiContainer);
        if (this.options.rangeControlDistance == null) {
            // Calculate the greatest number of decimal places required for the values displayed in the select list.
            var decimalPlacesDistance = Math.max(this._decimalPlaces(this.options.rangeControlDistanceMax), this._decimalPlaces(this.options.rangeControlDistanceInterval));

            for (var i = this.options.rangeControlDistanceInterval; i <= this.options.rangeControlDistanceMax; i += this.options.rangeControlDistanceInterval) {
                if (String(i).length > i.toFixed(decimalPlacesDistance).length) i = parseFloat(i.toFixed(decimalPlacesDistance)); // this is to avoid issues of 0.30000000000000004 being calculated instead of an expected value of 0.3 etc. (see https://floating-point-gui.de/)

                var opt = L.DomUtil.create('option', '', this._rangeDistanceList);
                opt.setAttribute('value', i);
                opt.innerHTML = i + ' ' + this.options.rangeControlDistanceUnits;
            }
        }
        else {
            // Create select list options using the range array
            for (var i = 0; i < this.options.rangeControlDistance.length; i++) {
                var opt = L.DomUtil.create('option', '', this._rangeDistanceList);
                opt.setAttribute('value', this.options.rangeControlDistance[i]);
                opt.innerHTML = this.options.rangeControlDistance[i] + ' ' + this.options.rangeControlDistanceUnits;
            }
        }


        // Time range title
        this._rangeTimeTitle = L.DomUtil.create('span', 'reachability-control-range-title reachability-control-hide-content', this._uiContainer);
        this._rangeTimeTitle.innerHTML = this.options.rangeControlTimeTitle;

        // Time range control
        this._rangeTimeList = L.DomUtil.create('select', 'reachability-control-range-list reachability-control-hide-content', this._uiContainer);
        if (this.options.rangeControlTime == null) {
            // Calculate the greatest number of decimal places required for the values displayed in the select list.
            var decimalPlacesTime = Math.max(this._decimalPlaces(this.options.rangeControlTimeMax), this._decimalPlaces(this.options.rangeControlTimeInterval));

            for (var i = this.options.rangeControlTimeInterval; i <= this.options.rangeControlTimeMax; i += this.options.rangeControlTimeInterval) {
                if (String(i).length > i.toFixed(decimalPlacesTime).length) i = parseFloat(i.toFixed(decimalPlacesTime)); // this is to avoid issues of 0.30000000000000004 being calculated instead of an expected value of 0.3 etc. (see https://floating-point-gui.de/)

                var opt = L.DomUtil.create('option', '', this._rangeTimeList);
                opt.setAttribute('value', i);
                opt.innerHTML = i + ' min';
            }
        }
        else {
            // Create select list options using the range array
            for (var i = 0; i < this.options.rangeControlTime.length; i++) {
                var opt = L.DomUtil.create('option', '', this._rangeTimeList);
                opt.setAttribute('value', this.options.rangeControlTime[i]);
                opt.innerHTML = this.options.rangeControlTime[i] + ' min';
            }
        }


        /*
            Show intervals checkbox
                - selected means that we want to show a range of isolines, from the minimum value up to the chosen values
                - not selected means that we want to only show one isoline for the selected value
        */
        this._showIntervalContainer = L.DomUtil.create('span', 'reachability-control-show-range-interval', this._uiContainer);
        this._showInterval = L.DomUtil.create('input', '', this._showIntervalContainer);
        this._showInterval.setAttribute('id', 'rangeInterval');
        this._showInterval.setAttribute('type', 'checkbox');
        this._showIntervalLabel = L.DomUtil.create('label', '', this._showIntervalContainer);
        this._showIntervalLabel.setAttribute('for', 'rangeInterval');
        this._showIntervalLabel.innerHTML = this.options.rangeIntervalsLabel;


        // Select the correct range type button and show the correct range list
        if (this._rangeIsDistance) {
            L.DomUtil.addClass(this._distanceControl, this.options.activeStyleClass);
            L.DomUtil.removeClass(this._rangeDistanceTitle, 'reachability-control-hide-content');
            L.DomUtil.removeClass(this._rangeDistanceList, 'reachability-control-hide-content');
        }
        else {
            L.DomUtil.addClass(this._timeControl, this.options.activeStyleClass);
            L.DomUtil.removeClass(this._rangeTimeTitle, 'reachability-control-hide-content');
            L.DomUtil.removeClass(this._rangeTimeList, 'reachability-control-hide-content');
        }

        // Select the correct travel mode button
        this._toggleTravelMode(null);   // Null causes the function to operate in a different way, setting up the initial state


        // If the control is in its collapsed state we need to create buttons to toggle between collapsed and expanded states and initially hide the main UI
        if (this._collapsed) {
            // Hide the UI initially as the control is in the collapsed state
            L.DomUtil.addClass(this._uiContainer, 'reachability-control-hide-content');

            // Create a container for the expand button - because we cannot easily hide a link tag created via the _createButton function adding the .reachability-control-hide-content CSS class
            this._expandButtonContainer = L.DomUtil.create('span', '');
            this._container.appendChild(this._expandButtonContainer);

            // Create a button to expand the control to reveal the full user interface
            this._createButton('a', this.options.expandButtonContent, this.options.expandButtonTooltip, this.options.expandButtonStyleClass, this._expandButtonContainer, this._expand);

            // Create a button to collapse the user interface - this is displayed underneath the user interface
            this._createButton('span', this.options.collapseButtonContent, this.options.collapseButtonTooltip, this.options.collapseButtonStyleClass, this._uiContainer, this._collapse);
        }
    },

    // An amended version of the Leaflet.js function of the same name, (c) 2010-2018 Vladimir Agafonkin, (c) 2010-2011 CloudMade
    // Allows interface elements to be created using different tags, not just anchors
    _createButton: function (tag, html, title, className, container, fn) {
        // Create a control button
        var button = L.DomUtil.create(tag, className, container);
        button.innerHTML = html;
        button.title = title;
        if (tag === 'a') button.href = '#';

        // For assistive technologies e.g. screen readers
        button.setAttribute('role', 'button');
		button.setAttribute('aria-label', title);

        // Set events
        L.DomEvent
            .on(button, 'mousedown touchstart dblclick', L.DomEvent.stopPropagation)
            .on(button, 'click', L.DomEvent.stop)
            .on(button, 'click', fn, this);

		return button;
	},

    _expand: function () {
        // Show the user interface container
        L.DomUtil.removeClass(this._uiContainer, 'reachability-control-hide-content');

        // Hide the toggle container
        L.DomUtil.addClass(this._expandButtonContainer, 'reachability-control-hide-content');

        // Remove the active class from the control container if either the draw or delete modes are active
        if (L.DomUtil.hasClass(this._container, this.options.activeStyleClass)) L.DomUtil.removeClass(this._container, this.options.activeStyleClass);

        // Fire event to inform that the control has been expanded
        this._map.fire('reachability:control_expanded');
    },

    _collapse: function () {
        // Hide the user interface container
        L.DomUtil.addClass(this._uiContainer, 'reachability-control-hide-content');

        // Show the toggle container
        L.DomUtil.removeClass(this._expandButtonContainer, 'reachability-control-hide-content');

        // Add the active class to the control container if either the draw or delete modes are active
        if ((this._drawMode || this._deleteMode) && !L.DomUtil.hasClass(this._container, this.options.activeStyleClass)) L.DomUtil.addClass(this._container, this.options.activeStyleClass);

        // Fire event to inform that the control has been collapsed
        this._map.fire('reachability:control_collapsed');
    },

    // Toggle the draw control between active and inactive states
    _toggleDraw: function () {
        if (this._deleteMode) this._deactivateDelete();    // deactivate the delete control

        (this._drawMode) ? this._deactivateDraw() : this._activateDraw();
    },

    // Toggle the delete control between active and inactive states
    _toggleDelete: function () {
        if (this._drawMode) this._deactivateDraw();    // deactivate the draw control

        (this._deleteMode) ? this._deactivateDelete() : this._activateDelete();
    },

    _activateDraw: function () {
        // Set the flag to true and add active class to the draw button to show it's currently selected
        this._drawMode = true;
        L.DomUtil.addClass(this._drawControl, this.options.activeStyleClass);

        // Deactivate delete mode if currently active
        if (this._deleteMode) this._deactivateDelete();

        this._drawRequestRegistered = false;     // flag to indicate if a 'click-like' event has been registered

        /*
            Using a technique deployed in Jacob Toye's Leaflet.Draw plugin:
            We create an invisible mouse marker to capture the click event to give us a lat/lng to calculate the isolines.
            This allows us to style the mouse pointer easily and also not interact with other map elements whilst in draw mode.
        */
        if (!this._mouseMarker) {
            this._mouseMarker = L.marker(this._map.getCenter(), {
                icon: L.divIcon({
                    className: this.options.drawActiveMouseClass,
                    iconAnchor: [400, 400],
                    iconSize: [800, 800]
                }),
                opacity: 0,
                zIndexOffset: this.options.zIndexMouseMarker
            });
        }

        // Add events to the marker and then add the marker to the map
        this._mouseMarker
            .on('mousemove', this._updatePointerMarkerPosition, this)
            .on('click', this._registerDrawRequest, this)
            .addTo(this._map);

        /*
            Add a duplicate events to the map for mousemove and click in case the mouse pointer goes outside of the mouseMarker.
            The mousedown is for touch interactions to update the marker position so that the click event is registered in the correct place (Safari and Firefox seem to be the ones with issues here).
            NOTE: not using touchdown as it isn't always supported.
        */
        this._map
            .on('mousemove', this._updatePointerMarkerPosition, this)
            .on('mousedown', this._updatePointerMarkerPosition, this)
            .on('click', this._registerDrawRequest, this);

        // Fire an event to indicate that the control draw mode has been activated
        this._map.fire('reachability:draw_activated');
    },

    _deactivateDraw: function () {
        this._drawMode = false;     // ensure we explicitly set the mode - we may not have come here from a click on the main control
        L.DomUtil.removeClass(this._drawControl, this.options.activeStyleClass);    // remove the selected style

        // Remove the mouse marker and its events from the map and destroy the marker
        if (this._mouseMarker !== null) {
            this._mouseMarker
                .off('mousemove', this._updatePointerMarkerPosition, this)
                .off('click', this._registerDrawRequest, this)
                .removeFrom(this._map);
            this._mouseMarker = null;
        }

        // Remove map events
        this._map
            .off('mousemove', this._updatePointerMarkerPosition, this)
            .off('mousedown', this._updatePointerMarkerPosition, this)
            .off('click', this._registerDrawRequest, this);

        // Fire an event to indicate that the control draw mode has been deactivated
        this._map.fire('reachability:draw_deactivated');
    },

    _activateDelete: function () {
        // We want to delete some isoline groups
        var isolinesGroupNum = this.isolinesGroup.getLayers().length;

        if (isolinesGroupNum > 0) {
            // We have some isoline groups to delete - how many?
            if (isolinesGroupNum == 1) {
                // Only one, so delete it automatically - no need to change the state of this._deleteMode
                this.isolinesGroup.clearLayers();
                this.isolinesGroup.removeFrom(this._map);

                // Inform that an isoline FeatureGroup has been deleted
                this._map.fire('reachability:delete');
            }
            else {
                // We have more than one so the user will need to choose which to delete. Therefore set the control in delete mode and wait for the user event
                this._deleteMode = true;
                L.DomUtil.addClass(this._deleteControl, this.options.activeStyleClass);   // add the selected class to the delete button

                // Fire event to inform that the control delete mode has been activated
                this._map.fire('reachability:delete_activated');
            }
        }
        else {
            // There are no isoline groups to delete so warn the user by flashing the button
            this._showError(this._deleteControl);
        }
    },

    _deactivateDelete: function () {
        this._deleteMode = false;
        L.DomUtil.removeClass(this._deleteControl, this.options.activeStyleClass); // remove the selected class from the delete button

        // If collapsed == true, remove the active class from the collapsed control
        if (L.DomUtil.hasClass(this._container, this.options.activeStyleClass)) L.DomUtil.removeClass(this._container, this.options.activeStyleClass);

        // Fire event to inform that the control delete mode has been deactivated
        this._map.fire('reachability:delete_deactivated');
    },

    // Removes a particular 'set' or group of isolines (i.e. either a single isoline or an interval group of isolines) from the isolinesGroup object.
    // Called when an isoline group is clicked on whilst the plugin is in delete mode.
    _delete: function (e) {
        var parent = e.sourceTarget._eventParents;

        for (var key in parent) {
            if (parent.hasOwnProperty(key) && key != '<prototype>') parent[key].removeFrom(this.isolinesGroup);
        }

        // Deactivate the delete control and remove the isolines group from the map if there are no more isoline groups left
        if (this.isolinesGroup.getLayers().length == 0) {
            this._deactivateDelete();
            this.isolinesGroup.removeFrom(this._map);
        }

        // Inform that an isoline FeatureGroup has been deleted
        this._map.fire('reachability:delete');
    },

    // Show a visible error to the user if something has gone wrong
    _showError: function (control) {
        var css = this.options.errorStyleClass;

        // Add the error class to the control
        L.DomUtil.addClass(control, css);

        // Remove the error class from the control after 0.5 seconds
        setTimeout(function () {
            L.DomUtil.removeClass(control, css);
        }, 500);
    },

    // Toggle the UI buttons for distance and time like radio buttons
    _setRangeByDistance: function () {
        if (this._rangeIsDistance == false) {
            // The mode buttons
            L.DomUtil.addClass(this._distanceControl, this.options.activeStyleClass);
            L.DomUtil.removeClass(this._timeControl, this.options.activeStyleClass);

            // The range titles
            L.DomUtil.removeClass(this._rangeDistanceTitle, 'reachability-control-hide-content');
            L.DomUtil.addClass(this._rangeTimeTitle, 'reachability-control-hide-content');

            // The range lists
            L.DomUtil.removeClass(this._rangeDistanceList, 'reachability-control-hide-content');
            L.DomUtil.addClass(this._rangeTimeList, 'reachability-control-hide-content');

            this._rangeIsDistance = true;
        }
    },

    _setRangeByTime: function () {
        if (this._rangeIsDistance) {
            // The mode buttons
            L.DomUtil.addClass(this._timeControl, this.options.activeStyleClass);
            L.DomUtil.removeClass(this._distanceControl, this.options.activeStyleClass);

            // The range titles
            L.DomUtil.removeClass(this._rangeTimeTitle, 'reachability-control-hide-content');
            L.DomUtil.addClass(this._rangeDistanceTitle, 'reachability-control-hide-content');

            // The range lists
            L.DomUtil.removeClass(this._rangeTimeList, 'reachability-control-hide-content');
            L.DomUtil.addClass(this._rangeDistanceList, 'reachability-control-hide-content');

            this._rangeIsDistance = false;
        }
    },

    // Toggle the UI buttons for the modes of travel
    _setTravelMode1: function () {
        this._toggleTravelMode(this.options.travelModeProfile1);
    },

    _setTravelMode2: function () {
        this._toggleTravelMode(this.options.travelModeProfile2);
    },

    _setTravelMode3: function () {
        this._toggleTravelMode(this.options.travelModeProfile3);
    },

    _setTravelMode4: function () {
        this._toggleTravelMode(this.options.travelModeProfile4);
    },

    _toggleTravelMode: function (mode) {
        // This function is called first to set the default active travel mode and then from then on when the user selects the different modes
        var def_mode = (mode == null) ? this._travelMode : mode;

        if (this._travelMode != mode) {
            switch (def_mode) {
                case this.options.travelModeProfile2:
                    L.DomUtil.removeClass(this._travelMode1Control, this.options.activeStyleClass);
                    L.DomUtil.addClass(this._travelMode2Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode3Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode4Control, this.options.activeStyleClass);
                    break;
                case this.options.travelModeProfile3:
                    L.DomUtil.removeClass(this._travelMode1Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode2Control, this.options.activeStyleClass);
                    L.DomUtil.addClass(this._travelMode3Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode4Control, this.options.activeStyleClass);
                    break;
                case this.options.travelModeProfile4:
                    L.DomUtil.removeClass(this._travelMode1Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode2Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode3Control, this.options.activeStyleClass);
                    L.DomUtil.addClass(this._travelMode4Control, this.options.activeStyleClass);
                    break;
                default:
                    L.DomUtil.addClass(this._travelMode1Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode2Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode3Control, this.options.activeStyleClass);
                    L.DomUtil.removeClass(this._travelMode4Control, this.options.activeStyleClass);
            }

            this._travelMode = def_mode;
        }
    },

    // Deals with updating the position of the invisible Leaflet marker that chases the mouse pointer or is set to the location of a touch.
    // This is used to determine the coordinates on the map when the user clicks/touches to create an isoline group
    _updatePointerMarkerPosition: function (e) {
		var newPos = this._map.mouseEventToLayerPoint(e.originalEvent);
		var latlng = this._map.layerPointToLatLng(newPos);

        // Update the mouse marker position
		this._mouseMarker.setLatLng(latlng);

        // In case the mousedown event is being listened to on other objects
        L.DomEvent.stop(e.originalEvent);
	},

    // Prevents multiple events, e.g. click on the mouse marker and map all calling the API and creating duplicate isoline groups.
    _registerDrawRequest: function (e) {
        L.DomEvent.stop(e.originalEvent);     // stop any default actions and propagation from the event

        // Only take action if this is the first event to register - the reset is in _callApi
        if (!this._drawRequestRegistered) {
            this._drawRequestRegistered = true;

            this._callApi(e.latlng);
        }
    },

    // Handles the logging of information to the console, firing of events to inform about the error and handling the UI to reflect that an error occurred
    _handleError: function (obj) {
        // Output response to console if possible
        if (window.console && window.console.log) {
            if (obj.message != null) window.console.log(obj.message);
            if (obj.requestResult != null) {
                window.console.log('Status:', obj.requestResult.status);
                window.console.log('Headers:', obj.requestResult.getAllResponseHeaders());
                window.console.log(obj.requestResult.response);
            }
        }

        // Fire events
        if (obj.events != null && obj.events.length > 0) {
            for (var i = 0; i < obj.events.length; i++) {
                obj.context._map.fire('reachability:' + obj.events[i]);
            }
        }

        // Inform the user that something went wrong and deactivate the draw control
        obj.context._showError(obj.context._drawControl);
        obj.context._deactivateDraw();
    },

    // Main function to make the actual call to the API and display the resultant isoline group on the map
    _callApi: function (latLng) {
        // Store the context for use within the API callback
        var context = this;

        if (window.XMLHttpRequest) {
            // Start setting up the body of the request which contains most of the parameters
            var requestBody = '{"locations":[[' + latLng.lng + ',' + latLng.lat + ']],"attributes":[' + this.options.attributes + '],"smoothing":' + this.options.smoothing + ',';

            // The next part of the request body depends on the options and values selected by the user
            var arrRange = [];      // the array to hold either the single range value or multiple values if the intervals have been requested
            var optionsIndex = 0;   // index of the range collection

            if (this._rangeIsDistance) {
                if (this._showInterval.checked) {
                    do {
                        arrRange.push(this._rangeDistanceList[optionsIndex].value);
                        optionsIndex++;
                    }
                    while (optionsIndex <= this._rangeDistanceList.selectedIndex);
                }
                else {
                    arrRange.push(this._rangeDistanceList.value);
                }

                requestBody += '"range_type":"distance","units":"' + this.options.rangeControlDistanceUnits + '"';
            }
            else {
                if (this._showInterval.checked) {
                    do {
                        arrRange.push(this._rangeTimeList[optionsIndex].value * 60);
                        optionsIndex++;
                    }
                    while (optionsIndex <= this._rangeTimeList.selectedIndex);
                }
                else {
                    arrRange.push(this._rangeTimeList.value * 60);
                }

                requestBody += '"range_type":"time"';
            }

            // The area units are the same no matter whether based on distance or time, and add the range to finished the request body
            requestBody += ',"area_units":"' + this.options.rangeControlDistanceUnits + '","range":[' + arrRange.toString() + ']}';

            // Setup the request object and associated items
            var request = new XMLHttpRequest();

            request.open('POST', 'https://api.openrouteservice.org/v2/isochrones/' + this._travelMode);

            request.setRequestHeader('Content-Type', 'application/geo+json; charset=utf-8');
            request.setRequestHeader('Authorization', this.options.apiKey);

            // Setup the callback function to deal with the response from the API
            request.onreadystatechange = function () {
                try {
                    // Wait until the operation has completed, either successfully or failed
                    if (this.readyState === 4) {
                        // Decide what to do based on the response status
                        if (this.status === 200) {
                            // We have a successful response.
                            var data = JSON.parse(this.responseText);

                            // Now check if the response contains GeoJSON layers etc.
                            if (data.hasOwnProperty('features')) {
                                data.features.reverse();    // reverse the order of the features array

                                /*
                                    Reformat the data in the properties object to be more readable and informative

                                    Returned values from API:
                                        area:           the area of the isochrone, based on square units of the chosen distance unit
                                        value:          either metres or seconds depending if based on distance or time. Seems to ignore the distance unit
                                        total_pop:      integer value of people living in the area as given by Global Human Settlement (GHS) framework
                                        reachfactor:    value between 0 and 1 representing the ratio of the area of an isochrone to the theoretical area based on ecludian distance
                                */
                                for (var i = 0; i < data.features.length; i++) {

                                    var props = data.features[i].properties;    // get the properties for the current feature
                                    var range = props.value,
                                        rangeType,
                                        rangeUnits,
                                        rangeControlDistanceUnits = (context.options.rangeControlDistanceUnits == 'mi') ? 'miles' : context.options.rangeControlDistanceUnits;

                                    if (context._rangeIsDistance) {
                                        rangeType = 'distance';
                                        rangeUnits = rangeControlDistanceUnits;

                                        // Sort out the range in correct units. As the isochrone is based on distance the value will be in metres.
                                        // If our range units are in miles or km then we need to convert value to match.
                                        if (rangeControlDistanceUnits == 'miles') {
                                            range = range/1609.34;   // convert metres to miles for the range
                                        }
                                        else if (rangeControlDistanceUnits == 'km') {
                                            range = range/1000;      // convert metres to kilometres for the range
                                        }
                                    }
                                    else {
                                        rangeType = 'time';
                                        rangeUnits = 'min';
                                        range = range/60;            // convert seconds to minutes
                                    }

                                    var newProps = {
                                        'Travel mode': context._travelMode,
                                        'Measure': rangeType,
                                        'Range': L.Util.formatNum(range, 2),
                                        'Range units': rangeUnits,
                                        'Latitude': props.center[1],
                                        'Longitude': props.center[0]
                                    }

                                    if (props.hasOwnProperty('area')) {
                                        newProps['Area'] = L.Util.formatNum(props.area, 2);
                                        newProps['Area units'] = rangeControlDistanceUnits + '^2';
                                    }

                                    if (props.hasOwnProperty('total_pop')) newProps['Population'] = props.total_pop;
                                    if (props.hasOwnProperty('reachfactor')) newProps['Reach factor'] = props.reachfactor;

                                    // Replace the old properties object with the new one
                                    data.features[i].properties = newProps;
                                }

                                // Create a Leaflet GeoJSON FeatureGroup object from the GeoJSON returned from the API - This is intended to be accessible externally if required
                                context.latestIsolines = L.geoJSON(data, {
                                  style: context.options.styleFn,
                                  pane: context.options.pane
                                });

                                context.latestIsolines.eachLayer(function (layer) {
                                    // Iterate through each layer adding events if applicable
                                    layer.on({
                                        mouseover: (function (e) { if (context.options.mouseOverFn != null) context.options.mouseOverFn(e) }),
                                        mouseout: (function (e) { if (context.options.mouseOutFn != null) context.options.mouseOutFn(e) }),
                                        click: (function(e) {
                                            if (context._deleteMode) {
                                                // If we're in delete mode, call the delete function
                                                L.DomEvent.stopPropagation(e);
                                                context._delete(e);
                                            }
                                            else {
                                                // Otherwise, if there is a user-defined click function, call that instead
                                                if (context.options.clickFn != null) context.options.clickFn(e);
                                            }
                                        })
                                    });
                                });

                                // Create a marker at the latlng if desired. Can be used to indicate the mode of travel etc.
                                if (context.options.showOriginMarker) {
                                    var originMarker;

                                    if (context.options.markerFn != null) {
                                        // Expecting a custom Leaflet marker to be returned for the origin of the isolines group.
                                        // Passing the relevant factors to the function so that styling can be based on mode of travel, distance or time etc.
                                        originMarker = context.options.markerFn(latLng, context._travelMode, rangeType);
                                    }
                                    else {
                                        // Create a default marker for the origin of the isolines group
                                        originMarker = L.circleMarker(latLng, { radius: 3, weight: 0, fillColor: '#0073d4', fillOpacity: 1 });
                                    }

                                    // Attach events if required
                                    originMarker.on({
                                        mouseover: (function (e) { if (context.options.markerOverFn != null) context.options.markerOverFn(e) }),
                                        mouseout: (function (e) { if (context.options.markerOutFn != null) context.options.markerOutFn(e) }),
                                        click: (function(e) {
                                            if (context._deleteMode) {
                                                // If we're in delete mode, call the delete function
                                                L.DomEvent.stopPropagation(e);
                                                context._delete(e);
                                            }
                                            else {
                                                // Otherwise, if there is a user-defined click function, call that instead
                                                if (context.options.markerClickFn != null) context.options.markerClickFn(e);
                                            }
                                        })
                                    });

                                    // Add the marker to the isolines GeoJSON
                                    originMarker.addTo(context.latestIsolines);
                                }

                                // Add the newly created isolines GeoJSON to the overall GeoJSON FeatureGroup
                                context.latestIsolines.addTo(context.isolinesGroup);

                                // Add the isolines GeoJSON FeatureGroup to the map if it isn't already
                                if (!context._map.hasLayer(context.isolinesGroup)) context.isolinesGroup.addTo(context._map);

                                // Fire event to inform that isolines have been drawn successfully
                                context._map.fire('reachability:displayed');
                            }
                            else {
                                // API returned data but no GeoJSON layers
                                context.latestIsolines = null;

                                context._handleError({
                                    message: 'Leaflet.reachability.js: API returned data but no GeoJSON layers. Details of response received below:',
                                    requestResult: this,
                                    context: context,
                                    events: ['no_data']
                                });
                            }
                        }
                        else {
                            // Request failed for some reason
                            context._handleError({
                                message: 'Leaflet.reachability.js error calling API, response was not successful. Details of response received below:',
                                requestResult: this,
                                context: context,
                                events: ['error','no_data']
                            });
                        }

                        // Whether successful or not, inform that we have completed calling the API - could be useful for stopping a spinner etc. to indicate to the user that something was happening.
                        context._map.fire('reachability:api_call_end');

                        // Get ready to register another draw request
                        context._drawRequestRegistered = false;
                    }
                }
                catch(e) {
                    // Unexpected error
                    context._handleError({
                        message: 'Leaflet.reachability.js unexpected error attempting to call API. Details of the error below.\n' + e,
                        requestResult: null,
                        context: context,
                        events: ['error','no_data','api_call_end']
                    });
                }
            };

            // Inform that we are calling the API - could be useful for starting a spinner etc. to indicate to the user that something is happening if there is a delay
            this._map.fire('reachability:api_call_start');

            // Make the call to the API
            request.send(requestBody);
        }
        else {
            // Browser is not capable of making the request so handle the error
            this._handleError({
                message: 'Leaflet.reachability.js error. Browser does not support XMLHttpRequest so is not capable of making the request to the API.',
                requestResult: null,
                context: this,
                events: ['error','no_data']
            });
        }
    }
});

L.control.reachability = function (options) {
    return new L.Control.Reachability(options);
};
