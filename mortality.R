library(sf)
library(leaflet)
library(htmltools)

# Read the joined GeoJSON file
cu_data <- st_read("/Users/jakecox/rstudio/cu-geo/cu_with_mortality.json", quiet = TRUE)

# Create color palette for life expectancy
pal_life_exp <- colorNumeric(
  palette = "RdYlGn",  # Red-Yellow-Green (red=low, green=high)
  domain = cu_data$Life_Expectancy_2010_2015[!is.na(cu_data$Life_Expectancy_2010_2015)],
  na.color = "grey"
)

# Create leaflet map
leaflet(cu_data) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(
    fillColor = ~pal_life_exp(Life_Expectancy_2010_2015),
    weight = 1,
    opacity = 1,
    color = "white",
    fillOpacity = 0.7,
    highlightOptions = highlightOptions(
      weight = 2,
      color = "#666",
      fillOpacity = 0.9,
      bringToFront = TRUE
    ),
    label = ~paste0(
      "Tract: ", NAMELSAD, "<br>",
      "Life Expectancy: ", round(Life_Expectancy_2010_2015, 1), " years<br>",
      "Population: ", format(Population, big.mark = ",")
    ) %>% lapply(HTML)
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal_life_exp,
    values = ~Life_Expectancy_2010_2015,
    title = "Life Expectancy<br>(years, 2010-2015)",
    opacity = 0.7,
    na.label = "No data"
  )
