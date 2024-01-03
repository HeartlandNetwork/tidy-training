

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


































