 Ch11 - Exploratory Data Analysis

library(tidyverse)
library(lvplot)
library(ggbeeswarm)

 11.3 - Variation -------------------------------------------------------------

gplot(diamonds, aes(x = carat)) +
 geom_histogram(binwidth = 0.5)


 11.3.1 - Typical values ------------------------------------------------------

maller <- diamonds |> 
 filter(carat < 3)

gplot(smaller, aes(x = carat)) +
 geom_histogram(binwidth = 0.01)


 11.3.2 - Unusual values ------------------------------------------------------


gplot(diamonds, aes(x = y)) + 
 geom_histogram(binwidth = 0.5)

 changing the y scale to show the unusual values

gplot(diamonds, aes(x = y)) + 
 geom_histogram(binwidth = 0.5) +
 coord_cartesian(ylim = c(0, 50))

nusual <- diamonds |> 
 filter(y < 3 | y > 20) |> 
 select(price, x, y, z) |>
 arrange(y)

nusual




 11.3.3 Exercises -------------------------------------------------------------

 1. Explore the distribution of each of the x, y, and z variables in diamonds. 
 What do you learn? Think about a diamond and how you might decide which 
 dimension is the length, width, and depth.

limpse(diamonds)

 depth?
gplot(diamonds, aes(x = x)) + 
 geom_histogram(binwidth = 0.5)

 length?
gplot(diamonds, aes(x = y)) + 
 geom_histogram(binwidth = 0.5) 

 width?
gplot(diamonds, aes(x = z)) + 
 geom_histogram(binwidth = 0.5)



 2. Explore the distribution of price. Do you discover anything unusual or 
 surprising? (Hint: Carefully think about the binwidth and make sure you try 
 a wide range of values.)

limpse(diamonds)

 prices
gplot(diamonds, aes(x = price)) + 
 geom_histogram(binwidth = 500)

 they follow a Poisson distribution



 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think 
 is the cause of the difference?


gplot(diamonds, aes(x = carat)) + 
 geom_histogram(binwidth = 0.01) +
 coord_cartesian(xlim = c(0.8, 1.2))

 It looks like carat values are rounded to the nearest 0.1
 and there is a bias to round upwards


 4. Compare and contrast coord_cartesian() vs. xlim() or ylim() when zooming 
 in on a histogram. What happens if you leave binwidth unset? What happens 
 if you try and zoom so only half a bar shows?


 prices
ggplot(diamonds, aes(x = price)) + 
  geom_histogram(binwidth = .1) +
  coord_cartesian(xlim = c(5000, 5000.5))

 If you don't adjust the bandwidth, you can't see the detail in the
 histogram

 If you zoom into half a bar, it returns just a single bar



 11.4 Unusual values ----------------------------------------------------------

 Options for dealing with unusual values

 1. Drop them - not recommended

iamonds2 <- diamonds |> 
 filter(between(y, 3, 20))

 2. Replace unusual values with NA

iamonds2 <- diamonds |> 
 mutate(y = if_else(y < 3 | y > 20, NA, y))


gplot(diamonds, aes(x = x, y = y)) + 
 geom_point()

gplot(diamonds2, aes(x = x, y = y)) + 
 geom_point()

 Suppresses the warning about the missing values

gplot(diamonds2, aes(x = x, y = y)) + 
 geom_point(na.rm = TRUE)

 Separating unusual values and displaying them
 nycflights data - separating the cancelled flight times
 from the non-canceled flight times

ycflights13::flights |> 
 mutate(
   cancelled = is.na(dep_time),
   sched_hour = sched_dep_time %/% 100,
   sched_min = sched_dep_time %% 100,
   sched_dep_time = sched_hour + (sched_min / 60)
 ) |> 
 ggplot(aes(x = sched_dep_time)) + 
 geom_freqpoly(aes(color = cancelled), binwidth = 1/4)

11.4.1 Exercises

 1. What happens to missing values in a histogram? What happens to missing 
 values in a bar chart? Why is there a difference in how missing values are 
 handled in histograms and bar charts?
 
limpse(diamonds)

gplot(diamonds, aes(x = price)) + 
 geom_histogram(binwidth = 500)

diamonds2 <- diamonds |> 
  filter(between(price, 5000, 10000))


iamonds2 <- diamonds |> 
 mutate(price = if_else(price > 15000, NA, price))

gplot(diamonds2, aes(x = price)) + 
 geom_histogram(binwidth = 500)

 you get a warning if you set cut values as NA,
 otherwise there's no warning

gplot(diamonds, aes(x = price)) + 
 geom_bar()

gplot(diamonds2, aes(x = price)) + 
 geom_bar()
 
 2. What does na.rm = TRUE do in mean() and sum()?

ean(diamonds2$price, na.rm = TRUE )
ean(diamonds2$price, na.rm = TRUE )

 It tells the function to ignore the NA's

 
 3. Recreate the frequency plot of scheduled_dep_time colored by whether the 
 flight was cancelled or not. Also facet by the cancelled variable. Experiment 
 with different values of the scales variable in the faceting function to 
 mitigate the effect of more non-cancelled flights than cancelled flights.


