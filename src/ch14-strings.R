
# Ch14 - Strings
#===============================================================================

library(tidyverse)
library(babynames)

# 14.2 Creating a string -------------------------------------------------------

string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'


# 14.2.1 Escapes ---------------------------------------------------------------

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

backslash <- "\\"

x <- c(single_quote, double_quote, backslash)
x


str_view(x)



