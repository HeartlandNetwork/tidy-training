

# ch10-Layers

# 10.1 Intro -------------------------------------------------------------------

library("tidyverse")




# 10.2 Aesthetic mappings ------------------------------------------------------

mpg

# Left
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# Right
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()

# Left
ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()

# Right
ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(color = "blue")

# More info...
# https://ggplot2.tidyverse.org/articles/ggplot2-specs.html


# 10.2.1 Exercises -------------------------------------------------------------

# 1. Create a scatterplot of hwy vs. displ where the points are pink 
# filled in triangles.

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(shape = 24) 

# 2. Why did the following code not result in a plot with blue points?

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, color = "blue"))

# The aes() needs to be specified for ggplot, not the geom.

# 3. What does the stroke aesthetic do? What shapes does it 
# work with? (Hint: use ?geom_point)

# Stroke refers to width of the line used to draw the geom

?geom_point

ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 1)


# 4. What happens if you map an aesthetic to something other than a variable 
# name, like aes(color = displ < 5)? Note, you’ll also need to specify x and y.



#ggplot(mtcars, aes(wt, mpg, color = displ < 5)) +
#  geom_point()
   

# It throws an error saying object 'displ' not found


# 10.3. Geometric objects ------------------------------------------------------

# Left
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point()

# Right
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_smooth()

# loess - locally estimated scatterplot smoothing


# aesthetics are often geom specific

# shape is silently ignored
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) + 
  geom_smooth()

# linetype is used
ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) + 
  geom_smooth()


# Adding the points data

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() +
  geom_smooth(aes(linetype = drv))

typeof(mpg$drv)



# original plot
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

# including group
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))

# implicit handling of groups
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)


# Mappings within the geom are specific to that geom

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) + 
  geom_smooth()


# Using different data within geoms

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

# Geoms are the building blocks of ggplot

# histogram
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

# density
ggplot(mpg, aes(x = hwy)) +
  geom_density()

# boxplot
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()




# further information...

# https://ggplot2.tidyverse.org/reference/

# https://exts.ggplot2.tidyverse.org/gallery/

# for gggrids
# https://wilkelab.org/ggridges/

# for individual geom
?geom_smooth

# new geom and mapping same variable to multiple aesthetics

library(ggridges)

ggplot(mpg, aes(x = hwy, y = drv, fill = drv, color = drv)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)


# 10.3.1 Exercises -------------------------------------------------------------

# 1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?

# line chart
# geom_smooth

# boxplot
# geom_boxplot

# historgram
# geom_histogram

# area chart
# geom_density()

# 2. Earlier in this chapter we used show.legend without explaining it:

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv),) # show.legend = TRUE)

# What does show.legend = FALSE do here? What happens if you remove it? Why do you think we used it earlier?

# It removes the legend for drv. If you remove it, it plots a legend. If you include it as FALSE, it plots
# the same as group = drv

# 3.What does the se argument to geom_smooth() do? It probably plots standard error area around the line.

# 4. Recreate the R code necessary to generate the following graphs. Note that wherever a categorical 
# variable is used in the plot, it’s drv.

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(aes(group = drv))

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(x = displ, y = hwy, color = drv)) + 
  geom_smooth(aes(linetype = drv))

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(x = displ, y = hwy, color = drv)) 


# 10.4 Facets ------------------------------------------------------------------


ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~cyl)


# facets drv by cyl

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl)

# allowing scales to be independent of each other

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free_y")


# 10.4.1 Exercises

# 1. What happens if you facet on a continuous variable?

glimpse(mpg)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_wrap(~displ)

# it attempts to plot a facet for each value

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? 
# Run the following code. How do they relate to the resulting plot?

ggplot(mpg) + 
  geom_point(aes(x = drv, y = cyl))

# They represent combinations of drv and cyl for which there are no data.

# 3. What plots does the following code make? What does . do?

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

# the . indicates no column of facets, only rows

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# the . indicates no row of facets, only columns

