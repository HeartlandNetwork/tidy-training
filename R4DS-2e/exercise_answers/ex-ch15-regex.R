
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

tel_no <- c( '(417) 732-2662')

str_view(tel_no, "\\(\\d+\\) [0-9]+\\-[0-9]+")


# 15.4.7 Exercises -------------------------------------------------------------
      
# 1, How would you match the literal string "'\" ? How about "$^$"?

ls <- c("\'\\")
ls
str_view(ls)

str_view(ls, "\'\\\\" )   


ls2 <- c("$^$")
ls2
str_view(ls2)

str_view(ls2, "\\$\\^\\$" )   




# 2. Explain why each of these patterns don’t match a \: "\", "\\", "\\\".

str_match(ls, "\\\\")

# \ and \\\ are not valid strings
# \\ does not pick up "\"
  
  # "\\" gives the error - Unrecognized backslash escape sequence in pattern


# 3. Given the corpus of common words in stringr::words, create regular 
# expressions that find all words that:
  
  
#   a. Start with “y”.
  
words |>
  str_view("^y")
  
#   b. Don’t start with “y”.
  
words |>
  str_view("^[^y]") |>
  print( n = 974)
  
  
#   c. End with “x”.

words |>
 str_view("x$")

  
#   d. Are three letters long. (Don’t cheat by using str_length()!)

words |> 
  str_view("^[a-z]{3}\\b") |>
  print(n = 110)


#   e. Have seven letters or more.

words |> 
  str_view("^[a-z]{7}") 


#   f. Contain a vowel-consonant pair.


words |>
  str_view("[aeiou]{1}[^aeiou]{1}")


#   g. Contain at least two vowel-consonant pairs in a row.

words |>
  str_view("[aeiou]{1}[^aeiou]{1}[aeiou]{1}[^aeiou]{1}")


#   h. Only consist of repeated vowel-consonant pairs.   <<<<<<<<<Stopped here

words |>
  str_view("([aeiou]{1}[^aeiou]{1})\\1$") 


str_view(words, "[aeiou]{1}[^aeiou]")



# 4. Create 11 regular expressions that match the British or American spellings 
# for each of the following words: airplane/aeroplane, aluminum/aluminium, 
# analog/analogue, ass/arse, center/centre, defense/defence, donut/doughnut, 
# gray/grey, modeling/modelling, skeptic/sceptic, summarize/summarise. 
# Try and make the shortest possible regex!

# airplane/aeroplane
x <- "airplane"
str_view(x, "ir")
x <- "aeroplane"
str_view(x, "ero")

# aluminum/aluminium
x <- "aluminum"
str_view(x, "nu")
x <- "aluminium"
str_view(x, "niu")

# analog/analogue
x <- "analog"
str_view(x, "g$")
x <- "analogue"
str_view(x, "gue$")

# ass/arse
x <- "ass"
str_view(x, "s$")
x <- "arse"
str_view(x, "e$")

# center/centre
x <- "center"
str_view(x, "r$")
x <- "centre"
str_view(x, "e$")

# defense/defence
x <- "defense"
str_view(x, "se$")
x <- "defence"
str_view(x, "ce$")

# donut/doughnut
x <- "donut"
str_view(x, "on")
x <- "doughnut"
str_view(x, "ou")

# gray/grey
x <- "gray"
str_view(x, "ay$")
x <- "grey"
str_view(x, "ey$")

# modeling/modelling
x <- "modeling"
str_view(x, "eli")
x <- "modelling"
str_view(x, "elli")

# skeptic/sceptic
x <- "skeptic"
str_view(x, "^sk")
x <- "sceptic"
str_view(x, "^sc")

# summarize/summarise
x <- "summarize"
str_view(x, "ze$")
x <- "summarise"
str_view(x, "se$")


# 5. Switch the first and last letters in words. Which of those strings are 
# still words?

words

words |>
  str_view("^.") 

words |>
  str_view(".$") 

sentences |> 
  str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") |> 
  str_view()

words |> 
  str_replace( "(^a)(e$)", "\\2\\1") |> 
  str_view()




#> [1] "-ppl-"  "p--r"   "b-n-n-"

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
      


