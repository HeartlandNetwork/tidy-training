
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
df


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

str_view(x, r"{\\}")


str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")

str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")



# anchors

str_view(fruit, "^a")

str_view(fruit, "a$")


str_view(fruit, "apple")

str_view(fruit, "^apple$")


x <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")
str_view(x, "sum")

str_view(x, "\\bsum\\b")


str_view("abc", c("$", "^", "\\b"))

str_replace_all("abc", c("$", "^", "\\b"), "--")



# character classes or sets

x <- "abcd ABCD 12345 -!@#%."

str_view(x, "[abc]+")

str_view(x, "[a-z]+")

str_view(x, "[^a-z0-9]+")


str_view("a-b-c", "[a-c]")

str_view("a-b-c", "[a\\-c]")


x <- "abcd ABCD 12345 -!@#%."
x

str_view(x, "\\d+")

str_view(x, "\\D+")

str_view(x, "\\s+")

str_view(x, "\\S+")

str_view(x, "\\w+")

str_view(x, "\\W+")


# quantifiers

# ? - zero or one match
# + - one or more matches
# * - zero or more matches
# {n} matches exactly n times.
# {n,} matches at least n times.
# {n,m} matches between n and m times.

# operator precedence

# precedence rules: 
#  quantifiers have high precedence 
#  alternation has low precedence 
#  example:
#    ab+ is equivalent to a(b+), 
#   ^a|b$ is equivalent to (^a)|(b$). 
  
# In general - use parentheses to override the usual order!!


# capturing groups back reference

str_view(fruit, "(..)\\1")

str_view(words, "^(..).*\\1$")

str_view(sentences, "(\\w+) (\\w+) (\\w+)")

sentences |> 
  str_replace("(\\w+) (\\w+) (\\w+)", "\\1 \\3 \\2") |> 
  str_view()


# pattern control --------------------------------------------------------------

# regex flags

bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")

str_view(bananas, regex("banana", ignore_case = TRUE))

x <- "Line 1\nLine 2\nLine 3"
x

str_view(x)

str_view(x, ".Line")

str_view(x, regex(".Line", dotall = TRUE))


x <- "Line 1\nLine 2\nLine 3"
str_view(x, "^Line")

str_view(x, regex("^Line", multiline = TRUE))
###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

phone <- regex(
  r"(
    \(?     # optional opening parens
    (\d{3}) # area code
    [)\-]?  # optional closing parens or dash
    \ ?     # optional space
    (\d{3}) # another three numbers
    [\ -]?  # optional space or dash
    (\d{4}) # four more numbers
  )", 
  comments = TRUE
)

str_extract(c("514-791-8141", "(123) 456 7890", "123456"), phone)
#> [1] "514-791-8141"   "(123) 456 7890" NA




# fixed matches

str_view(c("", "a", "."), fixed("."))


str_view("x X", "X")

str_view("x X", fixed("X", ignore_case = TRUE))



str_view("i İ ı I", fixed("İ", ignore_case = TRUE))

str_view("i İ ı I", coll("İ", ignore_case = TRUE, locale = "tr"))


# practice

# check your work

str_view(sentences, "^The") |>
  print(n = 277)

str_view(sentences, "^The\\b")



# boolean operators
# creating a pattern with code

# regex expressions in other places 
# tidyverse
# base R

# summary














