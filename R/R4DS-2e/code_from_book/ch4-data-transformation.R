

# Ch 4 - Data transformation #####################################

library(nycflights13)
library(tidyverse)

# 4.1. dplyr basics  ------------------------------------

flights

glimpse(flights)


# looking at pipes |> say it as "then"

flights |>
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )


# 4.2 Rows  ------------------------------------

# 4.2.1 filter() ------------------------------------

flights |> 
  filter(dep_delay > 120)

# Flights that departed on January 1
flights |> 
  filter(month == 1 & day == 1)

# Flights that departed in January or February
flights |> 
  filter(month == 1 | month == 2)


# A shorter way to select flights that departed in January or February
flights |> 
  filter(month %in% c(1, 2))

# assigning the output to a new dataframe
jan1 <- flights |> 
  filter(month == 1 & day == 1)

jan1

# 4.2.2 Common mistakes ------------------------------

# confusing == with =

#flights |> 
#  filter(month = 1)

# writing an incomplete or statement

flights |> 
  filter(month == 1 | 2)

# this doesn't throw an error, but | 2 isn't evaluated in the way we 
# want. Will return to this later (is it evaluated as true??)

# 4.2.3 arrange() ------------------------------

flights |> 
  arrange(year, month, day, dep_time)

# desc() is descending order

flights |> 
  arrange(desc(dep_delay))

# 4.2.4 distinct() -------------------------

flights |> 
  distinct()

# Find all unique origin and destination pairs
flights |> 
  distinct(origin, dest) |>
    print(n = 224)


flights |> 
  distinct(origin, dest, .keep_all = TRUE)


# give counts of unique files sorted by n

flights |>
  count(origin, dest, sort = TRUE) |>
    print(n = 224)



# 4.4 The pipe

flights |> 
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

# Note the key binding for |>  is ctrl + shift + m
# Also the key binding for <- is alt + -

# 4.5 Groups

# 4.5.1. group_by

flights |> 
  group_by(month)

# 4.5.2 summarize()

flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay)
  )

# the code above gives NAs for each record under ave_delay
# here is the fix - ignore the NAs for now

flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE)
  )


# returning the number of rows...

flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n()
  )


# 5.4.3 slice functions

# df |> slice_head(n = 1) takes the first row from each group.
# df |> slice_tail(n = 1) takes the last row in each group.
# df |> slice_min(x, n = 1) takes the row with the smallest value of column x.
# df |> slice_max(x, n = 1) takes the row with the largest value of column x.
# df |> slice_sample(n = 1) takes one random row.

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) |>
  relocate(dest)

# this includes tied values

# with_ties = FALSE

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1, with_ties = FALSE) |>
  relocate(dest)

# 4.5.4 Grouping by multiple variables

daily <- flights |>  
  group_by(year, month, day)
daily

daily_flights <- daily |> 
  summarize(n = n())

# request to suppress message about overriding .groups 
# with .groups = "drop_last"

daily_flights <- daily |> 
  summarize(
    n = n(), 
    .groups = "drop_last"
  )

daily_flights


# 4.5.5 Ungrouping

daily

daily |> 
  ungroup() |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    flights = n()
  )


# 4.5.6 .by

flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = month
  )

flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = c(origin, dest)
  )



# 4.6 Case study: aggregates and sample size

batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )
batters


batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 1 / 10) + 
  geom_smooth(se = FALSE)






S