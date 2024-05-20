
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


# stringr and tidyr functions -----

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














