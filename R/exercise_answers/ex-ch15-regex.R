
# Ch15 - Regular Expressions
#===============================================================================

library(tidyverse)
library(babynames)


# 15.3.5 Exercises -------------------------------------------------------------


#  1. What baby name has the most vowels? What name has the highest proportion of 
#  vowels? (Hint: what is the denominator?)

df <- babynames |> 
  count(name) |> 
  mutate(
    name = str_to_lower(name),
    vowels = str_count(name, "[aeiou]"),
  ) |>
 arrange(desc(vowels))
df



df <- df |>
  mutate(
    prop_vowels = vowels / n
  )|>
  arrange(desc(vowels))
df



#  2. Replace all forward slashes in "a/b/c/d/e" with backslashes. What happens if 
#   you attempt to undo the transformation by replacing all backslashes with 
#   forward slashes? (We’ll discuss the problem very soon.)

my_string <- c("a/b/c/d/e")

my_string <- str_replace_all(my_string, "//", "\\") 

# This throughs the error below...

my_string <- str_replace_all(my_string, "\\", "//")

# Error in stri_replace_all_regex(string, pattern, fix_replacement(replacement),  : 
#      Unrecognized backslash escape sequence in pattern. (U_REGEX_BAD_ESCAPE_SEQUENCE, context=`\`)


#  3. Implement a simple version of str_to_lower() using str_replace_all().

#  4. Create a regular expression that will match telephone numbers as commonly 
#  written in your country.


