
# Ch15 - Regular Expressions
#===============================================================================

library(tidyverse)
library(babynames)


# 15.2 Pattern basics ----------------------------------------------------------

str_view(fruit, "berry")

str_view(c("a", "ab", "ae", "bd", "ea", "eab"), "a.")

str_view(fruit, "a...e")

# ? makes a pattern optional (i.e. it matches 0 or 1 times)
# + lets a pattern repeat (i.e. it matches at least once)
# * lets a pattern be optional or repeat (i.e. it matches any number of times, including 0).

# ab? matches an "a", optionally followed by a "b".
str_view(c("a", "ab", "abb"), "ab?")

# ab+ matches an "a", followed by at least one "b".
str_view(c("a", "ab", "abb"), "ab+")

# ab* matches an "a", followed by any number of "b"s.
str_view(c("a", "ab", "abb"), "ab*") # note this is broader than * in DOS or Access queries!!


str_view(words, "[aeiou]th[aeiou]")

# invert the match by starting with ^
  
str_view(words, "[^aeiou]oo[^aeiou]")

# | 
# to pick between one or more alternative patterns.

str_view(fruit, "apple|melon|nut")


# 15.3 Key functions -----------------------------------------------------------

# 15.3.1 Detect matches

# str_detect() returns a logical vector 

str_detect(c("a", "b", "c"), "[aeiou]")

#> [1]  TRUE FALSE FALSE



babynames |> 
  filter(str_detect(name, "x")) |> # <<<<< string detect inside filter
  count(name, wt = n, sort = TRUE)

# sum(str_detect(x, pattern)) tells you the number of observations that match 
# and mean(str_detect(x, pattern)) tells you the proportion that match

babynames |> 
  group_by(year) |> 
  summarize(prop_x = mean(str_detect(name, "x"))) |> 
  ggplot(aes(x = year, y = prop_x)) + 
  geom_line()


# 15.3.2 Count matches ---------------------------------------------------------

x <- c("apple", "banana", "pear")
str_count(x, "p")
#> [1] 2 0 1


str_count("abababa", "aba")
#> [1] 2
str_view("abababa", "aba")
#> [1] │ <aba>b<aba>


babynames |> 
  count(name) |> 
  mutate(
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )



# NOTE: regular expressions are case sensitive

# One solution is to convert all letters to lower case...


babynames |> 
  count(name) |> 
  mutate(
    name = str_to_lower(name), # <<<<<<<<<<<<<<<<<<<<<
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )


# 15.3.3 Replace values --------------------------------------------------------
# use with mutate()

x <- c("apple", "pear", "banana")
str_replace_all(x, "[aeiou]", "-")  # <<< replace

x <- c("apple", "pear", "banana")
str_remove_all(x, "[aeiou]")        # <<< remove


# 15.3.4 Extract variables -----------------------------------------------------


df <- tribble(
  ~str,
  "<Sheryl>-F_34",
  "<Kisha>-F_45", 
  "<Brandon>-N_33",
  "<Sharon>-F_38", 
  "<Penny>-F_58",
  "<Justin>-M_41", 
  "<Patricia>-F_84", 
)


df |> 
  separate_wider_regex(
    str,
    patterns = c(
      "<", 
      name = "[A-Za-z]+", 
      ">-", 
      gender = ".",
      "_",
      age = "[0-9]+"
    )
  )








