
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
	


make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}



flights_dt <- flights |>
  filter(!is.na(dep_time), !is.na(arr_time)) |>
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
	arr_time = make_datetime_100(year, month, day, arr_time),
	sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time),
  ) |>
  select(origin, dest, ends_with("delay"), ends_with("time"))
  
  
flights_dt

# departure times across one year

flights_dt |>
  ggplot(aes(x = dep_time)) +
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day
  
 # within a single day
 
 
flights_dt |>
  filter(dep_time < ymd(20130102)) |>
  ggplot(aes(x = dep_time)) +
  geom_freqpoly(binwidth = 600) # 600 seconds = 10 minutes
 

# From Other Types

# Switching between as_datetime() and as_date()

as_datetime(today())

as_date(now())

# date/times as offsets from "Unix epoch" 1970-01-01

as_datetime(60 * 60 * 10)

as_date(365 * 10 + 2)


# Date-Time Components
flights_dt <- flights |>
  filter(!is.na(dep_time), !is.na(arr_time)) |>
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
	arr_time = make_datetime_100(year, month, day, arr_time),
	sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time),
  ) |>
  select(origin, dest, ends_with("delay"), ends_with("time"))
  
  
# --------------------

# Getting Components
# accessor functions year(), month(), mday() day of the month
# yday() day of the year, wday() (day of the week), hour(), 
# minute(), second().



datetime <- ymd_hms("2026-07-08 12:34:56")

datetime

year(datetime)

month(datetime)

mday(datetime)

yday(datetime)

wday(datetime)


# label = TRUE gets abbreviated name

month(datetime, label = TRUE)

wday(datetime, label = TRUE, abbr = FALSE)

#  see that there are more flights 
#  during the week than in the weekend

flights_dt

flights_dt |>
  mutate(wday = wday(dep_time, label = TRUE)) |>
  ggplot(aes(x = wday)) +
  geom_bar()
  
 
 
  
  







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

