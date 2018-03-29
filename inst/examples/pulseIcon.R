library(leaflet.extras)

leaf <- leaflet() %>% addTiles()

leaf %>%
  addPulseMarkers(
    lng = -118.456554, lat = 34.078039,
    label = "This is a label",
    icon = makePulseIcon(heartbeat = 0.5))

cities <- read.csv(textConnection("
City,Lat,Long,Pop
                                  Boston,42.3601,-71.0589,645966
                                  Hartford,41.7627,-72.6743,125017
                                  New York City,40.7127,-74.0059,8406000
                                  Philadelphia,39.9500,-75.1667,1553000
                                  Pittsburgh,40.4397,-79.9764,305841
                                  Providence,41.8236,-71.4222,177994"))

library(dplyr)
cities <- cities %>% mutate(PopCat = ifelse(Pop < 500000, "blue", "red"))

leaflet(cities) %>% addTiles() %>%
  addPulseMarkers(lng = ~Long, lat = ~Lat,
                    label = ~City,
                    icon = makePulseIcon())

icon.pop <- pulseIcons(color = ifelse(cities$Pop < 500000, "blue", "red"),
                       heartbeat = ifelse(cities$Pop < 500000, "0.8", "0.4"))

leaflet(cities) %>% addTiles() %>%
  addPulseMarkers(lng = ~Long, lat = ~Lat,
                    label = ~City,
                    icon = icon.pop)

# Make a list of icons (from two different icon libraries).
# We'll index into it based on name.
popIcons <- pulseIconList(
  blue = makePulseIcon(color = "blue"),
  red = makePulseIcon(color = "red")
)

leaflet(cities) %>% addTiles() %>%
  addPulseMarkers(lng = ~Long, lat = ~Lat,
                    label = ~City,
                    labelOptions = rep(labelOptions(noHide = T), nrow(cities)),
                    icon = ~popIcons[PopCat] )
