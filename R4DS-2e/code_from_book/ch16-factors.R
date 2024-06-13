
## Ch16 - Factors
#===============================================================================

# Factors - outline

  # introduction----------------------------------------------------------------
    # factor()
    # gss_cat data 

    # prerequisites
      # base R
      # forcats in tidyverse
  
  # factor basics --------------------------------------------------------------
    # valid levels
    # factor()
    # forcats::fct()
      # orders by first appearance:
    # levels()
    # readr::read_csv() 
      # col_factor() option
    
  # General Social Survey ------------------------------------------------------
    # NORC (Natl Opinion Research Center) University of Chicago
    # gss_cat - small data subset

  # Modifying factor order -----------------------------------------------------
    # fct_reorder()
    # fct_reorder2()
    # fct_relevel()
    # fct_infreq()
    # fcr_rev()

  # Modifying factor levels ----------------------------------------------------
    # fct_recode()
    # fct_collapse()  
    # fct_lump_* family of functions
    # fct_lump_n()

  # Ordered factors ------------------------------------------------------------
    # ordered()
    
  # Summary --------------------------------------------------------------------
    # Function reference in forcats
    # Wrangling categorical data in R





# introduction----------------------------------------------------------------
# factor()
# gss_cat data 

# prerequisites
# base R
# forcats in tidyverse

?forcats

library(tidyverse)

# factor basics --------------------------------------------------------------

x1 <- c("Dec", "Apr", "Jan", "Mar")
x1

x2 <- c("Dec", "Apr", "Jam", "Mar") # NOTE: typo for Jan
x2

sort(x1)

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
month_levels
y1 <- factor(x1, levels = month_levels)
y1

y2 <- factor(x2, levels = month_levels)
y2

# forcats::fct()

# y2 <- fct(x2, levels = month_levels)
#Error in `fct()`:
#  ! All values of `x` must appear in `levels` or `na`
# ℹ Missing level: "Jam"
# Run `rlang::last_trace()` to see where the error occurred.

factor(x1)

fct(x1) # sort by order of appearance

levels(y2)

csv <- "
month,value
Jan,12
Feb,56
Mar,12"

df <- read_csv(csv, col_types = cols(month = col_factor(month_levels)))
df
df$month

# General Social Survey ------------------------------------------------------
# NORC (Natl Opinion Research Center) University of Chicago
# gss_cat - small data subset

?gss_cat

gss_cat

glimpse(gss_cat)

gss_cat |>
  count(race)



# Modifying factor order -------------------------------------------------------

relig_summary <- gss_cat |>
  group_by(relig) |>
  summarize(
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(x = tvhours, y = relig)) + 
  geom_point()

# fct_reorder()

ggplot(relig_summary, aes(x = tvhours, y = fct_reorder(relig, tvhours))) +
  geom_point()

relig_summary |>
  mutate(
    relig = fct_reorder(relig, tvhours)
  ) |>
  ggplot(aes(x = tvhours, y = relig)) +
  geom_point()

rincome_summary <- gss_cat |>
  group_by(rincome) |>
  summarize(
    age = mean(age, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(x = age, y = fct_reorder(rincome, age))) + 
  geom_point()


# fct_reorder2()
# fct_relevel()
# fct_infreq()
# fcr_rev()

















