ycflights13::flights |> 
 mutate(
   cancelled = is.na(dep_time),
   sched_hour = sched_dep_time %/% 100,
   sched_min = sched_dep_time %% 100,
   sched_dep_time = sched_hour + (sched_min / 60)
 ) |> 
 ggplot(aes(x = sched_dep_time)) + 
 geom_freqpoly(aes(color = cancelled), binwidth = 1/4)


lights2 <- nycflights13::flights |> 
 mutate(
   cancelled = is.na(dep_time),
   sched_hour = sched_dep_time %/% 100,
   sched_min = sched_dep_time %% 100,
   sched_dep_time = sched_hour*100 + sched_min
 ) 

limpse(flights2)
 
gplot(flights2, aes(x = dep_time, y = sched_dep_time)) + 
 geom_point() 



 11.5 Covariation -------------------------------------------------------------


 Height of curves is sample-size dependent


gplot(diamonds, aes(x = price)) + 
 geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)


 Remove sample size effects with density plots
 after_stat function is used to create y axis
 this plot is hard to interpret
 fair diamonds appear to fetch a higher price


gplot(diamonds, aes(x = price, y = after_stat(density))) + 
 geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)


 Simplify this relationship using boxplots

gplot(diamonds, aes(x = cut, y = price)) +
 geom_boxplot()

 Using fct_reorder ------------------------------------------------------------

 before...

gplot(mpg, aes(x = class, y = hwy)) +
 geom_boxplot()

 after

gplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
 geom_boxplot()

 rotate 90 degrees by flipping the variables


gplot(mpg, aes(x = hwy, y = fct_reorder(class, hwy, median))) +
 geom_boxplot()


 11.5.1.1 Exercises -----------------------------------------------------------


 1. Use what you’ve learned to improve the visualization of the departure times 
 of cancelled vs. non-cancelled flights.


ycflights13::flights |> 
 mutate(
   cancelled = is.na(dep_time),
   sched_hour = sched_dep_time %/% 100,
   sched_min = sched_dep_time %% 100,
   sched_dep_time = sched_hour + (sched_min / 60)
 ) |> 
 ggplot(aes(x = sched_dep_time, y = after_stat(density))) + 
 geom_freqpoly(aes(color = cancelled), binwidth = 1, linewidth = 1.5)

 2.Based on EDA, what variable in the diamonds dataset appears to be most 
 important for predicting the price of a diamond? How is that variable 
 correlated with cut? Why does the combination of those two relationships 
 lead to lower quality diamonds being more expensive?

limpse(diamonds)

 carat is a good predictor of price

gplot(diamonds, aes(x = carat, y = price)) + 
 geom_point()

 ideal cut diamonds also tend to be lower carat diamonds which explains
 why ideal cut diamonds tend to fetch lower prices

gplot(diamonds, aes(x = cut, y = carat)) + 
 geom_boxplot()
 
 3. Instead of exchanging the x and y variables, add coord_flip() as a 
 new layer to the vertical boxplot to create a horizontal one. How does 
 this compare to exchanging the variables?

 They look identical

gplot(diamonds, aes(x = carat, y = cut)) + 
 geom_boxplot()

coord_flip

gplot(diamonds, aes(x = cut, y = carat)) + 
 geom_boxplot() + 
 coord_flip()

 
 4. One problem with boxplots is that they were developed in an era of much 
 smaller datasets and tend to display a prohibitively large number of 
 “outlying values”. One approach to remedy this problem is the letter value 
 plot. Install the lvplot package, and try using geom_lv() to display the 
 distribution of price vs. cut. What do you learn? How do you interpret the 
 plots?

gplot(diamonds, aes(x = cut, y = price)) + 
 geom_lv() 

 
 5. Create a visualization of diamond prices vs. a categorical variable from 
 the diamonds dataset using geom_violin(), then a faceted geom_histogram(), 
 then a colored geom_freqpoly(), and then a colored geom_density(). Compare 
 and contrast the four plots. What are the pros and cons of each method of 
 visualizing the distribution of a numerical variable based on the levels of 
 a categorical variable?

 violin displays the distribution differences nicely
 
gplot(diamonds, aes(x = color, y = price)) + 
 geom_violin()

 histogram below is a mess with price as the X axis

gplot(diamonds, aes(x = price)) + 
 geom_histogram() +
 facet_grid(~color)

 I find the freq poly more difficult to read

ggplot(diamonds, aes(x = price)) + 
  geom_freqpoly

 geom_density is better at showing distributional differences
 it would be better to display the density functions
 separately without overlap

