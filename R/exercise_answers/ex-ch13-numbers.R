
# Ch13 - Numbers
#===============================================================================

library(tidyverse)
library(nycflights13)

# 13.3.1 Exercises -------------------------------------------------------------

# 1. How can you use count() to count the number rows with a missing value 
# for a given variable?


flights |> count(is.na(arr_time))


# 2. Expand the following calls to count() to instead use group_by(), 
# summarize(), and arrange():

flights |> count(dest, sort = TRUE)

flights |>
  group_by(dest) |>
  summarize(
    n = n()
  ) |>
  arrange(desc(n))



# 13.4.8 Exercises -------------------------------------------------------------

# 1. Explain in words what each line of the code used to generate Figure 13.1 does.

flights |> 
  # group by hour which is extracted using integer division
  group_by(hour = sched_dep_time %/% 100) |> 
  # calculate "proportion cancelled" by dividing no. cancelled by sample size
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n()) |> 
  # set the range from 1 to max which is 24
  filter(hour > 1) |> 
  # plot the proportion cancelled against the hour
  ggplot(aes(x = hour, y = prop_cancelled)) +
  # set the line to grey
  geom_line(color = "grey50") + 
  # set the point size to the sample size
  geom_point(aes(size = n))


# 2.What trigonometric functions does R provide? Guess some names and look 
#   up the documentation. Do they use degrees or radians?

# Angles are in radians, not degrees, for the standard versions 

# Demonstrating radians with trigonometric functions

x <- c(seq(0,2, by = 0.05))

xrad  <-  pi*x

cos_x <- cos(xrad)
sin_x <- sin(xrad)
tan_x <- tan(xrad)

acos_x <- acos(xrad)
asin_x <- asin(xrad)
atan_x <- atan(xrad)

plot(x, cos_x)
plot(x, sin_x)
plot(x, tan_x)

plot(x, acos_x)
plot(x, asin_x)
plot(x, atan_x)



# 3. Currently dep_time and sched_dep_time are convenient to look at, but 
# hard to compute with because they’re not really continuous numbers. You 
# can see the basic problem by running the code below: there’s a gap 
# between each hour.

flights |> 
  filter(month == 1, day == 1) |> 
  ggplot(aes(x = sched_dep_time, y = dep_delay)) +
  geom_point()


# Convert them to a more truthful representation of time (either fractional 
# hours or minutes since midnight).

# Converting to number of minutes since midnight...

flights |> 
  filter(month == 1, day == 1) |> 
  mutate(
    departure_delay = dep_delay,
    hour = sched_dep_time %/% 100,
    minute = sched_dep_time %% 100,
    min_past_midnight = ((sched_dep_time %/% 100)* 60) + (sched_dep_time %% 100),
    .keep = "used"
  )  |> 
  ggplot(aes(x = min_past_midnight, y = departure_delay)) +
  geom_point()


# 4. Round dep_time and arr_time to the nearest five minutes.

glimpse(flights)

?round

flights |>
  select(dep_time, arr_time) |>
  mutate(
    rdep_time = round(dep_time, -1),
    rarr_time = round(arr_time, -1)
  ) 

# 13.5.4 Exercises -------------------------------------------------------------

# 1. Find the 10 most delayed flights using a ranking function. How do you 
# to handle ties? Carefully read the documentation for min_rank().

? min_rank()

glimpse(flights)

flights$dep_delay

flights |> select(carrier, flight, origin, dest, dep_delay) |>
  mutate(
    rank_dep_delay = min_rank(dep_delay)
  ) |>
  arrange(desc(dep_delay))


# 2. Which plane (tailnum) has the worst on-time record?

flights |> select(tailnum, carrier, flight, origin, dest, dep_delay) |>
  mutate(
    rank_dep_delay = min_rank(dep_delay)
  ) |>
  arrange(desc(dep_delay))

  
# 3. What time of day should you fly if you want to avoid delays as 
# much as possible?

# you definitely want to fly in the morning

flights |> select(sched_dep_time, dep_delay) |>
  filter(dep_delay > 30) |> 
  group_by(hour = sched_dep_time %/% 100) |>
  summarize(delayed_flight_count = n()) |>
  ggplot(aes(x = hour, y = delayed_flight_count)) +
  geom_line(color = "blue") + 
  geom_point()
  
# 4. What does flights |> group_by(dest) |> filter(row_number() < 4) do? What 
# does flights |> group_by(dest) |> filter(row_number(dep_delay) < 4) do?

# It appears to filter out destinations with more than 3 flights.

f <- flights |> group_by(dest) |> filter(row_number() < 4)

view(f)

# This would filter out those destinations with more than three delayed flights.

f <- flights |> group_by(dest) |> filter(row_number(dep_delay) < 4) |> 
  select(carrier, flight, origin, dest, dep_delay)

view(f)
  
# 5.For each destination, compute the total minutes of delay. For each flight, 
# compute the proportion of the total delay for its destination.

flights |> select(dest, dep_delay) |>
  group_by(dest) |>
  summarize( total_delay = sum(!is.na(dep_delay))) |>
  arrange(desc(total_delay))


