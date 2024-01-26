
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
  
# 8. Find all destinations that are flown by at least two carriers. Use those 
# destinations to come up with a relative ranking of the carriers based on 
# their performance for the same destination.





