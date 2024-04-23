

# 3.5 Exercises ----------------------------------------------------------------

# 1. Why does this code not work? Look carefully! (This may seem like an 
# exercise in pointlessness, but training your brain to notice even the
# tiniest difference will pay off when programming.)

my_variable <- 10
my_varıable

# There is a typo in the letter i

# 2. Tweak each of the following R commands so that they run correctly:

library(tidyverse)

ggplot(
  data = mpg, 
  mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(method = "lm")

# 3. Press Option + Shift + K / Alt + Shift + K. What happens? How can 
# you get to the same place using the menus?

# It shows all the key bindings. From the menu, Tools -> Keyboard 
# shortcut help

# 4. Let’s revisit an exercise from the Section 2.6. Run the following 
# lines of code. Which of the two plots is saved as mpg-plot.png? Why?

my_bar_plot <- ggplot(mpg, aes(x = class)) +
  geom_bar()
my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave(filename = "mpg-plot.png", plot = my_bar_plot)

# It plots the bar chart since plot = my_bar_plot

