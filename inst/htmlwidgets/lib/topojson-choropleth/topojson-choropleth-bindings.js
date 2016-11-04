LeafletWidget.methods.addTopoJSONChoropleth = function(
  data, layerId, group,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions
) {
    LeafletWidget.methods.addgenericGeoJSON(
      this,
      function getData(){return data;},
      function getTopoJSONLayer(data, geoJsonOptions){
        return L.choroplethTopo(data, $.extend(
          pathOptions, geoJsonOptions));
      },
      layerId, group,
      false,
      null, null, null, null,
      null, null,
      labelProperty, labelOptions, popupProperty, popupOptions,
      pathOptions, highlightOptions
    );

};
