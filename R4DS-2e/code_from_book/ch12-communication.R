
# ch12-communication.R


library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)

# 12.2 Labels

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Car type",
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

# Using quote for math equations


df <- tibble(
  x = 1:10,
  y = cumsum(x^2)
)




ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(x[i]),
    y = quote(sum(x[i] ^ 2, i == 1, n))
  )


# 12.2.1 Exercises

# 1. Create one plot on the fuel economy data with customized title, subtitle, 
# caption, x, y, and color labels.

glimpse(mpg)

# This doesn't include color

ggplot(mpg, aes(x = hwy, y = fct_reorder(manufacturer, hwy, median))) +
  geom_boxplot() +
  labs(
    x = "Highway fuel economy (mpg)",
    y = "Manufacturer",
    title = "Honda Leads the Pack in Overall Fuel Economy",
    subtitle = "Honda exceeds all other manufacturers in hwy mpg",
    caption = "Data from fueleconomy.gov"
  )
  
# 2. Recreate the following plot using the fuel economy data. 
# Note that both the colors and shapes of points vary by type 
# of drive train.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Drive train",
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Say something about drive train here",
    caption = "Data from fueleconomy.gov"
  )



# 3.Take an exploratory graphic that you’ve created in the last month, 
# and add informative titles to make it easier for others to understand.

setwd("C:/Users/GRowell/work/BP/R-BP")


# blood pressure 2022-2023

bp_data <- read_csv("blood_pressure_2022_2023.csv")

bp_data <- bp_data |>
  mutate(year = factor(year))

view(bp_data)

#create plot with two lines

ggplot(bp_data, aes(month)) +  
  geom_line(aes(y = ave_systolic, color = year),size = 1) +
  geom_line(aes(y = ave_diastolic, color = year),size = 1) +
  labs(
    y = "mm HG",
    title = "Gareth Rowell - Monthly Average Blood Pressure",
    subtitle = "Comparison between 2022 and 2023 - values measured at trough"

    ) +
    coord_cartesian(xlim = c(1, 12), ylim = c(50, 150))


# 12.3 Annotations -------------------------------------------------------------

# Creating a dataframe called label_info

label_info <- mpg |>
  group_by(drv) |>
  arrange(desc(displ)) |>
  slice_head(n = 1) |>
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  ) |>
  select(displ, hwy, drv, drive_type)

label_info


ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_text(
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
  ) +
  theme(legend.position = "none")

# use the geom_label_repel() to automatically adjust labels so 
# that they don’t overlap

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_label_repel( #<<<<<<<<<<<<<<<<<<<<<
    data = label_info, 
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")

# highlight certain points on a plot with geom_text_repel() 

potential_outliers <- mpg |>
  filter(hwy > 40 | (hwy > 20 & displ > 5))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_text_repel(data = potential_outliers, aes(label = model)) +
  geom_point(data = potential_outliers, color = "red") +
  geom_point(
    data = potential_outliers,
    color = "red", size = 3, shape = "circle open"
  )


# Using annotate with string wrap

trend_text <- "Larger engine sizes tend to have lower fuel economy." |>
  str_wrap(width = 30)

trend_text

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  annotate(
    geom = "label", x = 3.5, y = 38,
    label = trend_text,
    hjust = "left", color = "red"
  ) +
  annotate(
    geom = "segment",
    x = 3, y = 35, xend = 5, yend = 25, color = "red",
    arrow = arrow(type = "closed")
  )


# 12.3.1 Exercises  --------- REREAD section on Annotation!!

# 1. Use geom_text() with infinite positions to place text at the four corners 
# of the plot.

ggplot(mpg, aes(hwy, cty, label = "sometext")) +
  geom_point() +
  annotate(geom = 'text', 
           x = 45,  y = 10,
           label = 'my_text') 


# 2. Use annotate() to add a point geom in the middle of your last plot without 
# having to create a tibble. Customize the shape, size, or color of the point.

ggplot(mpg, aes(hwy, cty, label = "sometext")) +
  geom_point() +
  annotate(
    geom = "point",
    x = 3, y = 35, color = "red", shape = 10, size = 5
  ) 
  

# 3. How do labels with geom_text() interact with faceting? How can you add a 
# label to a single facet? How can you put a different label in each facet? 
# (Hint: Think about the dataset that is being passed to geom_text().



label_info <- mpg |>
  group_by(drv) |>
  arrange(desc(displ)) |>
  slice_head(n = 1) |>
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  ) |>
  select(displ, hwy, drv, drive_type)

label_info

ggplot(mpg, aes(displ, hwy)) + 
  geom_point() + 
  facet_wrap(~drv) + 
  geom_label_repel(
    data = label_info,
    aes(x = displ, y = hwy, label = drive_type),
    fontface = "bold", size = 5
  )


# 4. What arguments to geom_label() control the appearance of the background box?

