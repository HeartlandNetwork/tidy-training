

# ch5 - workflow: code style

library(tidyverse)
library(nycflights13)

####################################################
# Strive for:
short_flights <- flights |> filter(air_time < 60)

# Avoid:
SHORTFLIGHTS <- flights |> filter(air_time < 60)

####################################################
# Strive for
z <- (a + b)^2 / d

# Avoid
z<-( a + b ) ^ 2/d

####################################################
# Strive for
mean(x, na.rm = TRUE)

# Avoid
mean (x ,na.rm=TRUE)

flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,
    dep_minute = dep_time %%  100
  )

####################################################
# Strive for 
flights |>  
  filter(!is.na(arr_delay), !is.na(tailnum)) |> 
  count(dest)

# Avoid
flights|>filter(!is.na(arr_delay), !is.na(tailnum))|>count(dest)

####################################################
# Strive for
flights |>  
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

# Avoid
flights |>
  group_by(
    tailnum
  ) |> 
  summarize(delay = mean(arr_delay, na.rm = TRUE), n = n())

####################################################
# Strive for 
flights |>  
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

# Avoid
flights|>
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  )

# Avoid
flights|>
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  )


####################################################
# This fits compactly on one line
df |> mutate(y = x + 1)

# While this takes up 4x as many lines, it's easily extended to 
# more variables and more steps in the future
df |> 
  mutate(
    y = x + 1
  )


flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() + 
  geom_line()


flights |> 
  group_by(dest) |> 
  summarize(
    distance = mean(distance),
    speed = mean(distance / air_time, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = distance, y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE, 
    color = "white", 
    linewidth = 4
  ) +
  geom_point()

# Exercises
# Restyle the following pipelines following the guidelines above.

flights |> 
  filter(dest=="IAH") |> 
  group_by(year,month,day) |> 
  summarize(
    n=n(),
    delay=mean(arr_delay,na.rm=TRUE)
    ) |>
   filter(n > 10)


flights |> 
  filter(
    carrier=="UA",
    dest%in%c("IAH","HOU"),
    sched_dep_time > 0900,
    sched_arr_time < 2000
  ) |>
  group_by(flight) |>
  summarize(
    delay=mean(arr_delay,na.rm=TRUE),
    cancelled = sum(is.na(arr_delay)),
    n=n()
  ) |> 
  filter(n > 10)









