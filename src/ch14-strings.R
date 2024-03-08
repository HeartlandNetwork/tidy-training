
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




