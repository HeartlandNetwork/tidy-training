



# ch6-data-tidying


library(tidyverse)

# 6.2 Tidy data

# table1

# table2

table3

# table3
# A tibble: 6 × 3
#country      year rate             
#<chr>       <dbl> <chr>            
#1 Afghanistan  1999 745/19987071     
#2 Afghanistan  2000 2666/20595360    
#3 Brazil       1999 37737/172006362  
#4 Brazil       2000 80488/174504898  
#5 China        1999 212258/1272915272
#6 China        2000 213766/1280428583
#> 

# Compute rate per 10,000
table1 |>
  mutate(rate = cases / population * 10000)


# Compute total cases per year
table1 |> 
  group_by(year) |> 
  summarize(total_cases = sum(cases))


# Visualize changes over time
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000)) 


# 6.2.1 Exercises

# 1. For each of the sample tables, describe what each observation 
#    and each column represents.

# table 1 - each column represents a variable while each row is an observation

# table 2 - like table 1 except "type" column mixes up two kinds of data.

# table 3 - column 'rate' is a calculated field containing two variables that 
#  should be managed as separate columns

# 2. Sketch out the process you’d use to calculate the rate for table2 and table3. 
#   You will need to perform four operations:

# a. Extract the number of TB cases per country per year.

# b. Extract the matching population per country per year.
# c. Divide cases by population, and multiply by 10000.
# d. Store back in the appropriate place.

table2

table3

# 6.3. Lengthening data --------------------------------------------------------
# tidyr provides two functions for pivoting data: 
# pivot_longer() and pivot_wider(). 

# 6.3.1 Data in column names -

# billboard rank of songs in the year 2000

billboard

# Data is stored in the wk column names

billboard2 <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank"
  )

billboard2

# There's a bunch of NA's 
# These aren't missed observations but rather an artifact of 
# forcing pivot_longer()

billboard3 <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  )

billboard3

# It would be helpful to cast weeks from ctr to dbl


billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )

billboard_longer
 
# Now we can look at rank vs week

billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) + 
  geom_line(alpha = 0.25) + 
  scale_y_reverse()

# 6.3.2 How does pivoting work?

# Note that bp1 and bp2 column headings are actually data

df <- tribble(
  ~id,  ~bp1, ~bp2,
  "A",  100,  120,
  "B",  140,  115,
  "C",  120,  125
)

df

# We want our new dataset to have three variables: id (already exists), 
# measurement (the column names), and value (the cell values). 

df2 <- df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

df2

# 6.3.3 Many variables in column names

who2

# The column headings contain diagnosis+sex+age_range

who3 <- who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"), 
    names_sep = "_",
    values_to = "count"
  )

who3

# 6.3.4 Data and variable names in the column headers

household


household2 <- household |> 
  pivot_longer(
    cols = !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )

household2


# 6.4 Widening data ------------------------------------------------------------
# Makes datasets wider by increasing columns and reducing rows and 
# helps when one observation is spread across multiple rows

cms_patient_experience

# We can see the complete set of values for measure_cd and measure_title by 
# using distinct():

cms_patient_experience |> 
  distinct(measure_cd, measure_title)

cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )

# we still seem to have multiple rows for each organization

cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"), # <=======
    names_from = measure_cd,
    values_from = prf_rate
  )

# 6.4.1 How does pivot_wider() work?

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

df

df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

df |> 
  distinct(measurement) |> 
  pull()

df |> 
  select(-measurement, -value) |> 
  distinct()


df |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)

df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )


df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)























