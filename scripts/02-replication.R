#### Preamble ####
# Purpose: Paper Replication
# Author: Adrian Ly, Hannah Yu
# Date: 9 February 2024 
# Contact: adrian.ly@mail.utoronto.ca, s.goel@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(sf)
library(readxl)
library(janitor)
library(lubridate)
library(dplyr)
library(data.table)
library(RColorBrewer)
library(ggpubr)
library(scales)
library(here)
library(kableExtra)
library(webshot)
#### Reading files ####
ghs_data <- read_excel(here::here("inputs/data/GHS_index.xlsx"))
world_map <- st_read(here::here("inputs/data/world/World_Countries__Generalized_.shp"))
life_exp <- read.csv(here::here("inputs/data/life_table.csv"), stringsAsFactors = FALSE)
vote_share <- read.csv(here::here("inputs/data/Vote_share_2020_data.csv"), stringsAsFactors = FALSE)
deaths <- read.csv(here::here("inputs/data/covid-19-death-rates.csv"), stringsAsFactors = FALSE)

## CREATE FIGURE 1
ghs_data <- ghs_data %>%
  mutate(COUNTRY = case_when(
    Country == "United States of America" ~ "United States",
    Country == "Bolivia (Plurinational State of)" ~ "Bolivia",
    # Add other necessary name changes here
    TRUE ~ Country
  ))

world_ghs <- merge(world_map, ghs_data, by.x = "COUNTRY", by.y = "COUNTRY", all.x = TRUE)


ggplot(data = world_ghs) +
  geom_sf(aes(fill = `OVERALL SCORE`), color = "white") +
  scale_fill_distiller(palette = "Spectral", na.value = "lightgrey", 
                       name = "GHS Index Score", direction = 1,
                       limits = c(min(ghs_data$`OVERALL SCORE`, na.rm = TRUE), max(ghs_data$`OVERALL SCORE`, na.rm = TRUE)),
                       labels = comma) +  # Use comma to format numbers with commas
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5))

# Save the plot to a file
ggsave("outputs/graphs/GHS_Index_Map.png", width = 11, height = 8)

## CREATE FIGURE 2

# Reshape the data if necessary
life_exp_melted <- reshape(
  life_exp,
  idvar = "year_id",
  varying = list(names(life_exp)[-1]), 
  v.names = "life_exp",
  times = names(life_exp)[-1],
  new.row.names = 1:1e5,
  direction = "long"
)
life_exp_melted$race <- gsub("_", " ", life_exp_melted$time)  # Convert "_" to " " in race names
life_exp_melted <- life_exp_melted[, c("year_id", "race", "life_exp")]

life_exp_melted[life_exp_melted$race == 'All', "race"] <- 'All races and origins'

## CREATE PANEL A
est_life <- ggplot(data = life_exp_melted[!(life_exp_melted$race %like% 'AIAN|Asian'), ], aes(x = year_id, y = life_exp, color = race)) +
  geom_point(shape = 16, size = 3.5, alpha = 0.9) +  # Circular points with size 2
  geom_line(aes(group = race), alpha = 0.56, size = 1.5) +  # Add group aesthetic for lines
  scale_y_continuous(name = 'Life expectancy at birth', limits = c(65, 85)) +
  scale_x_continuous(name = '', breaks = seq(2006, 2020, by = 2), limits = c(2005.5, 2021.5)) +
  scale_color_manual(values = c('#0c4928', '#0b3669', '#4c2962', '#5a0f1c'), 
                     labels = c("All races and origins", "Hispanic", "Black", "White")) +
  # Darker color values
  theme_minimal() +
  theme(axis.title = element_text(size = 14),  # Adjusting the size of the y-axis label
        axis.text = element_text(size = 12),
        legend.position = 'bottom',  # Set legend position to bottom
        legend.justification = 'center',  # Center the legend
        legend.text = element_text(size = 10),  # Adjusting the font size for legend text
        legend.title = element_text(size = 12, face = 'bold')) +
  labs(color = "Race:")  # Set the legend title

# Save the plot to a file
ggsave("outputs/graphs/Life_Exp.png", width = 10, height = 8)

## CREATE FIGURE 3

# Create a dataframe to store the changes by race
change_by_race <- data.frame(
  race = c("All races and origins", "Hispanic", "American Indians and Alaska Native", "Asian", "Black", "White"),
  change_2020_2019 = c(77 - 78.8, 77.9 - 81.9, 67.1 - 71.8, 83.6 - 85.6, 71.5 - 74.8, 77.4 - 78.8),
  change_2021_2020 = c(76.1 - 77, 77.7 - 77.9, 65.2 - 67.1, 83.5 - 83.6, 70.8 - 71.5, 76.4 - 77.4)
)
# Melt the dataframe
tmp <- melt(change_by_race, id.vars = "race", measure.vars = c("change_2020_2019", "change_2021_2020"), 
            variable.name = "period", value.name = "diff")

