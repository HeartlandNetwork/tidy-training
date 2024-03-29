
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
  
  
# 1 Compare and contrast the results of paste0() with str_c() for the 
# following inputs:
  
?paste0()

str_c("hi ", NA)
paste0("hi ", NA)

letters

str_c(letters[1:2], letters[1:3])
paste0(letters[1:2], letters[1:3])
  
# 2. What’s the difference between paste() and paste0()? How can you recreate 
# the equivalent of paste() with str_c()?

paste0(1:12)
paste(1:12, " ")  

# paste() allows you to include characters to separate concatenated values. 
# paste0() is the same as paste(..., "", collapse)


    
# 3. Convert the following expressions from str_c() to str_glue() or vice versa:

food <- c("pepperoni pizza")
price <- c("$23.00")
#
    
str_c("The price of ", food, " is ", price)
str_glue("The price of {food} is {price} ")

age <- c(64)
country <- c("the United States")
  
str_glue("I'm {age} years old and live in {country}")
str_c("I'm ", age, " years old and live in ", country)

title <- ("R for Data Science, 2nd edition")
  
str_c("\\section{", title, "}")
str_glue("\\\\section{{{title}}}")
  