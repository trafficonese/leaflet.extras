LeafletWidget.methods.addGeoJSONChoropleth = function(
  data, layerId, group,
  labelProperty, labelOptions, popupProperty, popupOptions,
  pathOptions, highlightOptions
) {
    LeafletWidget.methods.addgenericGeoJSON(
      this,
      function getData(){return data;},
      function getGeoJSONLayer(data, geoJsonOptions){
        return L.choropleth(data, $.extend(
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
