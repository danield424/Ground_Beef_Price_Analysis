#### Preamble ####
# Purpose: Tests the structure and validity of the simulated ground beef data.
# Author: Daniel Du
# Date: 14 November 2024
# Contact: danielc.du@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the correct Rproj


#### Workspace setup ####
library(tidyverse)

analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 100 rows
if (nrow(analysis_data) == 100) {
  message("Test Passed: The dataset has 100 rows.")
} else {
  stop("Test Failed: The dataset does not have 100 rows.")
}

# Check if the dataset has 4 columns
if (ncol(analysis_data) == 4) {
  message("Test Passed: The dataset has 4 columns.")
} else {
  stop("Test Failed: The dataset does not have 4 columns.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if the `store` column contains only expected values
expected_stores <- c("Loblaws", "Metro", "Sobeys", "Freshco", "T&T")
if (all(analysis_data$store %in% expected_stores)) {
  message("Test Passed: The `store` column contains only expected store values.")
} else {
  stop("Test Failed: The `store` column contains unexpected values.")
}

# Check if the `ground_beef_type` column contains only expected values
expected_types <- c("Extra Lean Ground Beef", "Lean Ground Beef", "Medium Ground Beef")
if (all(analysis_data$ground_beef_type %in% expected_types)) {
  message("Test Passed: The `ground_beef_type` column contains only expected ground beef types.")
} else {
  stop("Test Failed: The `ground_beef_type` column contains unexpected values.")
}

# Check if `price_per_lb` column is numeric and within the specified range (4 to 10)
if (is.numeric(analysis_data$price_per_lb) && all(analysis_data$price_per_lb >= 4 & analysis_data$price_per_lb <= 10)) {
  message("Test Passed: The `price_per_lb` column is numeric and within the range 4 to 10.")
} else {
  stop("Test Failed: The `price_per_lb` column is either not numeric or contains values out of the range 4 to 10.")
}

# Check if `date` column is of Date type and within the year 2024
if (inherits(analysis_data$date, "Date") && all(format(analysis_data$date, "%Y") == "2024")) {
  message("Test Passed: The `date` column is of Date type and all dates are in the year 2024.")
} else {
  stop("Test Failed: The `date` column is either not of Date type or contains dates outside the year 2024.")
}

# Check for duplicate rows
if (nrow(analysis_data) == nrow(distinct(analysis_data))) {
  message("Test Passed: The dataset contains no duplicate rows.")
} else {
  stop("Test Failed: The dataset contains duplicate rows.")
}

# Check if `price_per_lb` has at least some variation (more than one unique value)
if (length(unique(analysis_data$price_per_lb)) > 1) {
  message("Test Passed: The `price_per_lb` column has more than one unique value.")
} else {
  stop("Test Failed: The `price_per_lb` column does not have sufficient variation.")
}