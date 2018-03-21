library(leaflet.extras)

leaflet() %>%
  addTiles() %>%
  addWeatherMarkers(
    lng = -118.456554, lat = 34.078039,
    label = "This is a label",
    icon = makeWeatherIcon(icon = "hot", iconColor = "#ffffff77",
                           markerColor = "blue" ))

cities <- read.csv(
  textConnection("
    City,Lat,Long,Pop
    Boston,42.3601,-71.0589,645966
    Hartford,41.7627,-72.6743,125017
    New York City,40.7127,-74.0059,8406000
    Philadelphia,39.9500,-75.1667,1553000
    Pittsburgh,40.4397,-79.9764,305841
    Providence,41.8236,-71.4222,177994"))

# Translate darksky API icons to Weather Icons
iconMap = list(
  "clear-day" = "day-sunny",
  "clear-night" = "night-clear",
  "rain" = "rain",
  "snow" = "snow",
  "sleet" = "sleet",
  "wind" = "windy",
  "fog" = "fog",
  "cloudy" = "cloudy",
  "partly-cloudy-day" = "day-cloudy",
  "partly-cloudy-night" = "night-alt-cloudy"
)


cities_forecast <- purrr::map2(
  cities$Lat, cities$Long,
  function(lat, long) {
    darksky::get_current_forecast(lat, long)
  }
)

cities_icons <- weatherIcons(
  icon = as.character(iconMap[purrr::map_chr(cities_forecast, ~ .$currently$icon)]),
  markerColor = purrr::map_chr(
    cities_forecast,
    function(forecast){
      temp <- forecast$currently$temperature
      if (temp < 60) {
        "lightblue"
      } else if (temp >= 60 && temp < 65) {
        "orange"
      } else {
        "red"
      }
    })
)

cities_popups <- purrr::map(
  cities_forecast,
  function(forecast) {
    df <- forecast$currently
    colnames(df) <- tools::toTitleCase(stringr::str_replace_all(
      colnames(df), "([A-Z])", " \\1"))
    htmlTable::htmlTable(
      t(df),
      caption = "Current Forecast",
      align = "left",
      header = c("Value"),
      rowlabel = "Variable",
      align.header = "left",
      col.rgroup = c("#ffffff", "#eeeeee"))
  })

leaflet(cities) %>% addProviderTiles(providers$CartoDB.Positron) %>%
  addWeatherMarkers(lng = ~Long, lat = ~Lat,
                    label = ~City,
                    icon = cities_icons,
                    popup = cities_popups)
