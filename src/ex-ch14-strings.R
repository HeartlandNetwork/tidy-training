
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
  
# ?paste0()

str_c("hi ", NA)
paste0("hi ", NA)
  
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


# 14.5.3. Exercises -------------------------------------------------------------

# 1. When computing the distribution of the length of babynames, why did we 
# use wt = n?

# wt = n was used with the count() function
# https://dplyr.tidyverse.org/reference/count.html

# from the reference above - wt to perform weighted counts, switching the 
# summary from n = n() to n = sum(wt).


# 2. Use str_length() and str_sub() to extract the middle letter from each 
# baby name. What will you do if the string has an even number of characters?

# the solution below uses integer division to locate the mid letter


babynames |> 
  mutate(
    name_length = str_length(name),
    ml = as.integer(name_length/2) + 1,
    mid_letter = str_sub(name, ml, ml)
  )



# 3. Are there any major trends in the length of babynames over time? What 
#    about the popularity of first and last letters? 

# The length of baby names increases with time

df <- babynames |> 
  mutate(
    name_length = str_length(name),
    first = str_sub(name, 1, 1),
    last = str_sub(name, -1, -1)
  )
df

#----------- name_length

rand_df = df[sample(nrow(df), 10000), ]

glimpse(rand_df)

rand_df |>
  group_by(year) |>
  summarize(
    max_name_length = max(name_length, na.rm = TRUE),
    .groups = "drop"
  ) |>
  ggplot(aes(x = year, y = max_name_length)) +
    geom_line()

# ------------------------------------------------

# first and last letters trends


period <- function(year){
  case_when(
    year < 1940 & year >= 1800 ~ "A",
    year < 1980 & year >= 1940 ~ "B",
    year < 2000 & year >= 1980 ~ "C",
    year >= 2000 ~ "D"
  )
}

rand_df <- rand_df |>
  mutate(
    period_group = period(year)
  )
rand_df

df <- rand_df |> 
  group_by(first) |>
  summarize(
    n = n(),
    propA = sum(period_group == 'A')/n,
    propB = sum(period_group == 'B')/n,
    propC = sum(period_group == 'C')/n,
    propD = sum(period_group == 'D')/n
  ) |>
  pivot_longer(
    cols = starts_with(("prop")),
    names_to = "time_group",
    values_to = "group_proportion"
  )

glimpse(df)

# display this with color blind ggthemes

library(ggtheme)


ggplot(df, aes(x = first, y = group_proportion, color = time_group)) +  
  geom_point() 




  