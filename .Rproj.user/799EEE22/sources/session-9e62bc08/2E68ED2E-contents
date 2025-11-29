# Load packages
library(sf)
library(leaflet)
library(dplyr)

# Read the fixed GeoJSON file
cu_geo <- st_read("cu-tracts-fixed.json")

# Read the CSV file with GEOID as character
cu_poverty <- read.csv("cu-poverty.csv", colClasses = c("GEOID" = "character"))

# Clean the poverty rate column by removing "%" and converting to numeric
cu_poverty <- cu_poverty %>%
  mutate(poverty_rate = as.numeric(gsub("%", "", Percent_below_poverty_level_Estimate)))

# Make sure GEOIDs are character in geo data
cu_geo <- cu_geo %>%
  mutate(GEOID = as.character(GEOID))

# Join the data
cu_data <- cu_geo %>%
  left_join(cu_poverty, by = "GEOID")

print(paste("Rows with poverty data:", sum(!is.na(cu_data$poverty_rate))))

# Create color palette for poverty rate (using only non-NA values)
pal <- colorNumeric(
  palette = "YlOrRd",
  domain = cu_data$poverty_rate[!is.na(cu_data$poverty_rate)],
  na.color = "grey"
)

# Create leaflet map
leaflet(cu_data) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(
    fillColor = ~pal(poverty_rate),
    weight = 1,
    opacity = 1,
    color = "white",
    fillOpacity = 0.7,
    highlightOptions = highlightOptions(
      weight = 2,
      color = "#666",
      fillOpacity = 0.9
    ),
    label = ~paste0("Tract: ", TRACT_NAME, "<br>Poverty Rate: ",
                    round(poverty_rate, 1), "%") %>%
      lapply(htmltools::HTML)
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = ~poverty_rate,
    title = "Poverty Rate (%)",
    opacity = 0.7,
    na.label = "No data"
  )
