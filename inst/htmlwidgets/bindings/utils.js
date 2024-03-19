/* global $, L, HTMLWidgets, Shiny, map */

// from https://github.com/rstudio/leaflet/blob/dc772e780317481e25335449b957c5f50082bcfd/javascript/src/methods.js#L221
function asArray(value) {
  if (value instanceof Array)
    return value;
  else
    return [value];
}

export function unpackStrings(iconset) {
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

export function handleEvent(e, eventName, options, df, i, statistics, updateInfo) {
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
