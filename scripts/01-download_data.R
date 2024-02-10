#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Adrian Ly
# Date: 9 February 2024 
# Contact: adrian.ly@mail.utoronto.ca
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
#### Download data ####
# [...ADD CODE HERE TO DOWNLOAD...]



#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(the_raw_data, "inputs/data/raw_data.csv") 

         
