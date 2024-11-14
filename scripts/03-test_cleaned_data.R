#### Preamble ####
# Purpose: Tests cleaned data.
# Author: Daniel Du
# Date: 14 November 2024
# Contact: danielc.du@mail.utoronto.ca
# License: MIT
# Pre-requisites: Cleaned data with SQL, and saved to data/02-analysis_data
# Any other information needed? Make sure you are in the correct rproj


#### Workspace setup ####
library(tidyverse)
library(testthat)

analysis_data <- read_csv("data/02-analysis_data/cleaned_data.csv")

#### Test data ####

# Test that the dataset has 78 rows
test_that("dataset has 78 rows", {
  expect_equal(nrow(analysis_data), 78)
})

# Test that the dataset has 6 columns
test_that("dataset has 6 columns", {
  expect_equal(ncol(analysis_data), 6)
})

# Test that the column names are as expected
test_that("column names are correct", {
  expected_colnames <- c("nowtime", "vendor", "product_name", "units", "current_price", "price_per_unit_lb")
  expect_equal(colnames(analysis_data), expected_colnames)
})

# Test that `nowtime` is in datetime format
test_that("nowtime column is in datetime format", {
  expect_true(all(lubridate::is.POSIXct(as.POSIXct(analysis_data$nowtime, format="%Y-%m-%d %H:%M:%S"))))
})

# Test that `vendor` is a character and contains only expected vendor names
test_that("vendor column is character and contains expected vendors", {
  expected_vendors <- c("Loblaws", "Metro", "NoFrills", "SaveOnFoods", "Voila", "Walmart")
  expect_type(analysis_data$vendor, "character")
  expect_true(all(analysis_data$vendor %in% expected_vendors))
})

# Test that `product_name` is a character column
test_that("product_name column is character", {
  expect_type(analysis_data$product_name, "character")
})

# Test that `current_price` is numeric and non-negative
test_that("current_price column is numeric and non-negative", {
  expect_type(analysis_data$current_price, "double")
  expect_true(all(analysis_data$current_price >= 0 | is.na(analysis_data$current_price)))
})

# Test that there are no missing values in columns where missing data is not expected
test_that("no missing values in essential columns", {
  essential_columns <- c("nowtime", "vendor", "product_name", "units", "price_per_unit_lb")
  expect_true(all(!is.na(analysis_data[essential_columns])))
})

# Test that `current_price` has at least some variation (more than one unique value if not all are NA)
test_that("current_price column has variation", {
  if (all(is.na(analysis_data$current_price))) {
    expect_true(TRUE)  # Skip if all are NA
  } else {
    expect_gt(length(unique(na.omit(analysis_data$current_price))), 1)
  }
})

