
## Ch16 - Factors
#===============================================================================

library(tidyverse)

?forcats

# factor basics --------------------------------------------------------------

x1 <- c("Dec", "Apr", "Jan", "Mar")

x1

x2 <- c("Dec", "Apr", "Jam", "Mar") # NOTE: typo for Jan

x2

sort(x1)  # this sort order is not useful, so use catagories

# need levels to control order

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

month_levels

# use factor() to create levels

y1 <- factor(x1, levels = month_levels)

y1

# now when you sort y1, you get the correct order

sort(y1)  # unused levels are silect NAs

# note the typo for Jan is Jam

y2 <- factor(x2, levels = month_levels)

y2  # note the NA for "Jam"

sort(y2)

# The mismatch silenty drops out
# Get better error messages using forcats::fct()

y2 <- fct(x2, levels = month_levels)

# Throws exception because all values of x2 must
# match the levels

# using factors without levels...
# just get alphabetical order, which may be computer dependent

factor(x1)

# so forcats always lists in order of appearance

fct(x1)

# Accessing the level directly


levels(y2)

# creating a factor while reading data using col_factor()

csv <- "
month, values
Jan, 12
Feb, 56
Mar, 12"

csv 

df <- read_csv(csv, col_types = cols(month = col_factor(month_levels)))

df$month



# General Social Survey ------------------------------------------------------
# NORC (Natl Opinion Research Center) University of Chicago
# gss_cat - small data subset

forcats::gss_cat

?gss_cat

glimpse(gss_cat)

# Viewing factors in a tibble with count()

gss_cat |>
  count(race)
  
# two most common operations with cats are
# (1) changing the order of levels
# (2) changing the values of levels


# Modifying factor order -----------------------------------------------------

relig_summary <- gss_cat |>
  group_by(relig) |>
  summarize(
    tvhours = mean(tvhours, na.rm = TRUE),
	n = n()
  )
 
relig_summary

ggplot(relig_summary, aes(x = tvhours, y = relig)) +
  geom_point()
  
# this is hard to read, so we want to change the order
#  using fct_reorder()

ggplot(relig_summary, aes(x = tvhours, y = fct_reorder(relig, tvhours))) +
  geom_point()
  
# Its better to do this transformation work outside ggplot aes()
# and do it in mutate() instead

relig_summary |>
  mutate(
    relig = fct_reorder(relig, tvhours)) |>
  ggplot(aes(x = tvhours, y = relig)) +
	geom_point()
	
# Next, try similar plot on average age varies across reported income levels

glimpse(gss_cat)

unique(gss_cat$rincome)


rincome_summary <- gss_cat |>
  group_by(rincome) |>
  summarize(
    age = mean(age, na.rm = TRUE),
	n = n()
	)
	
rincome_summary

ggplot(rincome_summary, aes(x = age, y = fct_reorder(rincome, age))) +
  geom_point()

# Next, pull "Not applicable" from top and move to bottom of re-ordered lists
# using the function fct_relevel()

ggplot(rincome_summary, aes(x = age, y = fct_relevel(rincome, "Not applicable"))) +
  geom_point()
  
# fct_reorder2(f, x, y) reorders factor f by the y values associated 
# with largest x values

by_age <- gss_cat |>
  filter(!is.na(age)) |>
  count(age, marital) |>
  group_by(age) |>
  mutate(
    prop = n / sum(n)
  )

by_age


ggplot(by_age, aes(x = age, y = prop, color = marital)) +
  geom_line(linewidth = 1) +
  scale_color_brewer(palette = "Set1")
  
ggplot(by_age, aes(x = age, y = prop, color = fct_reorder2(marital, age, prop))) +
  geom_line(linewidth = 1) +
  scale_color_brewer(palette = "Set1") +
  labs(color = "marital")
 
 
# simplest way to do bar chart with ordered bars
# use fct_infreq() to order levesl in decreasing frequency


gss_cat |>
  mutate(marital = marital |> fct_infreq()) |>
  ggplot(aes(x = marital)) +
  geom_bar()
  
# combine with fct_rev() for increasing bars

gss_cat |>
  mutate(marital = marital |> fct_infreq() |> fct_rev()) |>
  ggplot(aes(x = marital)) +
  geom_bar()
  

# Modifying factor levels ----------------------------------------------------
  
# fct_recode()

glimpse(gss_cat)

gss_cat |> count(partyid)

# recoding the values for clarity -- new values are on the left

gss_cat |>
  mutate(
    partyid = fct_recode(partyid,
	  "Republican, strong" = "Strong republican",
	  "Republican, weak" = "Not str republican",
	  "Independent, near rep" = "Ind,near rep",
	  "Independent, near dem" = "Ind,near rep",
	  "Democrat, weak" = "Not str democrat",
	  "Democrat, strong" = "Strong democrat"
	)
  ) |>
count(partyid)
  
  
# Combining groups with same value, e.g., other


gss_cat |>
  mutate(
    partyid = fct_recode(partyid,
	  "Republican, strong" = "Strong republican",
	  "Republican, weak" = "Not str republican",
	  "Independent, near rep" = "Ind,near rep",
	  "Independent, near dem" = "Ind,near rep",
	  "Democrat, weak" = "Not str democrat",
	  "Democrat, strong" = "Strong democrat",
	  "Other" = "No answer",
	  "Other" =  "Don't know",
	  "Other" = "Other party"	  
	)
  ) |>
count(partyid)

# Use fct_collapse to create variable from vector of old levels

gss_cat |>
  mutate(
    partyid  = fct_collapse(partyid,
    "other" = c("No answer", "Don't know", "Other party"),
	"rep" = c("Strong republican", "Not str republican"),
	"ind" = c("Ind,near rep", "Independent", "Ind,near dem"),
	"dem" = c("Not str democrat", "Strong democrat")
	)
  ) |>
count(partyid)

# lumping together small groups using fct_lump_*
# for example fct_lump_lowfreq
# lumping ove4r low frequencies

gss_cat |>
  mutate(relig = fct_lump_lowfreq(relig)) |>
  count(relig)
  
# maybe more helpful...
# fct_lump_n()

gss_cat |>
  mutate(relig = fct_lump_n(relig, n = 10)) |>
  count(relig, sort = TRUE)
  
  
# Others fct_lump_min(), fct_lump_prop()


# Ordered factors ------------------------------------------------------------

# Ordered factors are created using order() 
# not clear how useful these will be...

ordered(c("a", "b", "c"))

# example scale_color_viridis()/scale_fill_viridis()
# color scale implies ranking


# Summary --------------------------------------------------------------------
# Function reference in forcats
# Wrangling categorical data in R


































