
## Ch17 - Dates and Times
#===============================================================================

library(tidyverse)
library(nycflights13)

# Creating Date/Times
# -------------------

# data -> <date>
# time -> <time>
# date-time -> <dttm>

today()

now()

# Besides the above, 4 ways to create date / time
  # (1) read from file - readr
  # (2) From a String
  # (3) From date / time components
  # (4) From existing date - time components

# During Import

#ISO8601 date or date-time
csv <- "
  date,datetime
  2022-01-02, 2022-01-02 05:12
  "
 
read_csv(csv)

# Other formats...

# col_date()

# col_datetime()


# Date formats understood by readr
# --------------------------------
# year - %Y, %y, 
# month - %m, %b, %B, 
# day - %d, %e,
# hour - %H, %I, 
# am / pm - %p, 
# minutes - %M,
# seconds - $S, %OS
# Time zone - %Z, %z,
# skipping non-digits - %., %*


# Using readr read_csv()


csv <- "
  date 
  01/02/15
"

csv

read_csv(csv, col_types = cols(date = col_date("%m/%d/%y")))

read_csv(csv, col_types = cols(date = col_date("%d/%m/%y")))

read_csv(csv, col_types = cols(date = col_date("%y/%m/%d")))



# From Strings

# using lubridate's helper functions - attempt to automatically determine formats

# these ones use dates

ymd("2017-01-31")

mdy("January 31st, 2017")

dmy("31-Jan-2017")

# these ones use date/times 

ymd_hms("2017-01-31 20:11:59")

mdy_hm("01/31/2017 08:01")

# Using UTC timezones

ymd("2017-01-31", tz = "UTC")



# From Individual Components

# Use-case - where you have individual components spread over multiple columns
# using make_datetime()

flights |>
  select(year, month, day, hour, minute)
  

flights |>
  select(year, month, day, hour, minute) |>
  mutate(
    departure = make_datetime(year, month, day, hour, minute))
	


  
  

  


# From Other Types


# Date-Time Components
# --------------------

# Getting Components

# Rounding

# Modifying Components

# Time Spans
# ----------

# Durations

# Periods

# Intervals

# Time Zones
# ----------

# Summary
# -------

