# Clear workspace
rm(list=ls())

# ------------------------------------------------------------------------------
# Recap of last class
# ------------------------------------------------------------------------------
# Difference between NaN and NA
# - NaN means not-a-number, some entity, which is not defined, e.g. 0/0
# - Note that 1/0 and -1/0 is NOT NaN, but Inf and -Inf respectively
# - NA means not-available, i.e missing data
# Let's see it
0/0
1/0
-1/0

# We were introduced to tidyverse
library('tidyverse')

# and found out, that this
100 %>% rnorm %>% sample(10) %>% mean %>% round(3) %>% sign

# Is much easier to code and read than
sign(round(mean(sample(rnorm(100),10)),3))

# Then we learned to load an excel file
library('readxl')
dat_srh = read_excel(path = "data/srh_group_data.xlsx")

# ...and we looked as some basic tidyverse functions

# Look at the data
dat_srh %>% View

# Filter rows - Get rows with no NA
dat_srh %>% filter(complete.cases(.))

# Filter on NA in single variable
dat_srh %>% filter(!is.na(height))

# Select certain columns of interest
dat_srh %>% select(height, `shoe size`)

# Rename variable
dat_srh %>% rename(shoe_size = `shoe size`)

# Create new variable
dat_srh %>% mutate(ran_group = sample(c(1,2), nrow(.), replace = TRUE))

# Pull out a single variable as a vector
dat_srh %>% pull(height)

# and we did a basic scatter plot of height ~ shoesize
dat_srh %>% filter(!is.na(`shoe size`)) %>% select(name, height, `shoe size`) %>%
  ggplot(aes(x = `shoe size`, y  = height)) +
  geom_smooth(method="lm") +
  geom_point() +
  geom_text(aes(label = name), nudge_y = 1) +
  xlab("Explanatory variable: Shoe size") +
  ylab("Response variable: Height") +
  ggtitle("Modelling height as a function of shoe size") +
  theme_bw()
ggsave(filename = 'figures/shoe_size_vs_height.png',
       width = 8, height = 5)

# ------------------------------------------------------------------------------
# Data visualisation continued
# ------------------------------------------------------------------------------

# Clear workspace and load libraris
rm(list=ls())
library('tidyverse')
library('readxl')

# Load data
dat_srh = read_excel(path = "data/srh_group_data.xlsx")

# boxplot - no grouping
dat_srh %>%
  ggplot(aes(x = 'all', y = height)) +
  geom_boxplot()

# boxplot - grouping
dat_srh %>%
  ggplot(aes(x = sex, y = height)) +
  geom_boxplot()

# histogram
dat_srh %>%
  ggplot(aes(x = height)) +
  geom_histogram(binwidth = 10)

# Densitogram
dat_srh %>%
  ggplot(aes(x = height)) +
  geom_density()

# barplot and densitogram
dat_srh %>%
  ggplot(aes(x = height)) +
  geom_histogram(aes(y = ..density..), binwidth = 10) +
  geom_density()

# Densitogram - grouping
dat_srh %>%
  ggplot(aes(x = height, fill = sex)) +
  geom_density(alpha = 0.5)

# Violin plot - no grouping
dat_srh %>%
  ggplot(aes(x = 'all', y = height)) +
  geom_violin()

# Violin plot - grouping
dat_srh %>%
  ggplot(aes(x = sex, y = height)) +
  geom_violin()

# Do not replace a boxplot with a barchart!
dat_srh %>% filter(!is.na(height)) %>% select(height,sex) %>% group_by(sex) %>%
  summarise(mu=mean(height),sigma=sd(height)) %>% 
  ggplot(aes(x = sex, y = mu, fill = sex)) +
  geom_bar(position=position_dodge(), stat="identity", alpha = 0.5) +
  geom_errorbar(aes(ymin = mu - sigma, ymax = mu + sigma), width=.2) +
  coord_cartesian(ylim = c(160,195)) +
  theme_bw()

# Combi plot
dat_srh %>% filter(!is.na(height)) %>% select(height,sex) %>% mutate(sex=factor(sex)) %>% 
  ggplot(aes(x = sex, y = height, fill = sex)) +
  geom_violin(scale = 'width', alpha = 0.5, adjust = 0.5) +
  geom_boxplot(width = 0.2) +
  geom_jitter(shape = 1,size = 5,colour = "black") +
  theme_bw()


# ------------------------------------------------------------------------------
# Data distribution and probability
# ------------------------------------------------------------------------------

# Now it is your turn to work - 2-by-2:
#
#  1. If you select a random member of the SRH group, what is the probality,
#     that that member is 180 or higher?
#     Hints:
#     a) Calculate the mean height in the SRH group
#     b) Calculate the standard deviation of the height in the SRH group
#     c) Use pnorm() to calculate the sought probability
mean_height = dat_srh %>% filter(height %>% is.na %>% `!`) %>% pull(height) %>% mean
sd_height = dat_srh %>% filter(height %>% is.na %>% `!`) %>% pull(height) %>% sd
p = 1 - pnorm(q = 180, mean = mean_height, sd = sd_height)
print(p)
# OR (preferable)
dat_srh %>% filter(height %>% is.na %>% `!`) %>%
  summarise(mu = mean(height), sigma = sd(height)) %>%
  mutate(p = 1 - pnorm(q = 180, mean = mu, sd = sigma))

#  2. If you select a random woman of the SRH group, what is the probality,
#     that that woman is 180 or higher?
#  3. If you select a random man of the SRH group, what is the probality,
#     that that man is 180 or higher?
dat_srh %>% filter(height %>% is.na %>% `!`) %>% group_by(sex) %>% 
  summarise(mu = mean(height), sigma = sd(height)) %>%
  mutate(p = 1 - pnorm(q = 180, mean = mu, sd = sigma))

#  4. The barplot and densitogram we made earlier does not look particularly
#     bell-shaped - Why do you think this is?
# Due to low sample size and bi-modality in that we are mixing height data from
# women and men, despite knowing that men are higher than women

#  5. Based on the height data of the SRH group, how high are Danish women and
#     men on average?
#     Hints:
#     a) From our sample, calculate an estimate of the population mean
#     b) Calculate confidence interval of the estimate
library('broom') # The 'tidy' function, which cleans up output from t.test()
F_height_est = dat_srh %>% filter(height %>% is.na %>% `!`, sex=='F') %>%
  pull(height) %>% t.test %>% tidy %>% select(estimate,conf.low,conf.high)
print(F_height_est)
M_height_est = dat_srh %>% filter(height %>% is.na %>% `!`, sex=='M') %>%
  pull(height) %>% t.test %>% tidy %>% select(estimate,conf.low,conf.high)
print(M_height_est)

# OR (advanced, but just wanted to show you)
dat_srh %>% filter(height %>% is.na %>% `!`) %>% group_by(sex) %>%
  do(t.test(.$height) %>% tidy) %>% ungroup %>%
  select(sex,estimate,conf.low,conf.high) %>% 
  print

#  6. The "true" average height of Danish men and women is 181.4 and 167.2
#     respectively*. Does your estimate include these values?
#     *http://cphpost.dk/news/danish-men-fifth-tallest-in-the-world.html
# Yep!
