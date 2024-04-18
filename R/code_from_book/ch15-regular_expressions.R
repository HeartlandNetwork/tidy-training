
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


# 15.4 Pattern details ---------------------------------------------------------

# escaping, anchors, character classes, quantifiers, operator precedence and 
# parentheses, and grouping components of the pattern


# 15.4.1 Escaping -------------------------------------------------------------

# To create the regular expression \., we need to use \\.
dot <- "\\."
dot

# But the expression itself only contains one \
str_view(dot)


# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

# more escape examples

x <- "a\\b"
str_view(x)

str_view(x, "\\\\")


# raw strings

str_view(x, r"{\\}")

# an alternative to using a backslash escape: you can use a character
# class: [.], [$], [|], … all match the literal values.


str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")



str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")



# 15.4.2 Anchors ---------------------------------------------------------------

# ^ to match the start or $ to match the end:

fruit

str_view(fruit, "^a")

str_view(fruit, "a$")



str_view(fruit, "apple")

str_view(fruit, "^apple$")


# boundary between words with \b

x <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")

x


str_view(x, "sum")

str_view(x, "\\bsum\\b")


# When used alone, anchors will produce a zero-width match

str_view("abc", c("$", "^", "\\b"))


str_replace_all("abc", c("$", "^", "\\b"), "--")


# 15.4.3 Character classes -----------------------------------------------------

# A character class, or character set, allows you to match any character in a set.
# Note: [^abc] matches any character *except* “a”, “b”, or “c”.
# - defines a range, e.g., [a-z] matches any lower case letter and [0-9] matches any number.
# \ escapes special characters, so [\^\-\]] matches ^, -, or ].
# \d matches any digit;
# \D matches anything that isn’t a digit.
# \s matches any whitespace (e.g., space, tab, newline);
# \S matches anything that isn’t whitespace.
# \w matches any “word” character, i.e. letters and numbers;
# \W matches any “non-word” character.

x <- "abcd ABCD 12345 -!@#%."
x

str_view(x, "[abc]+")

str_view(x, "[^a-z0-9]+")

# You need an escape to match characters that are otherwise
# special inside of []

str_view("a-b-c", "[a-c]")

str_view("a-b-c", "[a\\-c]")

# see shortcuts above

x <- "abcd ABCD 12345 -!@#%."
x

# \d matches any digit;
str_view(x, "\\d+")

# \D matches anything that isn’t a digit.
str_view(x, "\\D+")

# \s matches any whitespace (e.g., space, tab, newline);
str_view(x, "\\s+")

# \S matches anything that isn’t whitespace.
str_view(x, "\\S+")

# \w matches any “word” character, i.e. letters and numbers;
str_view(x, "\\w+")

# \W matches any “non-word” character.
str_view(x, "\\W+")


# 15.4.4 Quantifiers -----------------------------------------------------------

# You can also specify the number of matches precisely with {}
# {n} matches exactly n times.
# {n,} matches at least n times.
# {n,m} matches between n and m times.


# 15.4.5 Operator precedence and parentheses ----------------------------------

# quantifiers have high precedence and alternation has low precedence which 
# means that ab+ is equivalent to a(b+), and ^a|b$ is equivalent to (^a)|(b$). 
# Just like with algebra, you can use parentheses to override the usual order. 
# But unlike algebra you’re unlikely to remember the precedence rules for 
# regexes, so feel free to use parentheses liberally.


# 15.4.6 Grouping and capturing ------------------------------------------------

#  back reference: \1 refers to the match contained in the first parenthesis, 
#  \2 in the second parenthesis, and so on

# all fruit that has repeated pairs
str_view(fruit, "(..)\\1")

# all words that start and end with the same pair of letters
str_view(words, "^(..).*\\1$")


# using back references in str_replace()



# this code switches the order of the second and third words in sentences

str_view(sentences)

sentences |> 
  str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") |> 
  str_view()

# extracting the matches for each group using str_match(). 
# Note - str_match() returns a matrix, so it’s not particularly easy 
# to work with











