# 4. Take the first faceted plot in this section:

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# What are the advantages to using faceting instead of the color aesthetic? 

# You can use a 508 compliant display? Its easier to read

#   What are the disadvantages? How might the balance change if you had a larger dataset?

# Small datasets may occupy only a small part of the graph. This problem may diminish
# increasing sample size.

# 5. Read ?facet_wrap. What does nrow do? What does ncol do? 

# They specify the number of rows and columns for the facet display

# What other options control the layout of the individual panels? 

# as.table

# Why doesn’t facet_grid() have nrow and ncol arguments?

# Variables are assigned to row and column

?facet_grid


# 6. Which of the following plots makes it easier to compare engine size (displ) 
# across cars with different drive trains? What does this say about when 
# to place a faceting variable across rows or columns?

# The first plot with the distributions stacked by row. Using faceting by row
# is better for looking at histogram distributions.

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(drv ~ .)

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() +
  facet_grid(. ~ drv)

# 7. Recreate the following plot using facet_wrap() instead of facet_grid(). 
# How do the positions of the facet labels change?

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)


ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ drv, nrow = 3)



# 10.5 Statistical transformations ---------------------------------------------


ggplot(diamonds, aes(x = cut)) + 
  geom_bar()

# see the count stat for the geom_bar

?geom_bar

# Overriding the default stat, count, to use identity, lets us access the
# values from the the height of the bars

diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")

# Overriding the default mapping from transformed variables to aesthetics. 
# Displaying a bar chart of proportions, rather than counts

ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()

# Using stat_summary() which summarizes the y values for each unique x value, 
# to draw attention to the summary

ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

?stat_boxplot


ggplot(diamonds) + 
  stat_boxplot(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )


glimpse(diamonds)


# 10.5.1 Exercises

# 1. What is the default geom associated with stat_summary()? How could you 
# rewrite the previous plot to use that geom function instead of the 
# stat function?

?stat_summary

# The geometric object to use to display the data, either as a ggproto 
# Geom subclass or as a string naming the geom stripped of the geom_ 
# prefix (e.g. "point" rather than "geom_point")

# 2. What does geom_col() do? How is it different from geom_bar()?

ggplot(diamonds, aes(x = cut)) + 
  geom_bar()

ggplot(diamonds, aes(x = cut, y = depth )) +
  geom_col()

?geom_col()

# geom_col requires you to specify a y value

# 3. Most geoms and stats come in pairs that are almost always used in concert. 
# Make a list of all the pairs. What do they have in common? 
# (Hint: Read through the documentation.)

# Each has a corresponding stat that it uses as a default. The stat is 
# designed to meet the statistical requirements of the geom

?geom_bar
# stat_count

?geom_boxplot
# stat_boxplot

?geom_col
#stat_count

?geom_density
# stat_density

?geom_point
# stat = "identity"

# 4. What variables does stat_smooth() compute? What arguments control 
# its behavior

?geom_smooth

# arguments include 
# position = identity
# level = 0.95

# it returns the standard error by default, but can return confidence interval 
# set by level for loess() or glm()

# 5. In our proportion bar chart, we need to set group = 1. Why? In other words, 
# what is the problem with these two graphs?

ggplot(diamonds, aes(x = cut, y = after_stat(prop))) + 
  geom_bar()
ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop))) + 
  geom_bar()

# It looks like the proportions and frequencies are relative to themselves, 
# but not each other. So there is no grouping of the data. Here are the
# same plots with group = 1.

ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()

ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop), group = 1)) + 
  geom_bar()

# fill is not working here...

glimpse(diamonds)



# 10.6 Position adjustments

# Using the color aesthetic

ggplot(mpg, aes(x = drv, color = drv)) + 
  geom_bar()

# Using the fill aesthetic

ggplot(mpg, aes(x = drv, fill = drv)) + 
  geom_bar()

# Class allows the colors to be automatically stacked

ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar()


# Position = "identity", classes overlap


ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(alpha = 1/5, position = "identity")


