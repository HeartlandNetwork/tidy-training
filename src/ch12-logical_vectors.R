
# Ch12 - Logical vectors
#===============================================================================

library(tidyverse)
library(nycflights13)

x <- c(1, 2, 3, 5, 7, 11, 13)
x * 2

df <- tibble(x)
df |> 
  mutate(y = x * 2)

# 12.2 Comparisons -------------------------------------------------------------

# So far, logical variables have been used transiently within filter() 

flights |> 
  filter(dep_time > 600 & dep_time < 2000 & abs(arr_delay) < 20)

# Here, we create the underlying logical variables explicitly 
# with mutate()

flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
    .keep = "used" 
  ) 


# This explicitly shows the first filter above...

flights |> 
  mutate(
    daytime = dep_time > 600 & dep_time < 2000,
    approx_ontime = abs(arr_delay) < 20,
  ) |> 
  filter(daytime & approx_ontime)

# 12.2.1 Floating point comparison----------------------------------------------

# Beware of using == with numbers...

x <- c(1 / 49 * 49, sqrt(2) ^ 2)
x

x == c(1, 2) # This evaluates as FALSE, FALSE

# because x has a round-off error as show here

print(x, digits = 16)

# So, instead, this gives the expected result

near(x, c(1, 2))

# 12.2.2 Missing values --------------------------------------------------------

# Almost any operation involving an unknown value will also be unknown

NA > 5

10 == NA

NA == NA

# More examples...

# We don't know how old Mary is
age_mary <- NA

# We don't know how old John is
age_john <- NA

# Are Mary and John the same age?
age_mary == age_john
#> [1] NA
# We don't know!

# This doesn't work as expected (see below for correct version)

flights |> 
  filter(dep_time == NA)

# need to use is.na()

# 12.2.3 is.na() ---------------------------------------------------------------


# is.na() works with any type of vector

is.na(c(TRUE, NA, FALSE))

is.na(c(1, NA, 3))

is.na(c("a", NA, "b"))

flights |> 
  filter(is.na(dep_time))

# arrange() usually puts all the missing values at the end 
# but you can override this default by first sorting by is.na():

flights |> 
  filter(month == 1, day == 1) |> 
  arrange(dep_time)

flights |> 
  filter(month == 1, day == 1) |> 
  arrange(desc(is.na(dep_time)), dep_time)

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
  


# 12.3 Boolean algebra ---------------------------------------------------------


# 12.3.1 Missing values --------------------------------------------------------

# Missing values in Boolean algebra are a little tricky
# Note that (NA | TRUE) evaluates as TRUE while (NA | FALSE) is NA

df <- tibble(x = c(TRUE, FALSE, NA))

df |> 
  mutate(
    and = x & NA,
    or = x | NA
  )

df$x
 
df$and

df$or

# 12.3.2 Order of operations ---------------------------------------------------

#(month == 11 | 12) # evaluates == first, then |. So (month == 11 | 12) 
                   #   doesn't work

# This code demonstrates order of operations

flights |> 
  filter(month == 10) |>
  mutate( 
    nov = month == 11,
    final = nov | 12,
    .keep = "used"
  )

# 12.3.3 %in% ------------------------------------------------------------------

# x %in% y returns a logical vector the same length as x that is TRUE whenever a 
#   value in x is anywhere in y
  
1:12 %in% c(1, 5, 11)


letters[1:10] %in% c("a", "e", "i", "o", "u")

# filter all the flights in November and December

flights |> 
  filter(month %in% c(11, 12))

# Note that %in% obeys different rules for NA to ==, as NA %in% NA is TRUE.

c(1, 2, NA) == NA

c(1, 2, NA) %in% NA   # <<<<<<<<<<<<<<<<<<<<<<<

flights |> 
  filter(dep_time %in% c(NA, 0800))


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


# 12.4 Summaries ---------------------------------------------------------------

# Using all() and any()

# 12.4.1 Logical summaries -----------------------------------------------------

# For example, use all() and any() to find out if every flight was delayed on 
#   departure by at most an hour or if any flights were delayed on arrival by 
#   five hours or more. And using group_by() allows us to do that by day:


flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = all(dep_delay <= 60, na.rm = TRUE),
    any_long_delay = any(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )

# 12.4.2 Numeric summaries of logical vectors  ---------------------------------

# When you use a logical vector in a numeric context, TRUE becomes 1 and FALSE 
# becomes 0.

# Like all summary functions, they’ll return NA if there are any missing 
# values present, and as usual you can make the missing values go away 
# with na.rm = TRUE.

flights |> 
  group_by(year, month, day) |> 
  summarize(
    all_delayed = mean(dep_delay <= 60, na.rm = TRUE),
    any_long_delay = sum(arr_delay >= 300, na.rm = TRUE),
    .groups = "drop"
  )

# 12.4.3 Logical subsetting ----------------------------------------------------

# To look at the average delay just for flights that were actually delayed. 
# One way to do so would be to first filter the flights and then calculate 
# the average delay

flights |> 
  filter(arr_delay > 0) |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay),
    n = n(),
    .groups = "drop"
  )

# What if we wanted to also compute the average delay for flights 
# that arrived early? Use [ to perform an inline filtering: 
# arr_delay[arr_delay > 0] will yield only the positive arrival delays. The
# method above would require creating two data frames. The inline function
# allows you to do it with just one df. 

flights |> 
  group_by(year, month, day) |> 
  summarize(
    behind = mean(arr_delay[arr_delay > 0], na.rm = TRUE),
    ahead = mean(arr_delay[arr_delay < 0], na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

#  Note: in the first chunk n() gives the number of delayed flights per day; 
# in the second, n() gives the total number of flights.


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


# 12.5 Conditional transformations ---------------------------------------------
  
# Combining logical vectors with if_else() and case_when().

# 12.5.1 if_else() -------------------------------------------------------------

x <- c(-3:3, NA)

if_else(x > 0, "+vector", "-vector")

# Missing is used if the input is NA

if_else(x > 0, "+vector", "-vector", "???")

# Using the vectors for the the true and false arguments

if_else(x < 0, -x, x)

# You could implement a simple version of coalesce() like this

?coalesce

x1 <- c(NA, 1, 2, NA)
y1 <- c(3, NA, 4, 6)
if_else(is.na(x1), y1, x1)

# Dealing with zero in the if_else above

if_else(x == 0, "0", if_else(x < 0, "-ve", "+ve"), "???")


# 12.5.2 case_when() - Use case_when for multiple conditions -------------------


x <- c(-3:3, NA)
case_when(
  x == 0   ~ "0",
  x < 0    ~ "-vector", 
  x > 0    ~ "+vector",
  is.na(x) ~ "???"
)

 # If none of the cases works, the function returns NA 
case_when(
  
  x < 0 ~ "-vector",
  x > 0 ~ "+vector"
)
 
# Or you can assign a default value if nothing matches 

case_when(
  x < 0 ~ "-ve",
  x > 0 ~ "+ve",
  .default = "???"
)

# And note that if multiple conditions match, only the first will be used

case_when(
  x > 0 ~ "+ve",
  x > 2 ~ "big"
)

# you can use variables on both sides of the ~ and you can mix and match 
# variables as needed for your problem

# Note that > and < need to be mutually exclusive hence the <= 

flights |> 
  mutate(
    status = case_when(
      is.na(arr_delay)      ~ "cancelled",
      arr_delay < -30       ~ "very early",
      arr_delay < -15       ~ "early",
      abs(arr_delay) <= 15  ~ "on time",
      arr_delay < 60        ~ "late",
      arr_delay < Inf       ~ "very late",
    ),
    .keep = "used"
  )


# 12.5.3 Compatible types ------------------------------------------------------

# Both if_else() and case_when() require compatible types in the output

# if_else(TRUE, "a", 1)
#> Error in `if_else()`:
#> ! Can't combine `true` <character> and `false` <double>.

#case_when(
#  x < -1 ~ TRUE,  
#  x > 0  ~ now()
#)
#> Error in `case_when()`:
#> ! Can't combine `..1 (right)` <logical> and `..2 (right)` <datetime<local>>.

# These types are compatible...

# Numeric and logical vectors
# Strings and factors
# Dates and date-times
# NA is compatible with everything 


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

































 


