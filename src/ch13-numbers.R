

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



# 3.6. Numeric Summaries -------------------------------------------------------

# 13.6.1. Center ----------------------------------------------------------------

# means work well with symmetric distributions. medians are less sensitive to
# outliers. The following compares meansto median departure delay for each
# departure destination

flights |>
  group_by(year, month, day) |>
  summarize(
    mean = mean(dep_delay, na.rm = TRUE),
    median = median(dep_delay, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) |> 
  ggplot(aes(x = mean, y = median)) + 
  geom_abline(slope = 1, intercept = 0, color = "white", linewidth = 2) +
  geom_point()


# 13.6.2. Minimum, maximum and quartiles ---------------------------------------

# Looking at flight delays, comparing the 95% quantile of delays vs. the maximum
# delays. The 95% quartile trims off the 5% extreme values.

flights |>
  group_by(year, month, day) |>
  summarize(
    max = max(dep_delay, na.rm = TRUE),
    q95 = quantile(dep_delay, 0.95, na.rm = TRUE),
    .groups = "drop"
  )

# 13.6.3. Spread ---------------------------------------------------------------
# This includes sd() but also a less familiar one called IQR() or inter-quartile 
# range IQR() which is the quantile(x, 0.75) - quantile(x, 0.25) and gives you 
# the range that contains the middle 50% of the data.

# the code below reveals a data oddity for airport EGE...

flights |> 
  group_by(origin, dest) |> 
  summarize(
    distance_iqr = IQR(distance), 
    n = n(),
    .groups = "drop"
  ) |> 
  filter(distance_iqr > 0)

# EGE is Eagle County Regional Airport in Colorado. It is in an extremely 
# mountainous part of the state with high winds and high elevation, has high 
# traffic and has just one 9000 ft. runway...
# You might expect the spread of the distance between origin and destination 
# to be zero, since airports are always in the same place. Does the distance_iqr
# at EGE result from having one very long runway? Its 1.7 miles in length.

# 13.6.4 Distributions ---------------------------------------------------------

# looking at skewness in departure delay

flights |> 
  filter(dep_delay < 200) |>
  ggplot(aes(dep_delay)) +
  geom_histogram()

# 365 frequency polygons of dep_delay, one for each day, are overlaid

flights |>
  filter(dep_delay < 120) |> 
  ggplot(aes(x = dep_delay, group = interaction(day, month))) + 
  geom_freqpoly(binwidth = 5, alpha = 1/5)


# 13.6.5 Positions -------------------------------------------------------------

# Extracting a value at a specific position: first(x), last(x), and nth(x, n).
# For example, we can find the first, fifth and last departure for each day

flights |> 
  group_by(year, month, day) |> 
  summarize(
    first_dep = first(dep_time, na_rm = TRUE), 
    fifth_dep = nth(dep_time, 5, na_rm = TRUE),
    last_dep = last(dep_time, na_rm = TRUE)
  ) |>
  print(n = 365)

# Extracting values at positions is complementary to filtering on ranks. 
# Filtering gives you all variables, with each observation in a separate 
# row:

flights |> 
  group_by(year, month, day) |> 
  mutate(r = min_rank(sched_dep_time)) |> 
  filter(r %in% c(1, max(r))) |>
  view()

# 13.6.6 With mutate() ---------------------------------------------------------

# x / sum(x) calculates the proportion of a total.
# (x - mean(x)) / sd(x) computes a Z-score (standardized to mean 0 and sd 1).
# (x - min(x)) / (max(x) - min(x)) standardizes to range [0, 1].
# x / first(x) computes an index based on the first observation.

# mutate() vs summarize() - mutate creates new columns, while summarize collapses
# columns to include only the summary.

















