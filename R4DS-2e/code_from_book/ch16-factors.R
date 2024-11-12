
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

#


































