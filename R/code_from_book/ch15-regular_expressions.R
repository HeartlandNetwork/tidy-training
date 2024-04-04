
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





  
  