gplot(diamonds, aes(x = price, color = cut, fill = cut)) +
 geom_density(alpha = 0.5)


 6. If you have a small dataset, it’s sometimes useful to use geom_jitter() 
 to avoid overplotting to more easily see the relationship between a continuous 
 and categorical variable. The ggbeeswarm package provides a number of methods 
 similar to geom_jitter(). List them and briefly describe what each one does.

 yes, does not work on large samples!!

gplot(diamonds, aes(x = color, y = price)) + 
 geom_violin()

gplot(diamonds, aes(x = price, y = cut)) + 
 geom_beeswarm(priority='density',size=2.5)

gplot2::ggplot(distro,aes(variable, value)) +
 geom_beeswarm(priority='density',size=2.5)

geom_beeswarm


 11.5.2 Two categorical variables ---------------------------------------------

 Using counts for categories
 this is basically frequency analysis

gplot(diamonds, aes(x = cut, y = color)) +
 geom_count()

 Using dplyr, can count values

iamonds2 <- diamonds |> 
               count(color, cut)

iamonds2

 Then visualize with geom_tile() and the fill aesthetic

iamonds |> 
 count(color, cut) |>  
 ggplot(aes(x = color, y = cut)) +
 geom_tile(aes(fill = n))


 11.5.2.1 Exercises -----------------------------------------------------------

 1. How could you rescale the count dataset above to more clearly show the 
 distribution of cut within color, or color within cut?

 Some kind of transformation might emphasize their differences.


iamonds2 <- diamonds |> 
 count(color, cut) 

iamonds3 <- diamonds2 |>
 mutate( nsq = n * n )


gplot(diamonds2, aes(x = color, y = cut)) +
 geom_tile(aes(fill = n))

gplot(diamonds3, aes(x = color, y = cut)) +
 geom_tile(aes(fill = nsq ))
 
 
 2. What different data insights do you get with a segmented bar chart if color 
 is mapped to the x aesthetic and cut is mapped to the fill aesthetic? 
 Calculate the counts that fall into each of the segments.

 Ideal is by far the most common category. Its count max's out in the G xolor

gplot(diamonds, aes(x = color, fill = cut)) + 
 geom_bar() 

 diamonds2 contains all the counts by category

iew(diamonds2)


 3. Use geom_tile() together with dplyr to explore how average flight departure 
 delays vary by destination and month of year. What makes the plot difficult to 
 read? How could you improve it?

 Looking at delays grouped by destination and month

 The problem with this plot is that there are too many destinations
 to display as categorical data. One solution would be to rank the 
 dep_delay and display the top ten and bottom ten. Or really any
 other kind of filter on destinations.

ibrary(tidyverse)
ibrary(nycflights13)

limpse(flights)

lights2 <- flights |>
             select(month, dest, dep_delay)

limpse(flights2)

gplot(flights2, (aes( x = month, y = dest))) + 
 geom_tile(aes(fill = dep_delay))


 11.5.3 Covariance in Two numerical variables

gplot(smaller, aes(x = carat, y = price)) +
         geom_point()

 Use alpha to create transparency to display overplotting

gplot(smaller, aes(x = carat, y = price)) + 
         geom_point(alpha = 1 / 100)

 Other options for displaying large datasets

 bins in 2 D

ggplot(smaller, aes(x = carat, y = price)) +
          geom_bin2d()

 install.packages("hexbin")
ibrary(hexbin)

gplot(smaller, aes(x = carat, y = price)) +
    geom_hex()

 Another option is to bin one continuous variable so it acts 
 like a categorical variable

gplot(smaller, aes(x = carat, y = price)) + 
          geom_boxplot(aes(group = cut_width(carat, 0.1)))

 11.5.3.1 Exercises

 1. Instead of summarizing of summarizing the conditional distribution with a boxplot, 
   you could use a frequency polygon. What do you need to consider 
   when using cut_width() vs. cut_number()? How does that impact a 
   visualization of the 2d distribution of carat and price?

gplot(smaller, aes(x = carat, y = price)) + 
         geom_boxplot(aes(group = cut_width(carat, 0.1)))




ggplot(smaller, aes(x = carat, y = after_stat(density))) + 
	  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)


# 2. Visualize the distribution of carat, partitioned by price.

# 3. How does the price distribution of very large diamonds compare to 
#   small diamonds? Is it as you expect, or does it surprise you?

# 4. Combine two of the techniques you’ve learned to visualize the 
#   combined distribution of cut, carat, and price.

# 5. Two dimensional plots reveal outliers that are not visible in one 
#   dimensional plots. For example, some points in the following plot 
#   have an unusual combination of x and y values, which makes the points 
#   outliers even though their x and y values appear normal when examined 
#   separately. Why is a scatterplot a better display than a binned plot for this case?

diamonds |> 
  filter(x >= 4) |>
    ggplot(aes(x = x, y = y)) +
      geom_point() +
      coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

# 6. Instead of creating boxes of equal width with cut_width(), we could create 
# boxes that contain roughly equal number of points with cut_number(). What are 
# the advantages and disadvantages of this approach?

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_number(carat, 20)))

