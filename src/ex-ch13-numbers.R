
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

