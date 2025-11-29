library(tidycensus)
library(dplyr)
library(stringr)

# Set your Census API key
census_api_key("8a4517f7bed332fc21d9b4f2173029e771da2eb2", install = TRUE)

# Median household income
income_data <- get_acs(
  geography = "tract",
  variables = "B19013_001",
  state = "IL",
  county = "Champaign",
  year = 2023,
  survey = "acs5"
) %>%
  select(GEOID, NAME, median_income = estimate)

# Health insurance coverage (% with coverage)
insurance_data <- get_acs(
  geography = "tract",
  variables = "S2701_C03_001",
  state = "IL",
  county = "Champaign",
  year = 2023,
  survey = "acs5"
) %>%
  select(GEOID, insurance_coverage = estimate)

# Combine them
sdoh_data <- income_data %>%
  left_join(insurance_data, by = "GEOID") %>%
  mutate(NAMELSAD = str_remove(NAME, "; Champaign County; Illinois")) %>%
  select(GEOID, NAMELSAD, median_income, insurance_coverage)

# View the data
head(sdoh_data)

# Save to CSV
write.csv(sdoh_data, "/Users/jakecox/rstudio/cu-geo/cu-sdoh.csv", row.names = FALSE)
