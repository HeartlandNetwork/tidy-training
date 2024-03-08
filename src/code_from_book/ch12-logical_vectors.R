
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

