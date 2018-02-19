# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')
library('readxl')
library('cowplot') # Note, new lib!
library('broom')   # Note, new lib!

# ------------------------------------------------------------------------------
# Briefly on cleaning data
# ------------------------------------------------------------------------------

# Load data
dat_srh = read_excel(path = "data/srh_group_data.xlsx")

# Look at the first 10 rows
dat_srh %>% head(10)

# Look at the last 10 rows
dat_srh %>% tail(10)

# Clean data
# Note, you cannot run this pipeline two times. It is aimed at cleaning the data
# and you cannot clean already cleaned data
dat_srh = dat_srh %>%
  rename(shoe_size = `shoe size`) %>%
  filter(shoe_size %>% is.na %>% `!`) %>%
  select(name, height, shoe_size, sex) %>% 
  mutate(sex = sex %>% factor)

# Write data
write_tsv(x = dat_srh, path = 'data/srh_group_data_clean.tsv')

# Clear workspace
rm(list=ls()) # Note, this does NOT unload the packages

# Load clean data
dat_srh = read_tsv(file = 'data/srh_group_data_clean.tsv')

# Update sex variable to factor variable
dat_srh = dat_srh %>% mutate(sex = sex %>% factor)

# ------------------------------------------------------------------------------
# The standard normal distribution
# ------------------------------------------------------------------------------

# Let's make a set of normal distributed observations
set.seed(797870) # Reproducible random numbers (counter intuitive - I know!)
mu = 10 # The mean of our observations
sigma = 5 # The standard deviation of our observations
s = rnorm(n = 1000, mean = mu, sd = sigma)

# They look like this
s %>% as_tibble %>% ggplot(aes(x=value)) + geom_density()

# Now let us transform the observations
z = ( s - mean(s) ) / sd(s)

# The transformed observations look like this
z %>% as_tibble %>% ggplot(aes(x=value)) + geom_density()

# Let us see them together and discuss what happened
tibble(s=s, z=z) %>%
  ggplot() +
  geom_density(aes(x=s)) +
  geom_density(aes(x=z))

# Let us take a look of this in context of the data we have been working with

# The untransformed height data stratified on sex looks like this
p1 = dat_srh %>%
  ggplot(aes(x = height, fill = sex)) +
  geom_density(alpha = 0.5) +
  theme_bw()
print(p1)

# Let's do the transformation
dat_srh = dat_srh %>%
  group_by(sex) %>%
  mutate(z_height_sex = (height - mean(height)) / sd(height),
         z_height_sex = z_height_sex %>% round(2)) %>% 
  ungroup

# And see how it looks now
p2 = dat_srh %>%
  ggplot(aes(x = z_height_sex, fill = sex)) +
  geom_density(alpha = 0.5) +
  theme_bw()
print(p2)

# The reason we loaded the cowplot library, was to able to do this
plot_grid(p1, p2, nrow = 2)

# Using the transformed height data, we can plot how each observation
# deviates from the mean
dat_srh %>%
  ggplot(aes(x=reorder(name,-z_height_sex), y=z_height_sex, fill = sex)) +
  geom_bar(stat = 'identity', alpha=0.5) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# It seems that for the mean, Nikolaj is very close to the average and likewise
# is Trine for the women, let's see the numbers
dat_srh %>% filter(name == 'Nikolaj' | name == 'Trine')

# and compare with the means
dat_srh %>% group_by(sex) %>% summarise(mu = height %>% mean %>% round(2))

# ------------------------------------------------------------------------------
# Statistical Hypothesis
# ------------------------------------------------------------------------------

# White board stuff! Flip-a-coin example...

# ------------------------------------------------------------------------------
# The t-test - Test stats, p-values, level of significance, type I and II errors
# ------------------------------------------------------------------------------

# Now it is your turn! 2-by-2 use the "t-test cook book" to state and evaluate a 
# hypothesis about:
#  1. Heights
#  2. Shoe size
# amongst the women and men in the SRH group (skip the data transformation step)

# The t-test cook book
#     1. Visualise the data with a boxplot + jitter
#     2. Consider transformation of the data (skip)
#     3. Evaluate whether the standard deviation is similar of different
#        between the two groups
#     4. Identify if the observations are paired
#     5. Make a confidence interval for the difference between means and/or a
#        test for the probability of the difference is equal to zero
#     6. Comment on the results

# see R/day_04_exercise.R