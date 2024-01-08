
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






