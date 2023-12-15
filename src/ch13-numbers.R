

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


# 13.3.1 Exercises
How can you use count() to count the number rows with a missing value for a given variable?
  Expand the following calls to count() to instead use group_by(), summarize(), and arrange():
  
  
  



















