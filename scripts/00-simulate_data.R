#### Preamble ####
# Purpose: Simulates a dataset of ground beef prices depending on store.
# Author: Daniel Du
# Date: 14 November 2024
# Contact: danielc.du@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the correct Rproj


#### Workspace setup ####
library(tidyverse)
set.seed(424)

#### Simulate data ####

# Define parameters
stores <- c("Loblaws", "Metro", "Sobeys", "Freshco", "T&T")
ground_beef_types <- c("Extra Lean Ground Beef", "Lean Ground Beef", "Medium Ground Beef")

# Simulate dataset
analysis_data <- tibble(
  store = sample(stores, 100, replace = TRUE),
  ground_beef_type = sample(ground_beef_types, 100, replace = TRUE),
  price_per_lb = round(runif(100, min = 4, max = 10), 2),  # Random price between $4 and $10 per lb
  date = sample(seq.Date(as.Date("2024-01-01"), as.Date("2024-11-14"), by = "day"), 100, replace = TRUE)
)
head(analysis_data)

#### Save data ####
write_csv(analysis_data, "data/00-simulated_data/simulated_data.csv")
