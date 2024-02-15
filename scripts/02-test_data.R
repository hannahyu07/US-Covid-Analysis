#### Preamble ####
# Purpose: Tests the Simulated Data
# Author: Adrian Ly, Hannah Yu
# Date: 9 February 2024 
# Contact: adrian.ly@mail.utoronto.ca, realhannah.yu@mail.utoronto.ca, s.goel@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(knitr)


#### Test data ####
## Test simulated_life_data
# Load the dataset generated in R
data1 <- read.csv("outputs/data/simulated_life_exp.csv", stringsAsFactors = FALSE)

# 1. Data Structure Check
# Check the number of rows and columns
structure_check <- dim(data)[1] == length(years) & dim(data)[2] == length(life_expectancy_ranges) + 1
print(paste("Data Structure Check:", ifelse(structure_check, "Passed", "Failed")))

# 2. Range Check
# Define the expected ranges
expected_ranges <- c(77:80, 80:83, 65:72, 83:87, 70:76, 77:81)
# Check if all values fall within the expected ranges
range_check <- all(sapply(data[, -1], function(x) all(x >= min(expected_ranges) & x <= max(expected_ranges))))
print(paste("Range Check:", ifelse(range_check, "Passed", "Failed")))

# 3. Numeric Check
# Check if all values are numeric
numeric_check <- all(sapply(data, is.numeric))
print(paste("Numeric Check:", ifelse(numeric_check, "Passed", "Failed")))

## Test simulated_vote_data
# Load the dataset generated in R
data2 <- read.csv("outputs/data/simulated_vote_data.csv", stringsAsFactors = FALSE)

# Test 1: Check number of rows and columns
num_rows <- nrow(data2)
num_cols <- ncol(data2)

expected_num_rows <- 50 # Expecting 50 states
expected_num_cols <- 8  # Expecting 7 columns (plus 1 for state_name)

if (num_rows == expected_num_rows && num_cols == expected_num_cols) {
  print("Test 1 passed: Correct number of rows and columns.")
} else {
  print("Test 1 failed: Incorrect number of rows or columns.")
}

# Test 2: Check for missing values
if (!anyNA(data2)) {
  print("Test 2 passed: No missing values found.")
} else {
  print("Test 2 failed: Missing values detected.")
}

# Test 3: Check for all 50 states
num_unique_states <- length(unique(data2$state_name))
expected_num_states <- 50

if (num_unique_states == expected_num_states) {
  print("Test 3 passed: Data includes data for all 50 states.")
} else {
  print("Test 3 failed: Data does not include data for all 50 states.")
}