# 6. Delays are typically temporally correlated: even once the problem that 
# caused the initial delay has been resolved, later flights are delayed to 
# allow earlier flights to leave. Using lag(), explore how the average flight 
# delay for an hour is related to the average delay for the previous hour.

flights2 <- flights |> 
  mutate(hour = dep_time %/% 100) |> 
  group_by(year, month, day, hour) |> 
  summarize(
    dep_delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) |> 
  filter(n > 5)

flights2 |> select( hour, dep_delay) |>
  mutate(
    delay_increase = dep_delay - lag(dep_delay)
  ) |>
  group_by(hour) |>
  summarize(
    mean_delay_increase = mean( delay_increase )
  )

# 7. Look at each destination. Can you find flights that are suspiciously 
# fast (i.e. flights that represent a potential data entry error)? Compute 
# the air time of a flight relative to the shortest flight to that 
# destination. Which flights were most delayed in the air?

glimpse(flights)

flights |> select(origin, dest, dep_time, arr_time) |>
  group_by(origin, dest) |>
  mutate(
    air_time = arr_time - dep_time
  ) |>
  filter(air_time > 0 & air_time < 15) |>
  summarize(
    min(air_time)
  ) |>
  
  print(n = 223)

# flight from Newark to Albuquerque in 42 min is error

  
# 8. Find all destinations that are flown by at least two carriers. Use those 
# destinations to come up with a relative ranking of the carriers based on 
# their performance for the same destination.


# Destinations that are flown by at least two carriers

flights1  <- flights |>
  distinct(dest, carrier) |>
  group_by(dest) |>
  summarize(
    n = n()
  )|>
  filter( n > 1)

flights1


# Relative ranking of the carriers based on their performance for the 
# same destination

# Just using destinations with carriers with n > 1 

flights2 <- flights1 |>
  left_join(flights)


# Define performance as "being on time". Could use average dep_delay. For each
# carrier by destination, need to group by carrier and destination


flights2 |> 
  group_by(dest, carrier) |>
  mutate(
    delay = mean(dep_delay, na.rm = TRUE),
  ) |>
  distinct(dest, carrier, delay) |>
  arrange(delay) |>
  print(n = 285)


# 13.6.7 Exercises -------------------------------------------------------------

# 1. Brainstorm at least 5 different ways to assess the typical delay 
# characteristics of a group of flights. When is mean() useful? When is 
# median() useful? When might you want to use something else? Should you 
# use arrival delay or departure delay? Why might you want to use 
# data from planes?
 
# mean() gives you the estimate of the population mean which is sensitive to 
# outliers. If the data are skewed, the mean will tend towards the skewness of 
# the data. medium() gives the location of the midpoint of the data. It is less
# affected by outliers in the data. Departure and arrival delays are necessarily
# correlated since arrivals are dependent on departure times. You might want
# to see if individual planes are running late due to characteristics of the plane
# model type or even the pilots that fly a given plane

glimpse(flights)

flights |>
  group_by(flight) |>
  summarize(
    dep_mean = mean(dep_delay, na.rm = TRUE),
    dep_median = median(dep_delay, na.rm = TRUE),
    dep_maximum = max(dep_delay, na.rm = TRUE),
    dep_minimum = min(dep_delay, na.rm = TRUE),
    dep_n = n()
    
  ) |>
  ggplot(aes(x = dep_n)) +
  geom_histogram(binwidth = 1)


dplyr::last_dplyr_warnings()

  
# 2. Which destinations show the greatest variation in air speed?

# look at min / max and sd to measure variance
# air speed can be calculated as distance / air_time
# group by destination and calculate stats

# Tulsa and Oklahoma City showed the greatest variation based
# on standard deviation

flights |> 
  select(dest, distance, air_time) |>
  filter(
    (!is.na(distance))&(!is.na(air_time))
    ) |> 
  mutate(
    airspeed = (distance / air_time) * 60
  ) |>
  group_by(dest) |>
  summarize(
    max_airspeed = max(airspeed),
    min_airspeed = min(airspeed),
    sd_airspeed = sd(airspeed)
  ) |>
  arrange(sd_airspeed) |>
  print(n = 105)

  
# 3. Create a plot to further explore the adventures of EGE. Can you find any 
# evidence that the airport moved locations? Can you find another variable 
# that might explain the difference?

# EGE is regional airport in Eagle County, CO. Its at altitude so the runway
# is very long. It is seasonally very busy due to ski season in the winter
# It has a single runway which is over a mile long.

# The airport isn't reported as having moved. 

flights |>
  filter( dest == 'EGE' ) |>
  group_by(origin)  |>
  summarize(
    max_distance = max(distance),
    min_distance = min(distance),
    min_max_diff = max_distance - min_distance
  ) |>
  ggplot(aes(x = origin, y = distance)) +
  geom_point()

flights |>
  filter( dest == 'EGE' ) |>
  group_by(origin) |>
  mutate(
    max_distance = max(distance),
    min_distance = min(distance),
    range_dist = max_distance - min_distance   
  ) |>
  ggplot(aes(x = origin, y = range_dist)) + 
  geom_point()

# The range for EWR and JFK distances are 1 mile each. The fact they aren't
# zero suggests some kind of error locating EGE. Maybe its related to the 
# length of the runway.






