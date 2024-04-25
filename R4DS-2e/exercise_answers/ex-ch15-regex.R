
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

# This throws the error below...

# my_string <- str_replace_all(my_string, "\\", "//")

# Error in stri_replace_all_regex(string, pattern, fix_replacement(replacement),  : 
#      Unrecognized backslash escape sequence in pattern. (U_REGEX_BAD_ESCAPE_SEQUENCE, context=`\`)


#  3. Implement a simple version of str_to_lower() using str_replace_all().

my_string <- c("This is My String")

str_replace_all(my_string, "[A-Z]", tolower)


#  4. Create a regular expression that will match telephone numbers as commonly 
#  written in your country.

# <<<<<<<<<<<<<<< come back to this...










)

# 15.4.7 Exercises -------------------------------------------------------------
      
# 1, How would you match the literal string "'\? How about "$^$"?

# 2. Explain why each of these patterns don’t match a \: "\", "\\", "\\\".

# 3. Given the corpus of common words in stringr::words, create regular 
# expressions that find all words that:

#   a. Start with “y”.
#   b. Don’t start with “y”.
#   c. End with “x”.
#   d. Are exactly three letters long. (Don’t cheat by using str_length()!)
#   e. Have seven letters or more.
#   f. Contain a vowel-consonant pair.
#   g. Contain at least two vowel-consonant pairs in a row.
#   h. Only consist of repeated vowel-consonant pairs.

# 4. Create 11 regular expressions that match the British or American spellings 
# for each of the following words: airplane/aeroplane, aluminum/aluminium, 
# analog/analogue, ass/arse, center/centre, defense/defence, donut/doughnut, 
# gray/grey, modeling/modelling, skeptic/sceptic, summarize/summarise. 
# Try and make the shortest possible regex!

# 5. Switch the first and last letters in words. Which of those strings are 
# still words?

# 6. Describe in words what these regular expressions match: (read carefully 
# to see if each entry is a regular expression or a string that defines a regular expression.)

#   a. ^.*$
#   b. "\\{.+\\}"
#   c. \d{4}-\d{2}-\d{2}
#   d. "\\\\{4}"
#   e. \..\..\..
#   f. (.)\1\1
#   g. "(..)\\1"
      
# 7 Solve the beginner regexp crosswords at https://regexcrossword.com/challenges/beginner.
      


