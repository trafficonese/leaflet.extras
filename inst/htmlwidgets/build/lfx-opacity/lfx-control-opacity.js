/*
        Leaflet.OpacityControls, a plugin for adjusting the opacity of a Leaflet map.
        (c) 2013, Jared Dominguez
        (c) 2013, LizardTech

        https://github.com/lizardtechblog/Leaflet.OpacityControls
*/

//Declare global variables
var opacity_layer;

//Create a control to increase the opacity value. This makes the image more opaque.
L.Control.higherOpacity = L.Control.extend({
    options: {
        position: 'topright'
    },
    setOpacityLayer: function (layer) {
            opacity_layer = layer;
    },
    onAdd: function () {

        var higher_opacity_div = L.DomUtil.create('div', 'higher_opacity_control');

        L.DomEvent.addListener(higher_opacity_div, 'click', L.DomEvent.stopPropagation)
            .addListener(higher_opacity_div, 'click', L.DomEvent.preventDefault)
            .addListener(higher_opacity_div, 'click', function () { onClickHigherOpacity() });

        return higher_opacity_div;
    }
});

//Create a control to decrease the opacity value. This makes the image more transparent.
L.Control.lowerOpacity = L.Control.extend({
    options: {
        position: 'topright'
    },
    setOpacityLayer: function (layer) {
            opacity_layer = layer;
    },
    onAdd: function (map) {

        var lower_opacity_div = L.DomUtil.create('div', 'lower_opacity_control');

        L.DomEvent.addListener(lower_opacity_div, 'click', L.DomEvent.stopPropagation)
            .addListener(lower_opacity_div, 'click', L.DomEvent.preventDefault)
            .addListener(lower_opacity_div, 'click', function () { onClickLowerOpacity() });

        return lower_opacity_div;
    }
});

//Create a jquery-ui slider with values from 0 to 100. Match the opacity value to the slider value divided by 100.
L.Control.opacitySlider = L.Control.extend({
    options: {
        position: 'topright'
    },
    setOpacityLayer: function (layer) {
            opacity_layer = layer;
    },
    onAdd: function (map) {
        var opacity_slider_div = L.DomUtil.create('div', 'opacity_slider_control');
        // If an initial opacity is set, set slider to corresponding value
        var max = this.options.max ? this.options.max : 100;
        var value;
        if (this.options.init_opac) value = this.options.init_opac * max;
        $(opacity_slider_div).slider({
          //orientation: "vertical", // horizontal doesnt work correctly. Some CSS problem
          orientation: this.options.orientation ? this.options.orientation : "vertical",
          range: this.options.range ? this.options.range : "min",
          min: 0,
          max: max,
          value: value ? value : 60,
          step: max/5.5,
          animate: this.options.animate ? this.options.animate : "fast",
          start: function ( event, ui) {
            //When moving the slider, disable panning.
            map.dragging.disable();
            map.once('mousedown', function (e) {
              map.dragging.enable();
            });
          },
          slide: function ( event, ui ) {
            var slider_value = ui.value / max;
            opacity_layer.setOpacity(slider_value);
          }
        });

        return opacity_slider_div;
    }
});


function onClickHigherOpacity() {
    var opacity_value = opacity_layer.options.opacity;

    if (opacity_value >= 1) {
        return;
    } else {
        opacity_layer.setOpacity(opacity_value + 0.2);
        // Set slider value, if slider is available
        var slider = $(".opacity_slider_control");
        if (slider && slider.length) {
          var cur_val = slider.slider("value");
          var step = slider.slider("option").step;
          slider.slider("value", cur_val + step);
        }
        //When you double-click on the control, do not zoom.
        var map = opacity_layer._map; // This works. Otherwise the `map` doesnt have doubleClickZoom
        map.doubleClickZoom.disable();
        map.once('click', function (e) {
            map.doubleClickZoom.enable();
        });
    }

}

function onClickLowerOpacity() {
    var opacity_value = opacity_layer.options.opacity;

    if (opacity_value <= 0) {
        return;
    } else {
        opacity_layer.setOpacity(opacity_value - 0.2);
        // Set slider value, if slider is available
        var slider = $(".opacity_slider_control");
        if (slider && slider.length) {
          var cur_val = slider.slider("value");
          var step = slider.slider("option").step;
          slider.slider("value", cur_val - step);
        }
        //When you double-click on the control, do not zoom.
        var map = opacity_layer._map; // This works. Otherwise the `map` doesnt have doubleClickZoom
        map.doubleClickZoom.disable();
        map.once('click', function (e) {
            map.doubleClickZoom.enable();
        });
    }

}