geom_label_repel

  
# 5. What are the four arguments to arrow()? How do they work? Create a series 
# of plots that demonstrate the most important options.


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() + 
  annotate(
    geom = "segment",
    x = 25, y = 5, xend = 10, yend = 35, color = "red",
    arrow = arrow(type = "closed")
  )


# 12.4 Scales ------------------------------------------------------------------


# 12.4.1 Default scales

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()


# 12.4.2 Axis ticks and legend keys

# The use of breaks is to override the default choice

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5)) 

# Suppressing labels

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) +
  scale_color_discrete(labels = c("4" = "4-wheel", "f" = "front", "r" = "rear"))


# Default labelling with label_dollar()

ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(labels = label_dollar())

# Further customization by dividing dollar values by 1,000 and adding a suffix “K” 
# (for “thousands”) as well as adding custom breaks. Note that breaks is in the 
# original scale of the data.


ggplot(diamonds, aes(x = price, y = cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(
    labels = label_dollar(scale = 1/1000, suffix = "K"), 
    breaks = seq(1000, 19000, by = 6000)
  )

# Another handy label function is label_percent()

ggplot(diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Percentage", labels = label_percent())

# Another use of breaks is when you have relatively few data points and want to 
# highlight exactly where the observations occur.

presidential

presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(name = NULL, breaks = presidential$start, date_labels = "'%y")

# 12.4.3 Legend layout -o control the overall position of the legend, you need 
#   to use a theme() setting

base <- ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))

base + theme(legend.position = "right") # the default
base + theme(legend.position = "left")
base + 
  theme(legend.position = "top") +
  guides(color = guide_legend(nrow = 3))
base + 
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 3))

# To control the display of individual legends, use guides() along with 
# guide_legend() or guide_colorbar(). 

# Note that the name of the argument in guides() matches the name of the aesthetic, 
# just like in labs()


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(nrow = 2, override.aes = list(size = 4)))


# 12.4.4 Replacing a scale
# The two types of scales you’re mostly likely to want to switch out: 
# continuous position scales and color scales

# This example also addresses variable transformations

# Left
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d()

# Right
ggplot(diamonds, aes(x = log10(carat), y = log10(price))) +
  geom_bin2d()

# In this last example the axes are now labelled with the transformed values, 
# making it hard to interpret the plot

# Instead of doing the transformation in the aesthetic mapping, we can instead do 
# it with the scale. This is visually identical, except the axes are labelled on 
# the original data scale.

ggplot(diamonds, aes(x = carat, y = price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

# Customizing color for colored blindness

ggplot(mpg, aes(x = displ, y = hwy)) +  # default
  geom_point(aes(color = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1") # changing color scale

# Here is a simpler techniques for improving accessibility

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_color_brewer(palette = "Set1")

# Neither of these are especially good for color-blindness

#https://colorbrewer2.org/RColorBrewer 

library(RColorBrewer)

# When you have a predefined mapping between values and colors, use 
# scale_color_manual(). 


presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))



# Viridis color scales. The designers, Nathaniel Smith and Stéfan van der Walt, 
# carefully tailored continuous color schemes that are perceptible to people 
# with various forms of color blindness as well as perceptually uniform in 
# both color and black and white. These scales are available as continuous 
# (c), discrete (d), and binned (b) palettes in ggplot2.

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  labs(title = "Default, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_c() +
  labs(title = "Viridis, continuous", x = NULL, y = NULL)

ggplot(df, aes(x, y)) +
  geom_hex() +
  coord_fixed() +
  scale_fill_viridis_b() +
  labs(title = "Viridis, binned", x = NULL, y = NULL)


# 12.4.5 Zooming 

# The original plot

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

# Filtering to zoom - subsetting the data

mpg |>
  filter(displ >= 5 & displ <= 6 & hwy >= 10 & hwy <= 25) |>
  ggplot(aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth()

# Zoom by using "limits" - this is equivalent to subsetting the data

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  scale_x_continuous(limits = c(5, 6)) +
  scale_y_continuous(limits = c(10, 25))

# Zooming via cartesian coordinates - this is the actual zoom

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 6), ylim = c(10, 25))


# If you want to match scales across different plots
# Set the limits on individual scales is generally more useful 

# The next two plots are difficult to compare since
#   their scales are so different

suv <- mpg |> filter(class == "suv")
compact <- mpg |> filter(class == "compact")

# Left
ggplot(suv, aes(x = displ, y = hwy, color = drv)) +
  geom_point()

# Right
ggplot(compact, aes(x = displ, y = hwy, color = drv)) +
  geom_point()

# In the next two plots, this problem is solved using
#   share scales across multiple plots

x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_color_discrete(limits = unique(mpg$drv))

# Left
ggplot(suv, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

# Right
ggplot(compact, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale


# 12.4.6 Exercises--------------------------------------------------------------

# 1. Why doesn’t the following code override the default scale?

# The plot needs to be using scale_fill_gradient

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
)

ggplot(df, aes(x, y)) +
  geom_hex() +
  #scale_color_gradient(low = "white", high = "red") +
  scale_fill_gradient(low = "white", high = "red") +
  coord_fixed()


  
# 2. What is the first argument to every scale? How does it compare to labs()?

# Both have name - value pairs starting with labels

  
# 3. Change the display of the presidential terms by:

glimpse(presidential)


presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))



#   a.  Combining the two variants that customize colors and x axis breaks.

# I think this means to combine the colors and x axis breaks

presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) 
  # geom_segment(aes(xend = end, yend = id)) +
  #scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))


