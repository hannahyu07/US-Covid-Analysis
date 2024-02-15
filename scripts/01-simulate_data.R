#### Preamble ####
# Purpose: Simulate Data of Interest
# Author: Adrian Ly, Hannah Yu, Sakhil Goel
# Date: 9 February 2024 
# Contact: adrian.ly@mail.utoronto.ca, realhannah.yu@mail.utoronto.ca, s.goel@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(knitr)


#### Simulate data ####

# Simulate the average life expectancy of people by ethnicity
# Set seed for reproducibility
set.seed(123)

# Define the years
years <- seq(2006, 2021)

# Define function to generate random numbers within a range
generate_random_number <- function(range, n) {
  return(round(runif(n, min = range[1], max = range[2]), 1))
}

# Generate simulated life expectancy data
simulated_life_exp <- tibble(
  year = years,
  # Every group has a different life expectancy range
  All = generate_random_number(c(77, 80), n = length(years)),
  Hispanic = generate_random_number(c(80, 83), n = length(years)),
  Non_Hispanic_AIAN = generate_random_number(c(65, 72), n = length(years)),
  Non_Hispanic_Asian = generate_random_number(c(83, 87), n = length(years)),
  Non_Hispanic_Black = generate_random_number(c(70, 76), n = length(years)),
  Non_Hispanic_White = generate_random_number(c(77, 81), n = length(years))
)

print(head(simulated_life_exp))

# Test that there are 7 columns
num_cols <- ncol(simulated_life_exp)
expected_num_cols <- 7
test_num_cols <- num_cols == expected_num_cols
test_num_cols

# Test that there are 16 years
simulated_life_exp$year |> length() == 16

# Test that All is between 77 and 80
simulated_life_exp$All |> min() >= 77
simulated_life_exp$All |> max() <= 80

# Test that Hispanic is between 80 and 83
simulated_life_exp$Hispanic |> min() >= 80
simulated_life_exp$Hispanic |> max() <= 83

# Test that Non_Hispanic_AIAN is between 65 and 72
simulated_life_exp$Non_Hispanic_AIAN |> min() >= 65
simulated_life_exp$Non_Hispanic_AIAN |> max() <= 72

# Test that Non_Hispanic_Asian is between 83 and 87
simulated_life_exp$Non_Hispanic_Asian |> min() >= 83
simulated_life_exp$Non_Hispanic_Asian |> max() <= 87

# Test that Non_Hispanic_Black is between 70 and 76
simulated_life_exp$Non_Hispanic_Black |> min() >= 70
simulated_life_exp$Non_Hispanic_Black |> max() <= 76

# Test that Non_Hispanic_White is between 77 and 81
simulated_life_exp$Non_Hispanic_White |> min() >= 77
simulated_life_exp$Non_Hispanic_White |> max() <= 81


# Save the dataset to a CSV file
write.csv(simulated_life_exp, "outputs/data/simulated_life_exp.csv", row.names = FALSE)

# Confirm file creation
file.exists("outputs/data/simulated_life_exp.csv")


# Simulate the Vote at Each State
set.seed(123)

# Define the state names
state_names <- c(
  "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
  "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
  "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
  "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
  "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
  "Wisconsin", "Wyoming"
)

# Generate simulated vote data
simulated_vote_data <- tibble(
  state_name = rep(state_names, each = 1),
  total_votes = round(runif(length(state_names), min = 50000, max = 1000000), 0),  # Simulate total votes (between 50,000 and 1,000,000)
  votes_gop = round(runif(length(state_names), min = 0.4 * total_votes, max = 0.6 * total_votes), 0),  # Simulate GOP votes (between 40% and 60% of total votes)
  votes_dem = (total_votes - votes_gop), # Calculate Democratic votes
  diff = votes_gop - votes_dem , # Calculate the difference between GOP and Democratic votes
  per_gop = round(votes_gop/total_votes, 2), # Simulate GOP vote share (between 40% and 60%)
  per_dem = 1 - per_gop , # Calculate Democratic vote share
  per_point_diff = round(abs(per_gop - per_dem), 2),  # Calculate absolute difference in vote share
)

print(head(simulated_vote_data))

# Test that there are 50 states
simulated_vote_data$state_name |> length() == 50

# Test that total_votes is between 50000 and 1000000
simulated_vote_data$total_votes |> min() >= 50000
simulated_vote_data$total_votes |> max() <= 1000000

# Test that there are 8 columns
num_cols <- ncol(simulated_vote_data)
expected_num_cols <- 8
test_num_cols <- num_cols == expected_num_cols
test_num_cols


# Write simulated vote data to CSV
write.csv(simulated_vote_data, "outputs/data/simulated_vote_data.csv", row.names = FALSE)

# Confirm file creation
file.exists("outputs/data/simulated_vote_data.csv")

