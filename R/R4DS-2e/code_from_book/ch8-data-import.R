


#ch8-data-import

# 8.1 Using tidyverse

library(tidyverse)
library(janitor)


students <- read_csv("data/students.csv")

# 8.2 Pulling data from Posit

students <- read_csv("https://pos.it/r4ds-students-csv")

students


# missing values

students <- read_csv("data/students.csv", na = c("N/A", ""))

students


# Dealing with column names with spaces

students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

#Alternately you can clean the names with janitor

students <- read_csv("data/students.csv", na = c("N/A", ""))


students2 <- students |> janitor::clean_names()

students

students2

students3 <- students2 |>
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))

students3

students4 <- students3 |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

students4

# other arguments

read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"
)

read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)

read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)


# 8.2.4 Exercises

# 1. What function would you use to read a file where fields were separated with “|”?

# read_delim(students, delim = "|")

# 2. Apart from file, skip, and comment, what other arguments do read_csv() and 
#    read_tsv() have in common?

# read.csv()
# read_tsv()

# They look quite different

# 3. What are the most important arguments to read_fwf()?

# The widths of each column

# 4. Sometimes strings in a CSV file contain commas. To prevent them from causing 
#   problems, they need to be surrounded by a quoting character, like " or  
#   By default, read_csv() assumes that the quoting character will be ". 
#   To read the following text into a data frame, what argument to read_csv() 
#   do you need to specify?

# "x,y\n1,'a,b'"

df <- read_csv(I("x,y\n1,'a,b'"))

# 5. Identify what is wrong with each of the following inline CSV files. 
#   What happens when you run the code?

df <- read_csv("a,b\n1,2,3\n4,5,6")

problems(df)

# It expected two columns of data, but got three columns


df <- read_csv("a,b,c\n1,2\n1,2,3,4")

problems(df)

# Expected three columns, got 2, then 4 values

df <- read_csv("a,b\n\"1")

problems(df)

# Expected two char, got one number

df <- read_csv("a,b\n1,2\na,b")

df

# this seems to work...


problems(df)

# Says a tibble 0 x 5 but that doesn't' make sense



#read_csv("a;b\n1;3")

# wrong delimiter, its reading a;b as a single column header
# and the chars 1;3 as a single value


# 6. Practice referring to non-syntactic names in the following data frame by:

# Extracting the variable called 1.
# Plotting a scatterplot of 1 vs. 2.
# Creating a new column called 3, which is 2 divided by 1.
# Renaming the columns to one, two, and three

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying

#annoying$1

not_annoying <- annoying |> janitor::clean_names()

ggplot(
  data = not_annoying,
  mapping = aes(x1, x2)
) +
  geom_point()


#reallyannoying = annoying |> 
#    mutate( '3' = '2' / '1')

#reallyannoying

annoying |> janitor::clean_names()

#annoying |> 
#  rename(
#    1 = `one',
#    2 = `two'
#  )




# 8.3  Controlling column types

# 8.3.1 Guessing the data type

df <- read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

df


# 8.3.2. Missing values

simple_csv <- "
  x
  10
  .
  20
  30"
  
simple_csv


  
df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)

problems(df)

read_csv(simple_csv, na = ".")


# changing the defaults

another_csv <- "
x,y,z
1,2,3"

another_csv

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)

# read in only the columns you specify:

read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)

# 8.4 Reading from multiple files

sales_files <- c("data/01-sales.csv", "data/02-sales.csv", "data/03-sales.csv")

sales_files

df <- read_csv(sales_files, id = "file")

df


sales_files <- c("data/01-sales.csv", "data/02-sales.csv", "data/03-sales.csv")
read_csv(sales_files, id = "file")


# Reading them from Posit

sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)
df <- read_csv(sales_files, id = "file")

sales_files

df

#  use the base list.files() function to find the files for you 
#  by matching a pattern in the file names

sales_files <- list.files("data", pattern = "sales\\.csv$", full.names = TRUE)
sales_files

library(janitor)

# 8.5 Writing to a file

students <- read_csv("data/students.csv", na = c("N/A", ""))

students

students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

students

write_csv(students, "my_students.csv")


# don't use csv's to store interim files
# note that some types get lost

students

write_csv(students, "students-2.csv")
read_csv("students-2.csv")


# to store exact objects use either Rds or parquet

write_rds(students, "students.rds")
read_rds("students.rds")

library(arrow)
write_parquet(students, "students.parquet")
read_parquet("students.parquet")

# 8.6 Data entry

# by columns

library(tidyverse)

tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

# by rows


tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)




















