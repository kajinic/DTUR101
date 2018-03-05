# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')

#   4. Statistical power
# ------------------------------------------------------------------------------
# Your turn... two-and-two:
#
# We want to design a study and we are interested in investigating if on average
# men are taller than women. I know we already performed this investigation, but
# let say that someone else did that particular study and you are interested in
# doing your own study.
#
# Question 1:
# How many subjects should you enroll in your study in order to have an
# 80% chance of detecting a significant difference in the average height at a
# level of significance of 95%?
#
# Question 2:
# How many subjects should you enroll in your study in order to have an
# 90% chance of detecting a significant difference in the average height at a
# level of significance of 99%?
#
# Question 3:
# Did you get the same results? Why/why not?

# Q1: First reproduce the results from the video:
t_star  = 2.0
n       = 10
mu_diff = 0.5
sigma   = 0.5
power   = 1 - pnorm( t_star - mu_diff / ( sigma * sqrt(2/n)) )
print(power)

# Now substitute with the values we want to investigate
t_star  = 2.0
n       = 7 # This number is found by simply testing different values of 'n'
mu_diff = 12.2
sigma   = 8.1
power   = 1 - pnorm( t_star - mu_diff / ( sigma * sqrt(2/n)) )
print(power)

# Q2: Like 1, but with different t_star value
t_star  = 2.6
n       = 13 # This number is found by simply testing different values of 'n'
mu_diff = 12.2
sigma   = 8.1
power   = 1 - pnorm( t_star - mu_diff / ( sigma * sqrt(2/n)) )
print(power)

# Q3
# Nope, n is higher in Q2, due to borh higher level of significance and power!

# Let us try to generalise the above

# n is now a vector of values: n = {1,2,...,20}
n = 2:20

# Beware in the following, for simplicity we are using qnorm() for calculating
# the critical value. In reality we should be using qt(). However, recall that
# if is sufficiently large, the t-distribution approaches the normal
# distribution.

# Calculate critical value t_star for level of significance 90%
alpha_90  = 0.10
t_star_90 = round(qnorm(1-alpha_90/2),1) # Approximation: 1.6
print(t_star_90)

# Calculate critical value t_star for level of significance 95%
alpha_95  = 0.05
t_star_95 = round(qnorm(1-alpha_95/2),1) # Approximation: 2.0
print(t_star_95)

# Calculate critical value t_star for level of significance 99%
alpha_99  = 0.01
t_star_99 = round(qnorm(1-alpha_99/2),1) # Approximation: 2.6
print(t_star_99)

# Set the prior knowledge on height
mu_diff = 12.2
sigma   = 8.1

# Calculate the power for the different levels of significance
# Note, since n is now a vector, we will get vectors of powers for different n
power_90 = 1 - pnorm( t_star_90 - mu_diff / ( sigma * sqrt(2/n)) )
power_95 = 1 - pnorm( t_star_95 - mu_diff / ( sigma * sqrt(2/n)) )
power_99 = 1 - pnorm( t_star_99 - mu_diff / ( sigma * sqrt(2/n)) )

# Let us visualise power versus n using our above calculations
p1 = tibble(n,power_90,power_95,power_99) %>% 
  gather(alpha,power,-n) %>% 
  mutate(alpha = factor(alpha)) %>% 
  ggplot(aes(x=n,y=power,colour=alpha)) +
  geom_line() +
  geom_hline(yintercept = 0.80, linetype = 'dashed') +
  theme_bw()
print(p1)

# The built in function in R, can be used as follows:
# Back to the inital questions:
# Q1: What should n be if the level of significance is 95% and the power 80%?
power.t.test(delta = mu_diff, sd = sigma, sig.level = alpha_95, power = 0.80)
# Q2: What should n be if the level of significance is 99% and the power 90%?
power.t.test(delta = mu_diff, sd = sigma, sig.level = alpha_99, power = 0.90)

# Let us repeat the visualisation using the build in function in R
p2 = tibble(n) %>% 
  mutate(power_90 = power.t.test(n = n, delta = mu_diff, sd = sigma,
                                 sig.level = alpha_90)$power,
         power_95 = power.t.test(n = n, delta = mu_diff, sd = sigma,
                                 sig.level = alpha_95)$power,
         power_99 = power.t.test(n = n, delta = mu_diff, sd = sigma,
                                 sig.level = alpha_99)$power) %>% 
  gather(alpha, power, -n) %>% 
  mutate(alpha = factor(alpha)) %>% 
  ggplot(aes(x = n, y = power, colour = alpha)) +
  geom_line() +
  geom_hline(yintercept = 0.80, linetype = 'dashed') +
  theme_bw()
print(p2)

# Okay, let us connect this to the manual t-test we performed on day 04,
# i.e. given the difference we found, what is P(t_obs >= t_star)

# Read the cleaned data
dat_srh = read_tsv(file = 'data/srh_group_data_clean.tsv')

# The we get the data, that we are going to work on as vectors
x1 = dat_srh %>% filter(sex=='F') %>% pull(height)
x2 = dat_srh %>% filter(sex=='M') %>% pull(height)

# Then number of observations in each group and corresponding degrees of freedom
n1 = length(x1)      # Number of observations in group 1
n2 = length(x2)      # Number of observations in group 2
df = n1 - 1 + n2 - 1 # Degrees of freedom

# Then we calculate the means
x1_bar = mean(x1) # Mean of group 1
x2_bar = mean(x2) # Mean of group 2

# and standard deviations and pooled variance
s_x1 = sd(x1)
s_x2 = sd(x2)
s_p  = sqrt( (s_x1^2 * (n1 - 1) + s_x2^2 * (n2 - 1)) / df ) # Pooled variance

# and finally the observed t
t_obs = (x2_bar - x1_bar) / (s_p * sqrt( 1/n1 + 1/n2 ))

# Finally we can calculate the power P(t_obs >= t_star)
alpha  = 0.05
t_star = qt(p = 1-alpha/2, df = df)
power  = 1 - pnorm( t_star - t_obs )
print(power)

# Have you ever read a paper, where they state the p-value is borderline
# significant and had they had more data, they would have had a greater power
# and then for sure their result would have been significant?
# ...did they actually do the power calculation to show you their power? ;-)

# Let me just show you something (I think is) cool:
#
# We can simulate height data based on our calculated descriptive statistics:
f = round(rnorm(n = n1, mean = x1_bar, sd = s_x1))
print(f)
m = round(rnorm(n = n2, mean = x2_bar, sd = s_x2))
print(m)

# Now, let us do that many times and see how often we find a significant
# difference usint a t-test and a level of significance of 95%, i.e. power:
p_values = rep(NA,1000)
for( i in 1:1000 ){
  f = round(rnorm(n = n1, mean = x1_bar, sd = s_x1))
  m = round(rnorm(n = n2, mean = x2_bar, sd = s_x2))
  p_values[i] = t.test(f, m, var.equal = TRUE)$p.val
}
print(sum(p_values <= 0.05) / 1000)

# Now let us do the same thing, but now let us see how often, we get a
# significant results, despite the null being true. Notice how we are drawing
# from the same distribution
p_values = rep(NA,1000)
for( i in 1:1000 ){
  f = round(rnorm(n = n1, mean = x1_bar, sd = s_x1))
  m = round(rnorm(n = n2, mean = x1_bar, sd = s_x1))
  p_values[i] = t.test(f, m, var.equal = TRUE)$p.val
}
print(sum(p_values <= 0.05) / 1000)

