# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())



# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')



# ------------------------------------------------------------------------------
#     2. Data visualisation
# ------------------------------------------------------------------------------

# Here is the data set we are going to work with
print(mtcars)

# You can examine the data set like so
?mtcars

# Let us convert the data set to a tibble for working with ggplot
# Note how we catch the column names before converting to a tibble
car_dat = mtcars %>% rownames_to_column(var = "car") %>% as_tibble
print(car_dat)

# Task 1
# Make a function, which translates 'mpg' into 'km_l'
mpg2kml = function(mpg){
  kml = 0.425 * mpg
  return( kml )
}

# Task 2 (data manipulation)
# Make a new variable in your car data set, holding the translated
# 'mpg'-to-'km_l' value
car_dat = car_dat %>% mutate(kml = mpg2kml(mpg))
car_dat = car_dat %>% mutate(kml = car_dat %>% pull(mpg))

# Task 3
# Make a scatter plot using the car data and ggplot of (hp, kml)
car_dat %>% 
  ggplot(aes(x = hp, y = kml, colour = factor(cyl))) +
  geom_point() +
  theme_bw() +
  ggtitle("My awesome plot") +
  xlab("Effect of engine [hp]") +
  ylab("Milage [km/L]") +
  labs(colour = "Number of cylinders") 

# Task 4
# Make a boxplot of (cylinders, kml)
car_dat %>% 
  ggplot(aes(x = cyl, y = kml, group = cyl)) +
  geom_boxplot() +
  theme_bw()

car_dat %>% 
  ggplot(aes(x = cyl, y = kml, fill = factor(cyl))) +
  geom_boxplot(alpha = 0.5) +
  theme_bw() +
  scale_fill_discrete(guide = FALSE)  +
  scale_x_continuous(breaks = c(4,6,8)) +
  coord_flip()

# Task 5
# Count how many cars have which number of cylinders?
car_dat %>% count(cyl)
car_dat %>% group_by(cyl) %>% summarise(n = n()) # Equivalent

# Task 6
# Use the count data you created, to make a barplot of the number of
# observations within each cylinder 'group'
car_dat %>% count(cyl) %>% 
  ggplot(aes(x = cyl, y = n, fill = factor(cyl))) + 
  geom_col(alpha = 0.5) +
  theme_bw() +
  scale_fill_discrete(guide = FALSE) +
  scale_x_continuous(breaks = c(4,6,8))

# Task 7
# What was wrong with the barplots we saw this morning?

# Other plots demonstrated on the fly:
car_dat %>% 
  ggplot(aes(x = hp, y = kml, colour = factor(cyl))) +
  geom_point() +
  theme_bw() +
  ggtitle("My awesome plot") +
  xlab("Effect of engine [hp]") +
  ylab("Milage [km/L]") +
  labs(colour = "Number of cylinders") +
  facet_wrap(~cyl)

car_dat %>% 
  ggplot(aes(x = hp, y = qsec)) +
  geom_point() + 
  geom_smooth(method = 'lm') +
  theme_bw()

car_dat %>% 
  ggplot(aes(x = hp, y = qsec, colour = factor(cyl))) +
  geom_point() + 
  geom_smooth(method = 'lm') +
  theme_bw()

library('ggrepel')
car_dat %>% filter(car != "Maserati Bora") %>% 
  ggplot(aes(x = hp, y = kml, colour = factor(cyl), label = car)) +
  geom_point() +
  geom_label_repel() +
  theme_bw() +
  ggtitle("My awesome plot") +
  xlab("Effect of engine [hp]") +
  ylab("Milage [km/L]") +
  labs(colour = "Number of cylinders") +
  theme(legend.position = "bottom")