change_life_exp <- ggplot(data = tmp, aes(x = race, y = diff, fill = period)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.71) +
  scale_y_continuous(name = "Change (years)", breaks = -5:0, limits = c(-5.5, 0)) +
  scale_fill_manual(name = "Time period", values = c('#243f29', '#186d38'), labels = c('2019-2020', '2020-2021')) + 
  scale_color_manual(name = "Time period", values = c('#243f29', '#186d38'), labels = c('2019-2020', '2020-2021')) + 
  theme_minimal() + labs(x = '') +
  geom_text(aes(label = sprintf("%.1f", diff)), position = position_dodge(width = 0.9), vjust = 1.3, size = 4) +
  theme(
    axis.title = element_text(size = 14),
    axis.text.x = element_text(size = 10, hjust = 1),
    axis.text.y = element_text(size = 8),
    legend.text = element_text(size = 12),
    legend.title = element_text(size = 12, face = 'bold')) + 
  scale_x_discrete(labels = function(x) str_wrap(x, width = 15))

ggsave("outputs/graphs/Change_Life_Exp.png", width = 10, height = 8)

## CREATE FIGURE 4

vote_data_by_state <- vote_share %>%
  group_by(state_name) %>%
  summarize(
    total_votes = sum(total_votes),
    total_gop_votes = sum(votes_gop),
    total_dem_votes = sum(votes_dem),
    total_diff = sum(diff),
    avg_per_gop = mean(per_gop),
    avg_per_dem = mean(per_dem),
    avg_per_point_diff = mean(per_point_diff)
  )

vote_data_by_state <- vote_data_by_state |>
  mutate(gop_greater = if_else(total_gop_votes > total_dem_votes, 1, 0))

# Calculate proportion of Republican votes
sorted_states <- vote_data_by_state
sorted_states$proportion_republican <- sorted_states$total_gop_votes / sorted_states$total_votes

# Sort by proportion of Republican votes
sorted_states <- sorted_states[order(-sorted_states$proportion_republican), ]

# Select top 10 states
top_10_states <- head(sorted_states, 10)


# Extract the top 10 states with the biggest difference
top_10_states <- head(sorted_states, 10)
# Create a data frame for plotting
plot_data <- data.frame(
  state_name = top_10_states$state_name,
  republican_votes = top_10_states$total_gop_votes,
  democrat_votes = top_10_states$total_dem_votes
)

# Convert data to long format for ggplot
plot_data_long <- tidyr::pivot_longer(plot_data, cols = c(republican_votes, democrat_votes), names_to = "party", values_to = "votes")

# Create the stacked bar plot
ggplot(plot_data_long, aes(x = state_name, y = votes, fill = party)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Number of Votes by Top 10 Republican State", x = "State", y = "Total Votes", fill = "Party") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  scale_fill_manual(values = c("republican_votes" = "red", "democrat_votes" = "blue"),
                    labels = c("Democratic Votes", "Republican Votes"))

ggsave("outputs/graphs/Voter_Data.png", width = 10, height = 8)


## CREATE TABLE 1

# Assign column names
colnames(deaths) <- c("State", "Death_Rate")

# Rank the states based on death rate
deaths <- deaths[order(-deaths$Death_Rate), ]
deaths$Rank <- 1:nrow(deaths)

# Create the table
table <- head(data.frame(Rank = deaths$Rank, State = deaths$State, Deaths = deaths$Death_Rate), 10)

# Print the table using kableExtra
kable_img <- kable(table, caption = "Top 10 States with Highest Death Rates from COVID-19 (per 100,000 people)", align = "c") %>%
  kable_styling(full_width = FALSE)

save_kable(kable_img, "outputs/graphs/table.html")

# Capture the table as an image
webshot::webshot("outputs/graphs/table.html", "outputs/graphs/table.png")

## CREATE TABLE 2

# Filter the data for the years 2019 to 2021
life_exp_subset <- life_exp_melted[life_exp_melted$year_id >= 2019 & life_exp_melted$year_id <= 2021, ]

# Pivot the data to create a table and rename columns
life_exp_table <- reshape2::dcast(life_exp_subset, year_id ~ race, value.var = "life_exp")
colnames(life_exp_table) <- c("Year", "All races and origins", "Hispanic", "AIAN", "Asian", "Black", "White")

# Create a table using knitr::kable

kable_img2 <- kable(life_exp_table, col.names = c("Year", "All Races and Origins", "Hispanic", "AIAN", "Asian", "Black", "White"))

save_kable(kable_img2, "outputs/graphs/table2.txt")


## CREATE FIGURE 5

merged_data <- merge(deaths, vote_data_by_state, by.x = "State", by.y = "state_name")
# Create a scatter plot of COVID-19 death rates against the percentage of Republican votes
ggplot(merged_data, aes(x = as.factor(gop_greater), y = Death_Rate)) +
  geom_point(shape = 21, fill = "skyblue", color = "darkblue", size = 3) + # Use filled circles with blue color
  labs(x = "Republican Votes", y = "COVID-19 Death Rate") +
  ggtitle("COVID-19 Death Rates vs. Republican Votes") +
  theme_minimal() + # Use minimal theme for cleaner appearance
  theme(plot.title = element_text(size = 16, face = "bold"), # Adjust title appearance
        axis.title = element_text(size = 14)) + # Adjust axis labels appearance
  scale_x_discrete(labels = c("Democratic Majority", "Republican Majority")) # Set custom labels for x-axis


ggsave("outputs/graphs/COVID-deaths-rates-votes.png", width = 10, height = 8)

