# Load packages
library(sf)
library(leaflet)
library(dplyr)

# Read the fixed GeoJSON file
cu_geo <- st_read("/Users/jakecox/rstudio/cu-geo/cu-tracts-fixed.json")

# Read the CSV file
cu_poverty <- read.csv("/Users/jakecox/rstudio/cu-geo/cu-poverty_revised.csv")

# Check the data
print("CSV columns:")
print(names(cu_poverty))
print(head(cu_poverty))

print("GeoJSON NAMELSAD:")
print(head(cu_geo$NAMELSAD))

# Join the data by NAMELSAD
cu_data <- cu_geo %>%
  left_join(cu_poverty, by = "NAMELSAD")

print(paste("Rows with poverty data:", sum(!is.na(cu_data$Poverty.Rate))))

# Create color palette for poverty rate (using only non-NA values)
pal <- colorNumeric(
  palette = "YlOrRd",
  domain = cu_data$Poverty.Rate[!is.na(cu_data$Poverty.Rate)],
  na.color = "grey"
)

# Create leaflet map
leaflet(cu_data) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(
    fillColor = ~pal(Poverty.Rate),
    weight = 1,
    opacity = 1,
    color = "white",
    fillOpacity = 0.7,
    highlightOptions = highlightOptions(
      weight = 2,
      color = "#666",
      fillOpacity = 0.9
    ),
    label = ~paste0("Tract: ", NAMELSAD, "<br>Poverty Rate: ",
                    round(Poverty.Rate, 1), "%") %>%
      lapply(htmltools::HTML)
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = ~Poverty.Rate,
    title = "Poverty Rate (%)",
    opacity = 0.7,
    na.label = "No data"
  )
