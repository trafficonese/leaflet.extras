/* global LeafletWidget, $, L */

import { unpackStrings } from './utils.js';


LeafletWidget.methods.addBounceMarkers = function(lat, lng, icon, layerId,
  duration, height, group, options, popup, popupOptions, clusterOptions,
  clusterId, label, labelOptions) {

  (function() {

    let icondf;
    let getIcon;

    if (icon) {
      // Unpack icons
      icon.iconUrl = unpackStrings(icon.iconUrl);
      icon.iconRetinaUrl = unpackStrings(icon.iconRetinaUrl);
      icon.shadowUrl = unpackStrings(icon.shadowUrl);
      icon.shadowRetinaUrl = unpackStrings(icon.shadowRetinaUrl);

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