#   b. Improving the display of the y axis.

q <- presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3")) +
  labs(title = "Presidential terms", x = NULL, y = "President") +
  coord_cartesian(ylim = c(30, 45))


#   c. Labeling each term with the name of the president.

p <- presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(x = start, y = reorder(name,id), color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = name)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))
  

#   d. Adding informative plot labels.

r <- q +
  geom_label(fill = "gray92", label.size = NA, label = presidential$name)

r

#   e. Placing breaks every 4 years (this is trickier than it seems!).

r +
  scale_x_date(name = NULL, breaks = presidential$start, date_labels = "'%y")


# 4. First, create the following plot. Then, modify the code using override.aes 
# to make the legend easier to see.

ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(aes(color = cut), alpha = 1/20)

# ... from https://aosmith.rbind.io/2020/07/09/ggplot2-override-aes/

ggplot(data = diamonds, aes(x = carat, y = price, color = cut) ) +
  geom_point(alpha = .25, size = 1) +
  guides(color = guide_legend(override.aes = list(size = 3) ) )



# 12.5 Themes ------------------------------------------------------------------


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()   # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# theme_gray() is the default

# Note that customization of the legend box and plot title elements of the 
# theme are done with element_*() functions.

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  labs(
    title = "Larger engine sizes tend to have lower fuel economy",
    caption = "Source: https://fueleconomy.gov."
  ) +
  theme(
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
    plot.title = element_text(face = "bold"),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0)
  )


# 12.5.1 Exercises
# 1. Pick a theme offered by the ggthemes package and apply it to the last plot 
# you made. 

# 2. Make the axis labels of your plot blue and bolded.


nontrough_text <- "April - September 2023 are non-trough values." |>
  str_wrap(width = 30)
nontrough_text

ggplot(bp_data, aes(month)) +  
  geom_line(aes(y = ave_systolic, color = year),size = 1) +
  geom_line(aes(y = ave_diastolic, color = year),size = 1) +
  labs(
    y = "mm HG",
    title = "Gareth Rowell - Monthly Average Blood Pressure",
    subtitle = "Comparison between 2022 and 2023"
    
  ) +
  coord_cartesian(xlim = c(1, 12), ylim = c(50, 150)) +
  annotate(
    geom = "label", x = 4, y = 120,
    label = nontrough_text,
    hjust = "left", color = "red"
  ) +
  theme_bw() +
  theme(legend.position = "top", 
        axis.title.x = element_text(face = "bold", color = "blue"),
        axis.title.y = element_text(face = "bold", color = "blue"))
 



# 12.6 Layout ------------------------------------------------------------------

# Plotting multiple plots together

p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")
p1 + p2

# The next two examples use patchwork library
  
# Using a pipe to contol the layout of multiple plots

p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")
(p1 | p2) / p3

# Sharing a common legend, title, caption

p1 <- ggplot(mpg, aes(x = drv, y = cty, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 1")

p2 <- ggplot(mpg, aes(x = drv, y = hwy, color = drv)) + 
  geom_boxplot(show.legend = FALSE) + 
  labs(title = "Plot 2")

p3 <- ggplot(mpg, aes(x = cty, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 3")

p4 <- ggplot(mpg, aes(x = hwy, color = drv, fill = drv)) + 
  geom_density(alpha = 0.5) + 
  labs(title = "Plot 4")

p5 <- ggplot(mpg, aes(x = cty, y = hwy, color = drv)) + 
  geom_point(show.legend = FALSE) + 
  facet_wrap(~drv) +
  labs(title = "Plot 5")

(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
  plot_annotation(
    title = "City and highway mileage for cars with different drive trains",
    caption = "Source: https://fueleconomy.gov."
  ) +
  plot_layout(
    guides = "collect",
    heights = c(1, 3, 2, 4)
  ) &  #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  theme(legend.position = "top") #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# 11.6.1 Exercises

# 1. What happens if you omit the parentheses in the following plot layout. Can you explain why this happens?

# The / operator takes precedence over the | operator. This kind of follows math operators
  
p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
  geom_boxplot() + 
  labs(title = "Plot 2")
p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point() + 
  labs(title = "Plot 3")

(p1 | p2) / p3



# 2. Using the three plots from the previous exercise, recreate the following patchwork.

p1 / (p2 | p3)




