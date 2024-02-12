#### Preamble ####
# Purpose: Simulate Data of Interest
# Author: Adrian Ly, Hannah Yu
# Date: 9 February 2024 
# Contact: adrian.ly@mail.utoronto.ca, realhannah.yu@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(sf)
library(readxl)
library(knitr)
library(janitor)
library(lubridate)
library(dplyr)
library(data.table)
library(RColorBrewer)
library(ggpubr)
library(scales)
library(here)
library(kableExtra)

#### Simulate data ####

# Simulate the average life expectancy of people by ethnicity
# Set seed for reproducibility
set.seed(123)

# Define the years
years <- 2006:2021

# Define life expectancy ranges for each group
life_expectancy_ranges <- list(
  "All" = c(77, 80),
  "Hispanic" = c(80, 83),
  "Non-Hispanic AIAN" = c(65, 72),
  "Non-Hispanic Asian" = c(83, 87),
  "Non-Hispanic Black" = c(70, 76),
  "Non-Hispanic White" = c(77, 81)
)

# Generate the dataset
data <- matrix(NA, nrow = length(years), ncol = length(life_expectancy_ranges) + 1)
colnames(data) <- c("year_id", names(life_expectancy_ranges))
data[, 1] <- years

for (i in 1:length(years)) {
  for (group in names(life_expectancy_ranges)) {
    if (group == "All") {
      life_expectancy <- runif(1, life_expectancy_ranges[[group]][1], life_expectancy_ranges[[group]][2])
    } else {
      life_expectancy <- runif(1, life_expectancy_ranges[[group]][1], life_expectancy_ranges[[group]][2])
    }
    data[i, which(colnames(data) == group)] <- round(life_expectancy, 1)
  }
}

# Save the dataset to a CSV file
write.csv(data, "outputs/data/simulated_life_exp.csv", row.names = FALSE)

# Print the dataset to the console
print(data)


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

# Function to simulate vote data for a single state
simulate_state_votes <- function() {
  total_votes <- round(runif(1, 50000, 1000000))  # Simulate total votes (between 50,000 and 1,000,000)
  votes_gop <- round(runif(1, 0.4 * total_votes, 0.6 * total_votes))  # Simulate GOP votes (between 40% and 60% of total votes)
  votes_dem <- total_votes - votes_gop  # Calculate Democratic votes
  diff <- votes_gop - votes_dem  # Calculate the difference between GOP and Democratic votes
  per_gop <- runif(1, 0.4, 0.6)  # Simulate GOP vote share (between 40% and 60%)
  per_dem <- 1 - per_gop  # Calculate Democratic vote share
  per_point_diff <- abs(per_gop - per_dem)  # Calculate absolute difference in vote share
  c(votes_gop, votes_dem, total_votes, diff, per_gop, per_dem, per_point_diff)
}

# Simulate vote data for all states
simulated_vote_data <- sapply(1:length(state_names), function(i) simulate_state_votes())

# Convert simulated vote data to a data frame
simulated_vote_df <- data.frame(t(simulated_vote_data))
colnames(simulated_vote_df) <- c("votes_gop", "votes_dem", "total_votes", "diff", "per_gop", "per_dem", "per_point_diff")
simulated_vote_df$state_name <- state_names

# Print simulated vote data
print(simulated_vote_df)

# Define file path
file_path <- "outputs/data/simulated_vote_data.csv"

# Write simulated vote data to CSV
write.csv(simulated_vote_df, file = file_path, row.names = FALSE)

# Confirm file creation
file.exists(file_path)

