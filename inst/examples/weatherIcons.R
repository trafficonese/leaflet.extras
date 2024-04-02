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

# Translate OpenWeather API icons to Weather Icons
iconMap = list(
  "Clear" = "day-sunny",
  "Rain" = "rain",
  "Snow" = "snow",
  "Sleet" = "sleet",
  "Wind" = "windy",
  "Fog" = "fog",
  "Clouds" = "cloudy"
)


## Requires an OWM_API_KEY - https://openweathermap.org/
cities_forecast <- lapply(cities$City, function(ct) {
  df <- owmr::get_current(ct, units = "metric")
  cbind(df$weather, df$main, df$wind, df$clouds)
})
cities_forecast <- cities_forecast[lengths(cities_forecast) != 0]
cities_forecast <- data.table::rbindlist(cities_forecast, fill=TRUE)

map_temp_to_color <- function(temp) {
  if (temp < 10) {
    "lightblue"
  } else if (temp >= 60 && temp < 65) {
    "orange"
  } else {
    "red"
  }
}
cities_icons <- weatherIcons(
  icon = as.character(iconMap[cities_forecast$main]),
  markerColor = sapply(cities_forecast$temp, map_temp_to_color)
)

leaflet(cities) %>% addProviderTiles(providers$CartoDB.Positron) %>%
  addWeatherMarkers(lng = ~Long, lat = ~Lat,
                    label = ~City,
                    # popup = cities_popups,
                    icon = cities_icons
                    )
