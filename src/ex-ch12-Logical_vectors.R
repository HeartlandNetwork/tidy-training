
# Ch12 - Logical vectors
#===============================================================================

library(tidyverse)
library(nycflights13)


# 12.2.4 Exercises
# 1. How does dplyr::near() work? Type near to see the source code. 
# Is sqrt(2)^2 near 2?

# It sets the tolerance at.Machine$double.eps^0.5 which is half the machine's
#  precision for double. Then, if the absolute difference between the two values
# is less than that, it accepts the two numbers as being near each other.

near

near(2,sqrt(2)^2) # evaluates as TRUE so yes, these two numbers are 
                  # near each other

# 2. Use mutate(), is.na(), and count() together to describe how the missing 
# values in dep_time, sched_dep_time and dep_delay are connected.

# If departure time is unknown, departure delay is unknown and so is any 
# calculation involving departure time.

flights |> 
  select(dep_time, sched_dep_time, dep_delay) |>
  mutate(flight_delay = dep_time - sched_dep_time) |>
  filter(is.na(dep_time)) |>
  count()
  



# 12.3.4 Exercises -------------------------------------------------------------

# 1. Find all flights where arr_delay is missing but dep_delay is not. Find all 
#   flights where neither arr_time nor sched_arr_time are missing, 
#   but arr_delay is.

flights |>
  select(arr_delay, dep_delay) |>
  filter((arr_delay %in% c(NA))  & (!(dep_delay %in% c(NA))))

flights |>
  select(arr_time, sched_arr_time) |>
  filter((!(arr_time %in% c(NA)))  & (!(sched_arr_time %in% c(NA))))


# 2. How many flights have a missing dep_time? What other variables are missing 
#      in these rows? What might these rows represent?

# There are 8,255 rows with dep_time missing.
# They are cancelled flights

f <- flights |>
  filter(dep_time %in% c(NA))
  
view(f)


# 3. Assuming that a missing dep_time implies that a flight is cancelled, 
#   look at the number of cancelled flights per day. Is there a pattern? 
#   Is there a connection between the proportion of cancelled flights and 
#   the average delay of non-cancelled flights?

#  Not a lot of pattern by day, some days have a lot of cancelled flights
#    others don't
#  The number of cancelled flights is highly correlated 
#    with average number of delays on a given day

cancelled <- flights |>
  select(day,dep_time) |>
  filter(dep_time %in% c(NA)) |>
  group_by(day) |>
  summarize(
    cancelled_flights = n()
  ) |>
  print(n = 31)
   
delay <- flights |>
  filter(dep_delay > 0) |>
  select(day, dep_delay) |> 
  group_by(day) |>
  summarize(
    ave_delay = mean(dep_delay)
  ) |>
  print(n = 31)
  
f <- cancelled |>
  left_join(delay) |>
  print(n = 31)
  
ggplot(f, aes( x = log10(cancelled_flights), ave_delay)) +
  geom_point() +
  geom_smooth(method = "lm")

cor(log10(f$cancelled_flights), f$ave_delay)




# 12.4.4 Exercises -------------------------------------------------------------

# 1. What will sum(is.na(x)) tell you? How about mean(is.na(x))?

# sum(is.na(x)) tells you the count of NAs. mean(is.na(x)) tells you the
# proportion of NAs.
  

# 2. What does prod() return when applied to a logical vector? What logical 
# summary function is it equivalent to? What does min() return when applied 
# to a logical vector? What logical summary function is it equivalent to? 
# Read the documentation and perform a few experiments.

# prod() returns the product of the members of a logical vector. I think its
# equivalent to & (and). min() probably returns the lowest value of a 
# logical vector which would typically be 0. It would be equivalent to | (or). 

help(prod)

help(min)

prod(c(TRUE, TRUE)) # is 1

prod(c(TRUE, FALSE)) # is 0

prod(c(FALSE, FALSE)) # is 0

min(c(TRUE, TRUE)) # is 1

min(c(TRUE, FALSE)) # is 0

min(c(FALSE, FALSE)) # is 0



# 12.5.4 Exercises

# 1. A number is even if it’s divisible by two, which in R you can find out 
# with x %% 2 == 0. Use this fact and if_else() to determine whether each 
# number between 0 and 20 is even or odd.

x <- c(0:20)

if_else(x %% 2 == 0, "TRUE", "FALSE")



# 2. Given a vector of days like x <- c("Monday", "Saturday", "Wednesday"), 
# use an ifelse() statement to label them as weekends or weekdays.

day <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")

day

if_else( day == "Saturday" | day == "Sunday", "weekend", "weekday")


# 3. Use ifelse() to compute the absolute value of a numeric vector called x.

x <- c(-2:2)

x

if_else(x < 0, abs(x), x)


# 4. Write a case_when() statement that uses the month and day columns from 
# flights to label a selection of important US holidays (e.g., New Years 
# Day, 4th of July, Thanksgiving, and Christmas). First create a logical 
# column that is either TRUE or FALSE, and then create a character column 
# that either gives the name of the holiday or is NA.

flights$month
flights$day

case_when(
  (flights$month == 12) & (flights$day == 25) ~ "-ve", # Christmas
  x > 0 ~ "+ve", # New Year's Day
  .default = NA 4th of July
)


