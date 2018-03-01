# ------------------------------------------------------------------------------
# The t-test - Test stats, p-values, level of significance, type I and II errors
# ------------------------------------------------------------------------------

# Now it is your turn! 2-by-2 use the "t-test cook book" to state and evaluate a 
# hypothesis about:
#  1. Heights
#  2. Shoe size
# amongst the women and men in the SRH group (skip the data transformation step)

# Clear workspace
rm(list=ls())

# Load libraries
library('tidyverse')
library('broom')

# Load data
dat_srh = read_tsv(file = 'data/srh_group_data_clean.tsv')

# T-test cook book

# 1. Visualise the data with boxplot + jitter
dat_srh %>%
  ggplot(aes(x = sex, y = height, fill = sex)) +
  geom_boxplot(alpha=0.5) +
  geom_jitter() +
  theme_bw()

# 2. Consider transformation of data
# Skip!

# 3. Evaluate whether the standard deviation is similar or different between the
#    two groups

# First we get the data, that we are going to work on as vectors
x1 = dat_srh %>% filter(sex=='F') %>% pull(height)
x2 = dat_srh %>% filter(sex=='M') %>% pull(height)

# Then we calculate the standard deviations
s_x1 = sd(x1)
s_x2 = sd(x2)
s_ratio = max(c(s_x1,s_x2)) / min(c(s_x1,s_x2))
# Assuming variance homogeniety, i.e. equal variances

# 4. Identify if the observations are paired
# Nope!

# 5. Make a confidence interval for the difference between means and/or a test 
#    for the possibility that the difference is equal to zero

# First we start with a t-test
n1     = length(x1) # Number of observations in group 1
n2     = length(x2) # Number of observations in group 2
df     = n1 - 1 + n2 - 1 # Degrees of freedom
s_p    = sqrt( (s_x1^2 * (n1 - 1) + s_x2^2 * (n2 - 1)) / df ) # Pooled variance
x1_bar = mean(x1) # Mean of group 1
x2_bar = mean(x2) # Mean of group 2
t_obs  = (x1_bar - x2_bar) / (s_p * sqrt(1/n1 + 1/n2)) # Observed t-statistic
p      = 2 * pt(q = t_obs, df = df) # p-value

# Get 95% confidence interval
alpha = 0.05
ci_lower = (x1_bar - x2_bar) - qt(p = 1-alpha/2, df = df) * s_p * sqrt(1/n1 + 1/n2)
ci_upper = (x1_bar - x2_bar) + qt(p = 1-alpha/2, df = df) * s_p * sqrt(1/n1 + 1/n2)

# Compare with the somewhat more convinient built-in t.test()
t.test(x1, x2, var.equal = TRUE) %>% tidy

# 6. Comment on the results
# The men of the SRH group are significantly higher than the women!
