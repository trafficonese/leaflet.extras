
# Leaflet.Icon.Glyph

Allows you to put glyphs from icon fonts into your LeafletJS markers.

This is very similar to other LeafletJS plugins such as AwesomeMarkers or
MakiMarkers. The main difference is that Leaflet.Icon.Glyph does not need any
CSS to be set up, and should work with any bootstrap-style icon fonts.

This means hundreds of glyphs at your disposal.


## Demo

![Glyph icons demo](https://leaflet.github.io/Leaflet.Icon.Glyph/demo.png)

Live demo at [https://leaflet.github.io/Leaflet.Icon.Glyph/demo.html](https://leaflet.github.io/Leaflet.Icon.Glyph/demo.html)

The demo shows:
* Plain glyphs (iconless)
* <a href='https://materialdesignicons.com/'>Material design icons</a>
* <a href='http://getbootstrap.com/components/#glyphicons'>Glyphicons-halflings from Bootstrap</a>
* <a href='https://fortawesome.github.io/Font-Awesome/'>Font Awesome</a>
* <a href='http://metroui.org.ua/font.html'>Metro UI icon font</a>
* <a href='https://github.com/github/octicons'>Github's Octicons</a>
* <a href='https://github.com/iconic/open-iconic'>Iconic Open</a>
* <a href='https://github.com/mapshakers/mapkeyicons'>Mapkey Icons</a>


## Usage

Load the script (alongside whatever icon fonts you need):

```html
	<script type="text/javascript" src="Leaflet.Icon.Glyph.js"></script>
```

Then, if your icon glyphs look like this in HTML:
```html
<i class="mdi mdi-package"></i>
```

Instantiate the marker icons like this in your Javascript+Leaflet code:

```js
var marker = L.marker(latlng, {
	icon: L.icon.glyph({
		prefix: 'mdi',
		glyph: 'package'
	})
});
```

If you want to show a glyph from a "normal" font (e.g. an "A"), just set an empty prefix:

```js
var marker = L.marker(latlng, {
	icon: L.icon.glyph({
		prefix: '',
		glyph: 'A'
	})
});
```

The [demo page](https://leaflet.github.io/Leaflet.Icon.Glyph/demo.html) shows how to use a few different icon typefaces and plain glyphs, check it out for inspiration!

## Options

An instance of `L.Icon.Glyph` supports the options of `L.Icon`, plus:

```js

var icon = L.icon.glyph({

	className: '',
	// Akin to the 'className' option in L.DivIcon

	prefix: '',
	// CSS class to be used on all glyphs and prefixed to every glyph name

	glyph: '',
	// Name of the glyph

	glyphColor: 'white',
	// Glyph colour. Value can be any string with a CSS colour definition.

	glyphSize: '11px',
	// Size of the glyph, in CSS units

	glyphAnchor: [0, 7],
	// Position of the center of the glyph relative to the center of the icon.

	bgPos: [0, 0]
	// Akin to the 'bgPos' option in L.DivIcon. Use when using a sprite for the
	// icon image.

	bgSize: [800, 100]
	// Forces the size of the background image. Use when using a sprite for the
	// icon image in "retina" mode.
});
```


## Subclassing

If you're using a set of font icons extensively, or a custom icon image, it might
be easier to subclass `L.Icon.Glyph` into your own icon class:

```js
L.Icon.Glyph.MDI = L.Icon.Glyph.extend({
	options: {
		prefix: 'mdi',
		iconUrl: '/path/to/your/icon/image.png',
		iconSize: [30, 50]
	}
});

// Factory
L.icon.glyph.mdi = function(options) { return new L.Icon.Glyph.MDI(options); };

var marker = L.marker(latlng, {
	icon: L.icon.glyph.mdi({ glyph: 'package' })
});
```



## Legalese

----------------------------------------------------------------------------

"THE BEER-WARE LICENSE":
<ivan@sanchezortega.es> wrote this file. As long as you retain this notice you
can do whatever you want with this stuff. If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return.

----------------------------------------------------------------------------

