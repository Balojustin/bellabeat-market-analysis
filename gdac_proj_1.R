# FitBit Fitness Tracker Data
  # Data wrangling
  

#load libraries

library(tidyverse)
library(janitor)

#import tables and check the tables

daily_activity <- read_csv("dailyActivity_merged.csv")
glimpse(daily_activity)
str(daily_activity)

sleep_day <- read_csv("sleepDay_merged.csv")
head(sleep_day)

#change the format and convert to date type
as.Date(daily_activity$ActivityDate, format= "%m/%d/%Y") -> activitydate
head(activitydate)

# to check the data_type
typeof(activitydate)

#replace the ActivityDate column with the new date format
daily_activity$ActivityDate <- activitydate
head(daily_activity)

sleepday <- as.POSIXct(sleep_day$SleepDay, format= "%m/%d/%Y %H:%M:%S")
sleep_day$SleepDay <- as.Date(sleepday)
head(sleep_day)

n_distinct(daily_activity$Id)
n_distinct(sleep_day$Id)


merged_dataset <- full_join(daily_activity, sleep_day, by = c("Id" = "Id", "ActivityDate" = "SleepDay"))

#change the Id data_type and remove duplicates.

merged_dataset$Id <- as.character(merged_dataset$Id)

merged_dataset <- distinct(merged_dataset)

merged_dataset <- clean_names(merged_dataset)
merged_dataset <- rename(merged_dataset, "date" = activity_date)

merged_dataset <- merged_dataset %>%  
  select(id : total_distance, very_active_distance : total_time_in_bed)

#checkout merged_dataset
View(merged_dataset)
colnames(merged_dataset)
str(merged_dataset)
n_distinct(merged_dataset$id)

# Exploratory visualizations

ggplot(merged_dataset) + geom_jitter(aes(x = total_steps, y = calories, color = id)) +
  labs(title="Calories vs. Total_steps")
  
write.csv(merged_dataset, "merged_dataset.csv")
  