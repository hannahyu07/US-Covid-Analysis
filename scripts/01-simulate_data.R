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

# Define life expectancy ranges for each group
life_expectancy_ranges <- list(
  "All" = c(77, 80),
  "Hispanic" = c(80, 83),
  "Non-Hispanic AIAN" = c(65, 72),
  "Non-Hispanic Asian" = c(83, 87),
  "Non-Hispanic Black" = c(70, 76),
  "Non-Hispanic White" = c(77, 81)
)

# Define function to generate random numbers within a range
generate_random_number <- function(range, n) {
  return(round(runif(n, min = range[1], max = range[2]), 1))
}

# Generate life expectancy data
simulated_life_exp <- tibble(
  year = years,
  All = generate_random_number(c(77, 80), n = length(years)),
  Hispanic = generate_random_number(c(80, 83), n = length(years)),
  Non_Hispanic_AIAN = generate_random_number(c(65, 72), n = length(years)),
  Non_Hispanic_Asian = generate_random_number(c(83, 87), n = length(years)),
  Non_Hispanic_Black = generate_random_number(c(70, 76), n = length(years)),
  Non_Hispanic_White = generate_random_number(c(77, 81), n = length(years))
)

print(head(simulated_life_exp))

# Save the dataset to a CSV file
write.csv(simulated_life_exp, "outputs/data/simulated_life_exp.csv", row.names = FALSE)



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

