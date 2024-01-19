

# Ch13 - Numbers
#===============================================================================

library(tidyverse)
library(nycflights13)

# 13.2 Making numbers ----------------------------------------------------------

# Use parse_double() when you have numbers that have been written as strings

x <- c("1.2", "5.6", "1e3")
parse_double(x)

# Use parse_number() when the string contains non-numeric text that 
# you want to ignore. 

x <- c("$1,234", "USD 3,513", "59%")
parse_number(x)

# 13.3 Counts ------------------------------------------------------------------

flights |> 
  count(dest) |>
  print(n = 105)

# Sort is commonly used with count ---------------------------------------------

flights |> count(dest, sort = TRUE)


# An alternate way to get count ------------------------------------------------
# Works well with other summarize functions
# n() only works inside dplyr verbs

flights |> 
  group_by(dest) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  )

# n_distinct(x) counts the number of distinct (unique) values of one 
# or more variables

flights |> 
  group_by(dest) |> 
  summarize(carriers = n_distinct(carrier)) |> 
  arrange(desc(carriers))

# A weighted count is a sum...

flights |> 
  group_by(tailnum) |> 
  summarize(miles = sum(distance))

# Another way to say the same thing...

flights |> count(tailnum, wt = distance)



# 13.4 Numeric transformations -------------------------------------------------

# 13.4.1  Arithmetic and recycling rules ---------------------------------------

x <- c(1, 2, 10, 20)

x / 5

# is shorthand for

x / c(5, 5, 5, 5)

# The longer vector is recycled over the shorter one. Note the warning...

x

x * c(1, 2)

x * c(1, 2, 3)

# Applied to logical comparisons 

# Trying to find flights in January and February
# This doesn't work...

flights |> 
  filter(month == c(1, 2)) |>
  view()

# Because of the recycling rules it finds flights in odd numbered rows that 
# departed in January and flights in even numbered rows that departed in 
# February. And unfortunately there’s no warning because flights has an 
# even number of rows.

flights |> 
  filter(month < 3) |>
  view()

# 13.4.2 Minimum and maximum ---------------------------------------------------

df <- tribble(
  ~x, ~y,
  1,  3,
  5,  2,
  7, NA,
)

# working with pairs

df |> 
  mutate(
    min = pmin(x, y, na.rm = TRUE),
    max = pmax(x, y, na.rm = TRUE)
  )

# working across all values

df |> 
  mutate(
    min = min(x, y, na.rm = TRUE),
    max = max(x, y, na.rm = TRUE)
  )

# 13.4.3 Modular arithmetic ------------------------------------------------------
  
# %/% does integer division and %% computes the remainder

1:10 %/% 3

1:10 %% 3

flights |> 
  mutate(
    hour = sched_dep_time %/% 100,
    minute = sched_dep_time %% 100,
    .keep = "used"
  )


flights |> 
  group_by(hour = sched_dep_time %/% 100) |> 
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n()) |> 
  filter(hour > 1) |> 
  ggplot(aes(x = hour, y = prop_cancelled)) +
  geom_line(color = "grey50") + 
  geom_point(aes(size = n))


# 13.4.4 Logarithms ------------------------------------------------------------

# log(), log2(), log10()

# inverse: exp(), 2^, 10^
 
# 13.4.5 Rounding --------------------------------------------------------------

round(123.456)

round(123.456, 2)  # two digits

round(123.456, 1)  # one digit#> [1] 123.5

round(123.456, -1) # round to nearest ten

round(123.456, -2) # round to nearest hundred

# round() uses what’s known as “round half to even”

round(c(1.5, 2.5))

# round() is paired with floor() which always rounds down and ceiling() which 
# always rounds up:

x <- 123.456

floor(x)

ceiling(x)

# Round to nearest multiple of 4

round(x / 4) * 4

# Round to nearest 0.25

round(x / 0.25) * 0.25

# 13.4.6 Cutting numbers into ranges - Use cut() to break up (aka bin) a 
# numeric vector into discrete buckets: ----------------------------------------

x <- c(1, 2, 5, 10, 15, 20)
cut(x, breaks = c(0, 5, 10, 15, 20))

# The breaks don’t need to be evenly spaced:

cut(x, breaks = c(0, 5, 10, 100))

# You can optionally supply your own labels.

cut(x, 
    breaks = c(0, 5, 10, 15, 20), 
    labels = c("sm", "md", "lg", "xl")
)

# Any values outside of the range of the breaks will become NA:

y <- c(NA, -10, 5, 10, 30)
cut(y, breaks = c(0, 5, 10, 15, 20))

# 13.4.7 Cumulative and rolling aggregates -------------------------------------

x <- 1:10
cumsum(x)

cumprod(x)

cummin(x)

cummax(x)


# 3.5 General transformations --------------------------------------------------

# 3.5.1 Ranks ------------------------------------------------------------------

x <- c(1, 2, 2, 3, 4, NA)
min_rank(x)                  # deals with ties

min_rank(desc(x)) # descending

# Other rank-related functions


df <- tibble(x = x)
df |> 
  mutate(
    row_number = row_number(x),
    dense_rank = dense_rank(x),
    percent_rank = percent_rank(x),
    cume_dist = cume_dist(x)
  )


# dividing data into equal size groups

df <- tibble(id = 1:10)

df

df |> 
  mutate(
    row0 = row_number() - 1,
    three_groups = row0 %% 3, 
    three_in_each_group = row0 %/% 3 
  )


# 13.5.2 Offsets ---------------------------------------------------------------

# referring to value before or after "current" value

x <- c(2, 5, 11, 11, 19, 35)
lag(x)

# the difference between the current and previous value 

x - lag(x)

# when the current value changes 

x

x == lag(x)

# 13.5.3 Consecutive identifiers -----------------------------------------------


# Handling time as events - e.g., imagine you have the times when someone 
# visited a website:

events <- tibble(
  time = c(0, 1, 2, 3, 5, 10, 12, 15, 17, 19, 20, 27, 28, 30)
)


events <- events |> 
  mutate(
    diff = time - lag(time, default = first(time)),
    has_gap = diff >= 5
  )
events

# In order to use group_by

events |> mutate(
  group = cumsum(has_gap)
)

# Another approach for creating grouping variables is consecutive_id()

df <- tibble(
  x = c("a", "a", "a", "b", "c", "c", "d", "e", "a", "a", "b", "b"),
  y = c(1, 2, 3, 2, 4, 1, 3, 9, 4, 8, 10, 199)
)

df

df |> 
  group_by(id = consecutive_id(x)) |> 
  slice_head(n = 1)





























