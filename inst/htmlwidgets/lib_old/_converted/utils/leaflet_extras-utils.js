LeafletWidget.methods.setMapWidgetStyle = function(style) {
  var widget = this;
  if($.isEmptyObject(widget._container.style)) {
    widget._container.style = {};
  }
  $.each(style, function(key, value) {
    widget._container.style[key] = value;
  });
};

