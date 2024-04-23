

# ch10-Layers

# 10.1 Intro - you'll need tidyverse...

library("tidyverse")


view(mpg) 


# Relationship between displ and hwy for various classes of cars

# Left
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# Right
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()





# Left
ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()
#> Warning: Using size for a discrete variable is not advised.

# Right
ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()

# manually as an argument of your geom function (outside of aes()) 
#  instead of relying on a variable mapping to determine the appearance

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(color = "blue")

# 10.2.1 Exercises -------------------------------------------

# 1. Create a scatterplot of hwy vs. displ where the points are pink filled 
#   in triangles.

view(mpg)

ggplot(mpg, aes(x = hwy, y = displ)) + 
  geom_point(shape = 24)

# 2. Why did the following code not result in a plot with blue points?

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, color = "blue"))

# Does the aes need to be described immediately after ggplot?

# 3. What does the stroke aesthetic do? What shapes does it work with? 
#   (Hint: use ?geom_point)

?geom_point

# Stroke determines the width of the borders 

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 1)


# 4. What happens if you map an aesthetic to something other than a variable name, 
#      like aes(color = displ < 5)? Note, you’ll also need to specify x and y

ggplot(mpg, aes(x = displ, y = hwy, color = displ < 5)) +
  geom_point()

# color = displ < 5 is interpreted as true / false


# 10.3 Geometric objects ------------------------------------------------------

# changing the geom

# points

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

# smooth geom with fitted line using method = 'loess' and formula = 'y ~ x'

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()


# Shape doesn't apply to geom_smooth, so its ignoring shape here

ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) + 
  geom_smooth()

# linetype does apply to geom_smooth, so it uses linetype


ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) + 
  geom_smooth()


# Here,  overlaying the lines on the raw data

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() +
  geom_smooth(aes(linetype = drv))


# Use 'group' aesthetic on categorical data. Group doesn't provide a legend


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))     # <<<<<<<<<< group


# same effect by mapping aesthtic to discrete var


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE) 

# placing mappings in geom function to extend or overwrite
# treated as local mappings for that layer
# allows different aesthetics for different layers

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth()


# Here, red points plus circles to highlight two-seater cars

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"), 
    shape = "circle open", size = 3, color = "red"
  )


# geom is fundamental building block of ggplot

# histogram
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

# density plot
ggplot(mpg, aes(x = hwy)) +
  geom_density()

# box plot
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()

# cool geoms

library(ggridges)

ggplot(mpg, aes(x = hwy, y = drv, fill = drv, color = drv)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)


# 10.3.1 Exercises --------------------------------------------

# 1. What geom would you use to draw a line chart? geom_line()

#    A boxplot? geom_boxplot()

#    A histogram? geom_histogram()

#    An area chart? geom_density??

# 2. Earlier in this chapter we used show.legend without explaining it:

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)

# What does show.legend = FALSE do here? What happens if you remove it? 
#  It defaults to show legend
# Why do you think we used it earlier?
# To show that mapping aesthetics local to the geom behaves like 'group'

# 3. What does the se argument to geom_smooth() do?
#  se includes standard error with geom_smooth. The default is true

# 4. Recreate the R code necessary to generate the following graphs. Note that 
#   wherever a categorical variable is used in the plot, it’s drv.

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(se = FALSE)


ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(aes(group = drv), se = FALSE)


ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth()



ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_point(
    shape = "circle open", size = 3, color = "white"
  )


# 10.4 Facets -----------------------------------------------------------------

# review facet wraps

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cyl)

# here is facet grid

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl)

# free_x and free_Y


ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free_y")

# 10.4.1 Exercises ---------------------------------------------------------------

# 1. What happens if you facet on a continuous variable?

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~displ)

# It produces a facet for every value

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? 
#  Run the following code. How do they relate to the resulting plot?

ggplot(mpg) + 
  geom_point(aes(x = drv, y = cyl))


ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free_y")

# You can see that there are points missing, for example, for 5 cyl at 4
# and rear drive

# 3. What plots does the following code make? What does . do?

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

# The code above plots all the data across for horizontal facets, one for each drv

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# The above plots all data across vertical facets, one for each cyl
# . allows you to all the data against one facet variable.
# The alternative is to plot against var1 x var2 facets

# 4. Take the first faceted plot in this section:

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# What are the advantages to using faceting instead of the color aesthetic? 

# It is 508 compliant. Its viewable by colored blind, for example.


# What are the disadvantages? How might the balance change if you had a larger dataset?
  
# It is somewhat difficult to compare because the data are not spread over the range
# of x or y values. A larger dataset might help balance this issue.

# 5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options 
# control the layout of the individual panels? Why doesn’t facet_grid() 
# have nrow and ncol arguments?

?facet_wrap

# nrow and ncol determine the number of rows and columns

# as.table affects the positioning of the individual panels, TRUE ~ the facets 
# are laid out like a table with highest values at the bottom-right. 
# If FALSE, the facets are laid out like a plot with the highest value 
# at the top-right.

?facet_grid

# facet_grid() doesn't have nrow and ncol arguments because they are determined
# by the values of discrete variables


# 6. Which of the following plots makes it easier to compare engine size (displ) 
# across cars with different drive trains? What does this say about when 
# to place a faceting variable across rows or columns?


ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(drv ~ .)

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() +
  facet_grid(. ~ drv)

# The first plot with drv as a row is definitely easier to read than the second
# plot with drv as column. When comparing distributions, rows of facets works 
# better than columns of facets

# 7. Recreate the following plot using facet_wrap() instead of facet_grid(). How 
# the positions of the facet labels change?

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)


ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(drv ~ ., dir = "v", strip.position = "right")


# 10.5 Statistical transformations ---------------------------------------------


glimpse(diamonds)

# counts

ggplot(diamonds, aes(x = cut)) + 
  geom_bar()

?geom_bar

vignette("ggplot2-specs")

# proportions

ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()


# summary


ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  ) 

# Each stat is a function, so you can get help in the usual way, 
# e.g., ?stat_bin.

?stat_bin

?stat_summary

# 10.5.1 Exercises -------------------------------------------------------------

# 1. What is the default geom associated with stat_summary()? How could you 
# rewrite the previous plot to use that geom function instead of the stat 
# function?

?stat_summary

# geom = "pointrange" is the default geom


ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  ) 


ggplot(data = diamonds) +
  geom_pointrange(mapping = aes(x = cut, y = depth),
                  stat = "summary",
                  fun.ymin = min,
                  fun.ymax = max,
                  fun.y = median)



# 2. What does geom_col() do? How is it different from geom_bar()?

glimpse(diamonds)

ggplot(diamonds, aes(x = cut)) + 
  geom_bar()


ggplot(diamonds, aes(cut,carat)) + 
  geom_col(just = 0.5)

# geom_col() also creates a bar graph to justify how the columns are aligned

# 3. Most geoms and stats come in pairs that are almost always used in concert. 
#  Make a list of all the pairs. What do they have in common? (Hint: Read through 
#  the documentation.)

help("geom_bar")

help("geom_density")

geom is the shape of the object

ggplot(diamonds) + 
  stat_count(
    aes(x = cut, y = depth),

  )





























