
# Chapter 2 - Data visualization


# install.packages("tidyverse")
# install.packages("palmerpenguins")


library(tidyverse)

library(palmerpenguins)


penguins

glimpse(penguins)

ggplot(data = penguins)


ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm)
)
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)

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
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point()
  
  
  ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point() +
  geom_smooth()
  
  
  ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth()
  
  
  ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth() +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)",
    y = "Body mass (g)",
    color = "Species",
    shape = "Species"
  )
  


# Start with Section 2.3. ggplot2 calls

ggplot(penguins, aes(x = species)) +
  geom_bar()
  
  
ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()
  
 
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)
  
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

penguins |>
  count(cut_width(body_mass_g, 200))
#> # A tibble: 19 × 2
#>   `cut_width(body_mass_g, 200)`     n
#>   <fct>                         <int>
#> 1 [2.7e+03,2.9e+03]                 7
#> 2 (2.9e+03,3.1e+03]                10
#> 3 (3.1e+03,3.3e+03]                23
#> 4 (3.3e+03,3.5e+03]                38
#> 5 (3.5e+03,3.7e+03]                39
#> 6 (3.7e+03,3.9e+03]                37
#> # … with 13 more rows

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)
  
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)
  
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 2000)



# 2.5 Visualizing relationships

# 2.5.1 A numerical and a categorical variable

# Setting the value of the aesthetics

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_freqpoly(binwidth = 200, linewidth = 0.75)

# Mapped:
# We can also use overlaid density plots, with 
# species *mapped* to both color and fill aesthetics 
# and using the alpha aesthetic to add transparency 
# to the filled density curves.

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)


# We map variables to aesthetics if we want the visual attribute 
# represented by that aesthetic to vary based on the values of that variable.
# Otherwise, we set the value of an aesthetic.

# 2.5.2 Two categorical variables


ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")


# 2.5.3 Two numerical variables


ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()


# 2.5.4 Three or more variables

# Mapping to the aesthetic

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

# Less clutter using facets

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)



# 2.6 Saving your plotswk

getwd()

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
ggsave(filename = "my-plot.png")





  
  



