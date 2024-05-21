
# Ch15 - Regular Expressions
#===============================================================================


# regex terminology -----

  # prerequisites
    # tidyverse
    # babynames
    # stringr char vectors
      # fruit
      # words
      # sentences

  # key functions
    # str_detect()
    # str_count()
    # str_replace() and str_replace_all()
    # extract variables
      # separate_wider_regex()
      # separate_wider_delim()
      # separate_wider_position()

  # pattern details
    # escaping  
    # anchors
    # character classes or sets
    # quantifiers
    # operator precedence
    # grouping and capturing
      # capturing groups
      # back reference

  # pattern control
    # regex flags
      # flags
    # fixed matches
  
  # practice
    # check your work
    # boolean operators
    # creating a pattern with code
    
  # regex expressions in other places 
    # tidyverse
    # base R

  # summary


# prerequisites ----------------------------------------------------------------
# tidyverse
# babynames

library(tidyverse)
library(babynames)


# stringr char vectors
# fruit
# words
# sentences

fruit

words

sentences

# pattern basics ---------------------------------------------------------------

# literal characters 

str_view(fruit, "berry")


# metacharacters 

# ., +, *, [, ], and ?

str_view(c("a", "ab", "ae", "bd", "ea", "eab"), "a.")

str_view(fruit, "a...e")

# quantifiers 

# ab? matches an "a", optionally followed by a "b".
str_view(c("a", "ab", "abb"), "ab?")

# ab+ matches an "a", followed by at least one "b".
str_view(c("a", "ab", "abb"), "ab+")


# ab* matches an "a", followed by any number of "b"s.
str_view(c("a", "ab", "abb"), "ab*")

# character classes 
# character classes are defined by []

str_view(words, "[aeiou]x[aeiou]")

# except [^abcd]

str_view(words, "[^aeiou]y[^aeiou]")


# alternation

str_view(fruit, "apple|melon|nut")


# stringr and tidyr functions -------------------------------------------------

# str_detect() 

str_detect(c("a", "b", "c"), "[aeiou]")

babynames |> 
  filter(str_detect(name, "x")) |> 
  count(name, wt = n, sort = TRUE)

babynames |> 
  group_by(year) |> 
  summarize(prop_x = mean(str_detect(name, "x"))) |> 
  ggplot(aes(x = year, y = prop_x)) + 
  geom_line()


# str_count()

x <- c("apple", "banana", "pear")
str_count(x, "p")

str_count("abababa", "aba")

babynames |> 
  count(name) |> 
  mutate(
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

babynames |> 
  count(name) |> 
  mutate(
    name = str_to_lower(name),
    vowels = str_count(name, "[aeiou]"),
    consonants = str_count(name, "[^aeiou]")
  )

# str_replace() and str_replace_all()

x <- c("apple", "pear", "banana")
str_replace_all(x, "[aeiou]", "-")

x <- c("apple", "pear", "banana")
str_remove_all(x, "[aeiou]")

# extract variables

# separate_wider_regex()

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

# separate_wider_delim()
# separate_wider_position()


# pattern details --------------------------------------------------------------
# escaping  

dot <- "\\."

str_view(dot)

str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
str_view(x)

str_view(x, "\\\\")

# escaping with raw strings

str_view(x, r"{\\}")

# matching literals without escaping with []
# for ., $, |, *, +, ?, {, }, (, )

str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")

str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")

# anchors






# character classes or sets
# quantifiers
# operator precedence
# grouping and capturing
# capturing groups
# back reference

# pattern control
# regex flags
# flags
# fixed matches

# practice
# check your work
# boolean operators
# creating a pattern with code

# regex expressions in other places 
# tidyverse
# base R

# summary