ggplot(mpg, aes(x = drv, color = class)) + 
  geom_bar(fill = NA, position = "identity")


# identity works better for 2d plots like points where it 
# is the default


# fill - for comparing proportions

ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "fill")

# dodge - places overlapping things beside each other

ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "dodge")


# jitter - to show points hidden by overplotting

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(position = "jitter")

# for more info

?position_dodge

?position_fill

?position_jitter

?position_identity # default - don't do anything

?position_stack

# 10.6.1. Exercises

# 1. What is the problem with the following plot? How could you improve it?

ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point()

# The plot above overplots many points so they are hidden beneath each other.
# Jitter shows the extent of the sample size

ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point(position = "jitter")

# 2. What, if anything, is the difference between the two plots? Why?

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(position = "identity")

# They look the same. Identity is the default for scatterplots

# 3. What are the parameters to geom_jitter() control the amount of jittering?

?position_jitter

# width, height and seed. Seed is to start random numbers

# 4. Compare and contrast geom_jitter() with geom_count().


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_jitter()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_count()

# Count makes to points bigger or smaller depending on their frequency

# 5. What’s the default position adjustment for geom_boxplot()? Create a 
# visualization of the mpg dataset that demonstrates it.

ggplot(mpg) +
  geom_boxplot(aes(x = displ, y = hwy, group = drv))

glimpse(mpg)

?geom_boxplot

# The default position is dodge2, you get just one box.

?position_dodge2

# Unlike position_dodge(), position_dodge2() works without a grouping variable in a layer. 


# 10.7 Coordinate systems ------------------------------------------------------

# coord_quickmap() sets the aspect ratio correctly for geographic maps

nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

# coord_polar() uses polar coordinates

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = clarity, fill = clarity), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1)

bar + coord_flip()
bar + coord_polar()

# 1. Turn a stacked bar chart into a pie chart using coord_polar().

bar <- ggplot(mpg, aes(x = drv, fill = class)) + 
  geom_bar(position = "fill")

bar

bar + coord_flip()


bar <- ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = drv, fill = drv),
           show.legend = FALSE,
           width = 1) + 
  theme(aspect.ratio = 1)
  
bar

bar + coord_flip()
bar + coord_polar()

bar <- ggplot(mpg, aes(x = factor(1), fill = class)) + 
  geom_bar(width = 1)

bar + coord_polar(theta = "y")

pie <- ggplot(mtcars, aes(x = factor(1), fill = factor(cyl))) +
  geom_bar(width = 1)

pie + coord_polar(theta = "y")

pie

?coord_polar() # Need to read this...

# 2. What’s the difference between coord_quickmap() and coord_map()?


nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) +1
  geom_polygon(fill = "white", color = "black")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

?coord_map

# From the help from coord_Map(), coord_quickmap() is a quick approximation 
# that does preserve straight lines. It works best for smaller areas closer 
# to the equator.

# 3. What does the following plot tell you about the relationship 
# between city and highway mpg? Why is coord_fixed() important? What does 
# geom_abline() do?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

# Cars generally have higher mpg thna city mpg.

# coord_fixed() fixes the aspect ration between x and y coordinates. The default
# ration is 1:1 which, in this example, allows you to directly compare highway 
# and city mpg. 

# geom_abline() adds a referencee line at the 1:1 ratio.



# 10.8 The layered grammer of graphics -----------------------------------------

# Template

# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#    mapping = aes(<MAPPINGS>),
#    stat = <STAT>, 
#    position = <POSITION>
#  ) +
#  <COORDINATE_FUNCTION> +
#  <FACET_FUNCTION>

# ggplot2 will provide useful defaults for everything except 
# 1) the data, 2) the mappings, and 3) the geom function

# grammar of graphics
# -------------------
#  - dataset 
#  - geom 
#  - a set of mappings 
#  - a stat 
#  - a position adjustment 
#  - a coordinate system
#  - a faceting scheme 
#  - a theme.





















