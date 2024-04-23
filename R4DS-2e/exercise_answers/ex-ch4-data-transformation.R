
# 4.2.5 Exercises --------------------------------------------------------------

# 1. In a single pipeline, find all flights that meet 
#   all of the following conditions:
#     x Had an arrival delay of two or more hours
#     x Flew to Houston (IAH or HOU)
#     x Were operated by United, American, or Delta
#     x Departed in summer (July, August, and September)
#     x Arrived more than two hours late, but didn’t leave late
#     X Were delayed by at least an hour, but made up over 30 minutes in flight


flights2 <-  flights |>
  filter(arr_delay > 120) |>
  filter(dest == "IAH" | dest == "HOU")  |>
  filter(carrier == "UA" | carrier == "AA" | carrier == "DL") |>
  filter(month == 7 | month == 8 | month == 9) 
# filter(dep_delay == 0) 
# filter(arr_delay > 60)  
#filter(air_time > 30)


glimpse(flights2)

# 2. Sort flights to find the flights with longest departure delays. 
# Find the flights that left earliest in the morning.

flights2 <- flights |>
  arrange(desc(dep_delay))

glimpse(flights2)

flights2 <- flights |> 
  arrange(dep_time)

glimpse(flights2)

# 3. Sort flights to find the fastest flights. (Hint: Try including a 
# math calculation inside of your function.)

flights2 <- flights |> 
  arrange(arr_time - dep_time)

glimpse(flights2)

flights2 |>
  print(n = 100) |>
  colnames()

# 4. Was there a flight on every day of 2013?

flights2 <- flights |> 
  distinct(year, month, day, .keep_all = TRUE)

flights2 |>
  print(n = 400) 

# Yes, there was a flight every day

# 5. Which flights traveled the farthest distance? Which traveled the least distance?

flights2 <- flights |> 
  arrange(desc(distance)) 

view(flights2)

# JFK to Honolulu was the farthest distance.



flights2 <- flights |>  
  arrange(distance)

view(flights2)

# EWR to LGA
# Newark Liberty International Airport to Laguardia Airport


# 4.5.7 Exercises --------------------------------------------------------------

# 1. Which carrier has the worst average delays? Challenge: can 
#  you disentangle the effects of bad airports vs. bad carriers? 
#  Why/why not?

glimpse(flights)

flights |> 
  group_by(carrier)

flights |> 
  group_by(dest) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  ) |>
  arrange(delay)

# No, there is probably an interaction between carriers and destinations


# 2. Find the flights that are most delayed upon departure from each destination.

flights |> 
  group_by(dest) |> 
  arrange(arr_delay)


# 3. How do delays vary over the course of the day. Illustrate your answer with a plot.

glimpse(flights)

delays_day <- flights |> 
  group_by(dep_time) |>
  summarize(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  )

delays_day

ggplot(
  data = delays_day,
  mapping = aes(x = dep_time, y = delay)
) +
  geom_point()
#

# Delays increase with the course of the day, peaking in the hours after midnight


# 4. What happens if you supply a negative n to slice_min() and friends?


flights2 <- (flights |> 
               slice_max(dep_time, n = -3, with_ties = FALSE))

view(flights2)
view(flights)

# It plots all but the max three



# 5. Explain what count() does in terms of the dplyr verbs you just learned. 
# What does the sort argument to count() do?

# Count returns the number of occurrences as n. Sort orders the output descending.

flights |>
  count(origin, dest, sort = TRUE) |>
  print(n = 10)



flights |>
  count(origin, dest, sort = FALSE) |>
  print(n = 10)


# 6. Suppose we have the following tiny data frame:

df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)

# a.

df |>
  group_by(y)

# b. 

df |>
  arrange(y)

# c.

df |>
  group_by(y) |>
  summarize(mean_x = mean(x))

# d.

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

# e.

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")

# f. 

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))

