



# Ch16 - Factors
#===============================================================================


library(tidyverse)

# 16.3.1 Exercises -------------------------------------------------------------

# 1. Explore the distribution of rincome (reported income). What makes the default 
# bar chart hard to understand? How could you improve the plot?

# bar chart of rincome is hard to read since the value of the bars is
# neither increasing or decreasing

ggplot(gss_cat, aes(x = rincome)) +
  geom_bar()

# this makes it easier to understand

ggplot(gss_cat, aes(x = fct_infreq(rincome))) +
  geom_bar()


# 2. What is the most common relig in this survey? What’s the most common partyid?

glimpse(gss_cat)

# religion - Protestant

ggplot(gss_cat, aes(x = fct_infreq(relig))) +
  geom_bar()

# partyid

ggplot(gss_cat, aes(x = fct_infreq(partyid))) +
  geom_bar()
  
# 3. Which relig does denom (denomination) apply to? How can you find out with a 
# table? How can you find out with a visualization?

glimpse(gss_cat)

# Denomination only applies to Protestant 

df <- gss_cat |>
  group_by(relig, denom) |>
  count() |>
  print( n = 47)
  
df

ggplot(df, aes(x = relig, y = denom)) +
  geom_point()


# 16.4.1 Exercises -------------------------------------------------------------
# 1. There are some suspiciously high numbers in tvhours. Is the mean a 
# good summary?

# the mean is not a good summary because the distribution is skewed towards 
# very high values

glimpse(gss_cat)

ggplot(gss_cat, aes(x = tvhours)) +
  geom_histogram(binwidth = 0.5)

log_tvhours <- log10(tvhours)

ggplot(gss_cat, aes(x = log_tvhours)) +
  geom_histogram(binwidth = 0.5)


  
# 2. For each factor in gss_cat identify whether the order of the levels is 
# arbitrary or principled.

# 3. Why did moving “Not applicable” to the front of the levels move it to the 
# bottom of the plot?
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  