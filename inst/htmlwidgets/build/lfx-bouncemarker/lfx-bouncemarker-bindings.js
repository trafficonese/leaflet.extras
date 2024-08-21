/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ "./inst/htmlwidgets/bindings/utils.js":
/*!********************************************!*\
  !*** ./inst/htmlwidgets/bindings/utils.js ***!
  \********************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   handleEvent: () => (/* binding */ handleEvent),
/* harmony export */   unpackStrings: () => (/* binding */ unpackStrings)
/* harmony export */ });
/* global $, L, HTMLWidgets, Shiny, map */

// from https://github.com/rstudio/leaflet/blob/dc772e780317481e25335449b957c5f50082bcfd/javascript/src/methods.js#L221
function asArray(value) {
  if (value instanceof Array)
    return value;
  else
    return [value];
}

function unpackStrings(iconset) {
  if (!iconset) {
    return iconset;
  }

  if (typeof(iconset.index) === 'undefined') {
    return iconset;
  }

  iconset.data = asArray(iconset.data);
  iconset.index = asArray(iconset.index);

  return $.map(iconset.index, function(e) {
    return iconset.data[e];
  });
}

function handleEvent(e, eventName, options, df, i, statistics, updateInfo) {
  if (options.showStats) {
    updateInfo(statistics);
  }

  var group = df.get(i, 'group');
  // Pass Events to Shiny
  if (HTMLWidgets.shinyMode) {
    let latLng = e.target.getLatLng
      ? e.target.getLatLng()
      : e.latlng;
    if (latLng) {
      const latLngVal = L.latLng(latLng);
      latLng = { lat: latLngVal.lat, lng: latLngVal.lng };
    }

    const eventInfo = $.extend({
      id: df.get(i, 'layerId'),
      '.nonce': Math.random()
    },
    group !== null
      ? { group: group }
      : null,
    latLng,
    statistics);
    Shiny.onInputChange(map.id + eventName, eventInfo);
  }
}


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/define property getters */
/******/ 	(() => {
/******/ 		// define getter functions for harmony exports
/******/ 		__webpack_require__.d = (exports, definition) => {
/******/ 			for(var key in definition) {
/******/ 				if(__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) {
/******/ 					Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	(() => {
/******/ 		__webpack_require__.o = (obj, prop) => (Object.prototype.hasOwnProperty.call(obj, prop))
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/make namespace object */
/******/ 	(() => {
/******/ 		// define __esModule on exports
/******/ 		__webpack_require__.r = (exports) => {
/******/ 			if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 				Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 			}
/******/ 			Object.defineProperty(exports, '__esModule', { value: true });
/******/ 		};
/******/ 	})();
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be isolated against other modules in the chunk.
(() => {
/*!****************************************************************!*\
  !*** ./inst/htmlwidgets/bindings/lfx-bouncemarker-bindings.js ***!
  \****************************************************************/
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _utils_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./utils.js */ "./inst/htmlwidgets/bindings/utils.js");
/* global LeafletWidget, $, L */




LeafletWidget.methods.addBounceMarkers = function(lat, lng, icon, layerId,
  duration, height, group, options, popup, popupOptions, clusterOptions,
  clusterId, label, labelOptions) {

  (function() {

    let icondf;
    let getIcon;

    if (icon) {
      // Unpack icons
      icon.iconUrl = (0,_utils_js__WEBPACK_IMPORTED_MODULE_0__.unpackStrings)(icon.iconUrl);
      icon.iconRetinaUrl = (0,_utils_js__WEBPACK_IMPORTED_MODULE_0__.unpackStrings)(icon.iconRetinaUrl);
      icon.shadowUrl = (0,_utils_js__WEBPACK_IMPORTED_MODULE_0__.unpackStrings)(icon.shadowUrl);
      icon.shadowRetinaUrl = (0,_utils_js__WEBPACK_IMPORTED_MODULE_0__.unpackStrings)(icon.shadowRetinaUrl);

      // This cbinds the icon URLs and any other icon options; they're all
      // present on the icon object.
      icondf = new LeafletWidget.DataFrame().cbind(icon);

      // Constructs an icon from a specified row of the icon dataframe.
      getIcon = function(i) {
        var opts = icondf.get(i);
        if (!opts.iconUrl) {
          return new L.Icon.Default();
        }

        // Composite options (like points or sizes) are passed from R with each
        // individual component as its own option. We need to combine them now
        // into their composite form.
        if (opts.iconWidth) {
          opts.iconSize = [opts.iconWidth, opts.iconHeight];
        }

        if (opts.shadowWidth) {
          opts.shadowSize = [opts.shadowWidth, opts.shadowHeight];
        }

        if (opts.iconAnchorX) {
          opts.iconAnchor = [opts.iconAnchorX, opts.iconAnchorY];
        }

        if (opts.shadowAnchorX) {
          opts.shadowAnchor = [opts.shadowAnchorX, opts.shadowAnchorY];
        }

        if (opts.popupAnchorX) {
          opts.popupAnchor = [opts.popupAnchorX, opts.popupAnchorY];
        }

        return new L.Icon(opts);
      };
    }

    if (!($.isEmptyObject(lat) || $.isEmptyObject(lng)) ||
      ($.isNumeric(lat) && $.isNumeric(lng))) {

      var df = new LeafletWidget.DataFrame()
        .col('lat', lat)
        .col('lng', lng)
        .col('layerId', layerId)
        .col('group', group)
        .col('popup', popup)
        .col('popupOptions', popupOptions)
        .col('label', label)
        .col('labelOptions', labelOptions)
        .cbind(options);

      if (icon) icondf.effectiveLength = df.nrow();

      LeafletWidget.methods.addGenericMarkers(this, df, group, clusterOptions, clusterId, function(df, i) {
        var options = df.get(i);
        if (icon) options.icon = getIcon(i);
        options.bounceOnAdd = true;
        options.bounceOnAddOptions = {
          duration: duration,
          height: height
        };
        return L.marker([df.get(i, 'lat'), df.get(i, 'lng')], options);
      });
    }

  }).call(this);

};

})();

/******/ })()
;