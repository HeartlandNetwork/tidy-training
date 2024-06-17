



# Ch16 - Factors
#===============================================================================


library(tidyverse)

# 16.3.1 Exercises

# Explore the distribution of rincome (reported income). What makes the default 
# bar chart hard to understand? How could you improve the plot?

# bar chart of rincome is hard to read since the value of the bars is
# neither increasing or decreasing

ggplot(gss_cat, aes(x = rincome)) +
  geom_bar()

# this makes it easier to understand

ggplot(gss_cat, aes(x = fct_infreq(rincome))) +
  geom_bar()


# What is the most common relig in this survey? What’s the most common partyid?

glimpse(gss_cat)

# religion - Protestant

ggplot(gss_cat, aes(x = fct_infreq(relig))) +
  geom_bar()

# partyid

ggplot(gss_cat, aes(x = fct_infreq(partyid))) +
  geom_bar()
  
# Which relig does denom (denomination) apply to? How can you find out with a 
# table? How can you find out with a visualization?


