
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
  # read from file - readr
  # From a String
  # From date / time components
  # From existing date - time components

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

csv <- "date 01/02/15"

csv

read_csv








# From Strings



# From Individual Components


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

