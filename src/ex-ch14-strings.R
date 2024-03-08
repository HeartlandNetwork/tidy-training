
# Ch14 - Strings
#===============================================================================

library(tidyverse)
library(babynames)

# 14.2.4 Exercises -------------------------------------------------------------

# 1. Create strings that contain the following values:
  
#   1. He said "That's amazing!"

my_string <- 'He said "That\'s amazing!"'
my_string2 <- str_view(my_string)
my_string2


#   2. \a\b\c\d

my_string <- "\\a\\b\\c\\d"
my_string2 <- str_view(my_string)
my_string2

#   3. \\\\\\

my_string <- "\\\\\\\\\\\\"
my_string2 <- str_view(my_string)
my_string2

# 2. Create the string in your R session and print it. What happens to the 
# special “\u00a0”? How does str_view() display it? Can you do a little 
# googling to figure out what this special character is?
  
  x <- "This\u00a0is\u00a0tricky"
  str_view(x)
  x
  
  # 00a0 is unicode for "No Break Space"
  # It prevents an automatic line break in word processing software
  
  
  
# 14.3.4 Exercises -------------------------------------------------------------
  
  
  
  