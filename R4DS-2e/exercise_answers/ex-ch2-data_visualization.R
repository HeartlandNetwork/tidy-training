# Ch2 - Numbers
#===============================================================================


# Section 2.2.5 - Exercises ----------------------------------------------------

# 1. How many rows are in penguins? How many columns?

glimpse(penguins)

#Rows: 344
#Columns: 8

# 2. What does the bill_depth_mm variable in the penguins data frame describe? Read the help for ?penguins to find out.

bill_depth_mm

# a number denoting bill depth (millimeters)

# 3. Make a scatterplot of bill_depth_mm vs. bill_length_mm. Describe the relationship between these two variables.

ggplot(
  data = penguins,
  mapping = aes(x = bill_depth_mm, y = bill_length_mm)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth() +
  labs(
    title = "Bill depth and bill length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Bill length (mm)",
    y = "Bill depth (mm)",
    color = "Species",
    shape = "Species"
  )

# Bill depth appears to be fairly independent of bill length

# 4. What happens if you make a scatterplot of species vs bill_depth_mm? Why is the plot not useful?

# Species is a categorical variable so it doesn't make sense to put it on an X or Y axis

# 5. Why does the following give an error and how would you fix it?

ggplot(data = penguins) + 
  geom_point()
# Error in `check_required_aesthetics()`:
# geom_point requires the following missing aesthetics: x and y

# You would need assignment to variables x and y to fix it

# 6. What does the na.rm argument do in geom_point()? 
# It determines whether or not NA records will be reported as errors
# What is the default value of the argument? 
# The default is FALSE
# Create a scatterplot where you successfully use this argument set to TRUE.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()
#> Warning: Removed 2 rows containing missing values (`geom_point()`).

penguins |>
  select(species, flipper_length_mm, body_mass_g) |>
  filter(is.na(body_mass_g) | is.na(flipper_length_mm))
#> # A tibble: 2 × 3
#>   species flipper_length_mm body_mass_g
#>   <fct>               <int>       <int>
#> 1 Adelie                 NA          NA
#> 2 Gentoo                 NA          NA


ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(na.rm = TRUE)

# 7. Add the following caption to the plot you made in the previous exercise: 
# “Data come from the palmerpenguins package.” 
# Hint: Take a look at the documentation for labs().

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = species, shape = species, na.rm = TRUE)) +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species",
    shape = "Species"
  )


# 8. Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to? 
# And should it be mapped at the global level or at the geom level?


# A scatterplot of body mass vs. flipper length of penguins, colored by bill depth. 
# A smooth curve of the relationship between body mass and flipper length is overlaid. 
# The relationship is positive, fairly linear, and moderately strong.

# It should be mapped at the geom level under the geom_point.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = bill_depth_mm)) +
  geom_smooth() +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "bill_depth_mm"
  )


# 9. Run this code in your head and predict what the output will look like. 
# Then, run the code in R and check your predictions.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)


# Well, this is a plot of flipper length vs. body mass, 
# and there should be separate colors for birds on each island


# 10. Will these two graphs look different? Why/why not?

# (a) 

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

# (b)


ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )

# They appear to be identical. This is because the default assignments of the two geoms
# geom_point and geom_smooth in (a) are the same as the specific assignments in (b)


# 2.4.3 Exercises --------------------------------------------------------------

# 1. Make a bar plot of species of penguins, 
# where you assign species to the y aesthetic. 
# How is this plot different?

ggplot(penguins, aes(y = species)) +
  geom_bar()

# This changes the orientation of the bar chart

# 2. How are the following two plots different? 
# Which aesthetic, color or fill, is more useful 
# for changing the

# This just outlines the bars in red
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

# This fills the bars red
ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")

# 3. What does the bins argument in geom_histogram() do?

# It determines the number of units to combine into one bar
# along the X-Axis

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)

# 4. Make a histogram of the carat variable in the diamonds dataset. 
# Experiment with different binwidths. 
# What binwidth reveals the most interesting patterns?

# Bin width of 0.1 works well

glimpse(diamonds)

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.1)


ggplot(diamonds, aes(x = carat)) +
  geom_density()


# 2.5.5. Exercises -------------------------------------------------------------

# 1. Which variables in mpg are categorical? Which variables 
# are continuous? (Hint: type ?mpg to read the documentation 
# for the dataset). How can you see this information when you run mpg?

glimpse(mpg)

?mpg

# categorical: manufacturer, mode, trans, drv, fl (fuel type), class
# continuous: displ, year, cyl, cty, and hwy


# 2. Make a scatterplot of hwy vs. displ using the mpg data frame. Next, 
# map a third, numerical variable to color, then size, then both color and size, 
# then shape. How do these aesthetics behave differently for categorical 
# vs. numerical variables?

# continous color shading assigned to numerical vs different colors assigned
# to categorical variables

ggplot(mpg, aes(x = hwy, y = displ)) +
  geom_point()


ggplot(mpg, aes(x = cty, y = displ)) +
  geom_point(aes(color = cyl))

ggplot(mpg, aes(x = hwy, y = displ)) +
  geom_point(aes(color = cyl, size = cty))


# 3. In the scatterplot of hwy vs. displ, what happens if you map a third \
# variable to linewidth?

ggplot(mpg, aes(x = hwy, y = displ)) +
  geom_point(aes(linewidth = cyl))

# linewidth asethetics is flagged as unknown 

# 4. What happens if you map the same variable to multiple aesthetics?

library("tidyverse")
library("palmerpenguins")

ggplot(mpg, aes(x = hwy, y = displ)) +
  geom_point(aes(color = cyl, size = cyl))

# ggplot reuses the variable in both mapped settings

# 5. Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the 
# by species. What does adding coloring by species reveal about the 
# between these two variables?




ggplot(penguins,aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(color = species))

# This plot shows three distinct groups by species re.
# bill morphology

# 5. Why does the following yield two separate legends? How would you 
# fix it to combine the two legends?

ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs

# Solution

# Map color and shape to the geom_point aesthetic
# The default combines the legends

ggplot(penguins,aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(aes(color = species, shape = species))


# 2.6.1 Exercises

# 1. Run the following lines of code. Which of the two plots is saved 
# as mpg-plot.png? Why?

ggplot(mpg, aes(x = class)) +
  geom_bar()
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.png")

# ggsave only saves the last ggplot call

# 2. What do you need to change in the code above to save the plot 
# as a PDF instead of a PNG?

?ggsave()

ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.pdf", device = "pdf")








