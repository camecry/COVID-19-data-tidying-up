# COVID-19 data general tidying up 
# data found in CSSEGISandData repo (COVID-19)

library(tidyverse)
library(lubridate)

# Getting the data
covid_global <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
glimpse(covid_global)

# Pivoting to tidy the data
tidy_data <- covid_global %>%
  pivot_longer(cols= `1/22/20`:`6/16/20`, # last available date
               names_to= "date", 
               values_to = "confirmed_cases")
head(tidy_data)

# Work on date variable
tidy_data <- mutate_at(tidy_data, vars(date), mdy)

# Rename
tidy_data <- tidy_data %>%
  rename("province_state" = `Province/State`,
         "country_region" = `Country/Region`)


############################################################################################
# Part 2) Extra 
# Filter out the observations where there are 0 confirmed cases  

tidy_data2 <- tidy_data %>%
  filter(confirmed_cases > 0)

# Transform the variable representing the countries in a factor
tidy_data2 <- mutate_at(tidy_data2, vars(country_region), as.factor)
glimpse(tidy_data2)

# Get the top 10 countries for total number of cases 
# by regrouping the other countries into "other" level
tidy_data2 %>%
  mutate(confirmed_lump = fct_lump_n(country_region, n=10)) %>% 
  count(confirmed_lump) 

