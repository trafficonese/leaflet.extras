# Leaflet layer control with support for grouping overlays together.

Also supports making groups exclusive (using radio inputs instead of
checkbox). See the JavaScript plugin for more information
<https://github.com/trafficonese/leaflet-groupedlayercontrol/>

## Usage

``` r
addGroupedLayersControl(
  map,
  baseGroups = character(0),
  overlayGroups = character(0),
  position = c("topright", "bottomright", "bottomleft", "topleft"),
  options = groupedLayersControlOptions()
)
```

## Arguments

- map:

  the map to add the layers control to

- baseGroups:

  character vector where each element is the name of a group. The user
  will be able to choose one base group (only) at a time. This is most
  commonly used for mostly-opaque tile layers.

- overlayGroups:

  A list of named vectors where each element is the name of a group.

- position:

  position of control: "topleft", "topright", "bottomleft", or
  "bottomright"

- options:

  a list of additional options, intended to be provided by a call to
  [`groupedLayersControlOptions`](https://trafficonese.github.io/leaflet.extras/reference/groupedLayersControlOptions.md)

## See also

Other GroupedLayersControl:
[`addGroupedOverlay()`](https://trafficonese.github.io/leaflet.extras/reference/GroupedLayersControl.md),
[`groupedLayersControlOptions()`](https://trafficonese.github.io/leaflet.extras/reference/groupedLayersControlOptions.md)

## Examples

``` r
library(leaflet)
library(leaflet.extras)

leaflet() %>%
  addTiles(group = "OpenStreetMap") %>%
  addProviderTiles("CartoDB", group = "CartoDB") %>%
  addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
    color = "red", group = "Markers2"
  ) %>%
  addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
    color = "green", group = "Markers1"
  ) %>%
  addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
    color = "yellow", group = "Markers3"
  ) %>%
  addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
    color = "lightblue", group = "Markers4"
  ) %>%
  addCircleMarkers(runif(20, -75, -74), runif(20, 41, 42),
    color = "purple", group = "Markers5"
  ) %>%
  addGroupedLayersControl(
    baseGroups = c("OpenStreetMap", "CartoDB"),
    overlayGroups = list(
      "Layergroup_2" = c("Markers5", "Markers4"),
      "Layergroup_1" = c("Markers2", "Markers1", "Markers3")
    ),
    position = "topright",
    options = groupedLayersControlOptions(
      groupCheckboxes = TRUE,
      collapsed = FALSE,
      groupsCollapsable = TRUE,
      sortLayers = FALSE,
      sortGroups = FALSE,
      sortBaseLayers = FALSE,
      exclusiveGroups = "Layergroup_1"
    )
  )

{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,"OpenStreetMap",{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"https://openstreetmap.org/copyright/\">OpenStreetMap<\/a>,  <a href=\"https://opendatacommons.org/licenses/odbl/\">ODbL<\/a>"}]},{"method":"addProviderTiles","args":["CartoDB",null,"CartoDB",{"errorTileUrl":"","noWrap":false,"detectRetina":false}]},{"method":"addCircleMarkers","args":[[41.28989229537547,41.67838042741641,41.73531959881075,41.19595673307776,41.98053967463784,41.74152152915485,41.05144627625123,41.53021246357821,41.69582387898117,41.68855600338429,41.03123032534495,41.22556253452785,41.30083080613986,41.63646561489441,41.47902454971336,41.43217125814408,41.70643383776769,41.94857657630928,41.18033876805566,41.21689987648278],[-74.91924986243248,-74.16566696274094,-74.39923911378719,-74.84279155847616,-74.99260055879131,-74.53360650269315,-74.50222261133604,-74.7102327554021,-74.26711801299825,-74.22747848881409,-74.12539933924563,-74.82505937316455,-74.96575866732746,-74.67961426917464,-74.59767176164314,-74.80433016526513,-74.59646188258193,-74.93633854272775,-74.61129868682474,-74.02445216476917],10,null,"Markers2",{"interactive":true,"className":"","stroke":true,"color":"red","weight":5,"opacity":0.5,"fill":true,"fillColor":"red","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[41.82519942102954,41.2738182451576,41.57004495104775,41.33571908064187,41.59626278886572,41.19151803152636,41.94776393775828,41.54248040867969,41.54460339341313,41.27859715395607,41.44670246914029,41.3715111843776,41.0280609743204,41.46598719083704,41.39003138733096,41.02006521774456,41.37697092769668,41.55991283990443,41.85708358604461,41.38480971101671],[-74.31983708241023,-74.50115438946523,-74.35832065157592,-74.33971565077081,-74.9039758418221,-74.23439983604476,-74.23032519570552,-74.00928768771701,-74.02947909710929,-74.61081723938696,-74.53881353535689,-74.68475824757479,-74.82532410603017,-74.46842645923607,-74.50636298395693,-74.22069137403741,-74.79582165717147,-74.28660272108391,-74.93478388828225,-74.645793201169],10,null,"Markers1",{"interactive":true,"className":"","stroke":true,"color":"green","weight":5,"opacity":0.5,"fill":true,"fillColor":"green","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[41.80568003072403,41.81405131006613,41.4039110019803,41.21843100874685,41.41836140234955,41.66887074778788,41.50765028200112,41.66035930649377,41.51179131376557,41.83555243699811,41.70878116134554,41.87420594086871,41.01147953793406,41.88824956794269,41.99634691886604,41.5001915008761,41.3589670243673,41.77491302229464,41.58447525091469,41.63397637102753],[-74.47208296437748,-74.39936247630976,-74.73862864170223,-74.70994983846322,-74.51992482598871,-74.07999445381574,-74.5992798153311,-74.78682728880085,-74.32823318429291,-74.94138588896021,-74.00293086469173,-74.85096453269944,-74.481443364406,-74.15387994539924,-74.28173027583398,-74.75868597999215,-74.45295663154684,-74.16519818478264,-74.97204397455789,-74.53061570017599],10,null,"Markers3",{"interactive":true,"className":"","stroke":true,"color":"yellow","weight":5,"opacity":0.5,"fill":true,"fillColor":"yellow","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[41.07068121922202,41.99689147341996,41.61185241746716,41.17255884571932,41.90944096515886,41.03745116689242,41.59355379035696,41.23697755485773,41.90629726671614,41.81887298403308,41.69982935721055,41.22000032919459,41.72799093835056,41.21708446228877,41.45623019826598,41.33279975829646,41.56835266854614,41.25220572482795,41.46401356672868,41.91766050690785],[-74.14133384521119,-74.43310566130094,-74.74700298067182,-74.08119678543881,-74.13264979515225,-74.7514613030944,-74.59711878816597,-74.2303698239848,-74.88051462545991,-74.80530503834598,-74.8354307517875,-74.33679341874085,-74.14342499547638,-74.07345355162397,-74.44762240536511,-74.42293430562131,-74.31255225441419,-74.75528177036904,-74.95538284163922,-74.09014544333331],10,null,"Markers4",{"interactive":true,"className":"","stroke":true,"color":"lightblue","weight":5,"opacity":0.5,"fill":true,"fillColor":"lightblue","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addCircleMarkers","args":[[41.66428549285047,41.08522470016032,41.85613215668127,41.07698332169093,41.85284480336122,41.106346960878,41.48480282351375,41.24721911037341,41.68656921060756,41.16362319816835,41.9528247998096,41.32185455108993,41.3615341167897,41.887723417487,41.82801441778429,41.10065645771101,41.90605157776736,41.77273036446422,41.38337067048997,41.99965245719068],[-74.02715578209609,-74.18091755337082,-74.09707620181143,-74.41863395599648,-74.22699151886627,-74.00487697357312,-74.28902875026688,-74.78505740431137,-74.70824237004854,-74.27824027067982,-74.13338429667056,-74.76154689351097,-74.9955036919564,-74.05648353579454,-74.56186279957183,-74.24939667177387,-74.33218423556536,-74.59202679852024,-74.64875118504278,-74.26190843852237],10,null,"Markers5",{"interactive":true,"className":"","stroke":true,"color":"purple","weight":5,"opacity":0.5,"fill":true,"fillColor":"purple","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addGroupedLayersControl","args":[["OpenStreetMap","CartoDB"],{"Layergroup_2":{"Markers5":"Markers5","Markers4":"Markers4"},"Layergroup_1":{"Markers2":"Markers2","Markers1":"Markers1","Markers3":"Markers3"}},{"exclusiveGroups":"Layergroup_1","groupCheckboxes":true,"groupsCollapsable":true,"groupsCollapsed":true,"groupsExpandedClass":"leaflet-control-layers-group-collapse-default","groupsCollapsedClass":"leaflet-control-layers-group-expand-default","sortLayers":false,"sortGroups":false,"sortBaseLayers":false,"collapsed":false,"autoZIndex":true,"position":"topright"}]}],"limits":{"lat":[41.01147953793406,41.99965245719068],"lng":[-74.9955036919564,-74.00293086469173]}},"evals":[],"jsHooks":[]}
```
