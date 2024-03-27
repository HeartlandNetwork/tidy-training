
# Ch14 - Strings
#===============================================================================

library(tidyverse)
library(babynames)


# 14.2 Creating a string -------------------------------------------------------


string1 <- "This is a string"
string1
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
string2

# 14.2.1 Escapes ---------------------------------------------------------------

double_quote <- "\"" # or '"'
double_quote 
single_quote <- '\'' # or "'"
single_quote

backslash <- "\\"
backslash

x <- c(single_quote, double_quote, backslash)
x

str_view(x)

# 14.2.2 Raw strings -----------------------------------------------------------


tricky <- "double_quote <- \"\\\"\" # or '\''
single_quote <- '\\'' # or \"'\""

str_view(tricky)

# using a raw string

tricky <- r"(double_quote <- "\"" # or '"' 
single_quote <- '\'' # or "'")"
str_view(tricky)

# 14.2.3 Other special characters ----------------------------------------------

# \u or \U for unicode

x <- c("one\ntwo", "one\ttwo", "\u00b5", "\U0001f604")
x
str_view(x)


# 14.3 Creating many strings from data -----------------------------------------

# 14.3.1 str_c() ---------------------------------------------------------------

str_c("x", "y")

str_c("x", "y", "z")

str_c("Hello ", c("John", "Susan"))



df <- tibble(name = c("Flora", "David", "Terra", NA))
df
df |> mutate(greeting = str_c("Hi ", name, "!"))


# use coalesce() to replace missing values either inside or outside of str_c()

df |> 
  mutate(
    greeting1 = str_c("Hi ", coalesce(name, "you"), "!"),
    greeting2 = coalesce(str_c("Hi ", name, "!"), "Hi!")
  )

# 14.3.2 str_glue() ------------------------------------------------------------

df <- tibble(name = c("Flora", "David", "Terra", NA))

df |> mutate(greeting = str_glue("{{Hi {name}!}}"))


# 14.3.3 str_flatten() ---------------------------------------------------------

str_flatten(c("x", "y", "z"))

str_flatten(c("x", "y", "z"), ", ")

str_flatten(c("x", "y", "z"), ", ", last = ", and ")


# str_flatten() with summarize()

df <- tribble(
  ~ name, ~ fruit,
  "Carmen", "banana",
  "Carmen", "apple",
  "Marvin", "nectarine",
  "Terence", "cantaloupe",
  "Terence", "papaya",
  "Terence", "mandarin"
)

df |>
  group_by(name) |> 
  summarize(fruits = str_flatten(fruit, ", "))


# 14.4 Extracting data from strings --------------------------------------------

# df |> separate_longer_delim(col, delim)
# df |> separate_longer_position(col, width)
# df |> separate_wider_delim(col, delim, names)
# df |> separate_wider_position(col, widths)

# 14.4.1 Separating into rows --------------------------------------------------

df1 <- tibble(x = c("a,b,c", "d,e", "f"))
df1 |> 
  separate_longer_delim(x, delim = ",")


df2 <- tibble(x = c("1211", "131", "21"))
df2 |> 
  separate_longer_position(x, width = 1)


# 14.4.2 Separating into columns -----------------------------------------------

df3 <- tibble(x = c("a10.1.2022", "b10.2.2011", "e15.1.2015"))
df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", "edition", "year")
  )


# omitting a column using NA

df3 |> 
  separate_wider_delim(
    x,
    delim = ".",
    names = c("code", NA, "year") # note location of NA
  )

# wider position uses a named vector with widths

df4 <- tibble(x = c("202215TX", "202122LA", "202325CA")) 
df4 |> 
  separate_wider_position(
    x,
    widths = c(year = 4, age = 2, state = 2)
  )

# 14.4.3 Diagnosing widening problems ------------------------------------------


# not enough pieces ------------------------------------------------------------


df <- tibble(x = c("1-1-1", "1-1-2", "1-3", "1-3-2", "1"))

# The code below throws an error because two of the values were too short

#  df |> 
#    separate_wider_delim(
#      x,
#      delim = "-",
#       names = c("x", "y", "z"
#      )
#   )

# the error message is below the code

#  Error in `separate_wider_delim()`:
#  ! Expected 3 pieces in each element of `x`.
#  ! 2 values were too short.
#  ℹ Use `too_few = "debug"` to diagnose the problem.
#  ℹ Use `too_few = "align_start"/"align_end"` to silence this message.
#  Run `rlang::last_trace()` to see where the error occurred.

# Implementing the debug code

debug <- df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "debug"   # <<<<<<<<<<<<<<<<<<<<<
  )
debug

# filter out 'not okay'

debug |> filter(!x_ok)


# fill in the missing pieces with NAs 

df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "align_start"
  )



# too many pieces --------------------------------------------------------------

df <- tibble(x = c("1-1-1", "1-1-2", "1-3-5-6", "1-3-2", "1-3-5-7-9"))

#df |> 
#  separate_wider_delim(
#    x,
#    delim = "-",
#    names = c("x", "y", "z")
#  )

# throws error

#Error in `separate_wider_delim()`:
#  ! Expected 3 pieces in each element of `x`.
#! 2 values were too long.
#ℹ Use `too_many = "debug"` to diagnose the problem.
#ℹ Use `too_many = "drop"/"merge"` to silence this message.
#Run `rlang::last_trace()` to see where the error occurred.

debug <- df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "debug"
  )

debug |> filter(!x_ok)

# two options


df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "drop"    # <<<<<<<<<<<<<<<<<<<
  )



df |> 
  separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_many = "merge"   # <<<<<<<<<<<<<<<<<<<
  )


# 14.5 Letters -----------------------------------------------------------------


str_length(c("a", "R for data science", NA))

babynames |>
  count(length = str_length(name), wt = n)

babynames |> 
  filter(str_length(name) == 15) |> 
  count(name, wt = n, sort = TRUE)

# 14.5.2 Subsetting

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

# negative values count from the back of the string

str_sub(x, -3, -1)

# too short handles without error

str_sub("a", 1, 5)


df <- babynames |> 
  mutate(
    first = str_sub(name, 1, 1),
    last = str_sub(name, -1, -1)
  )

glimpse(df)


















