# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')

# Load clean data
# ------------------------------------------------------------------------------
dat_srh = read_tsv(file = 'data/srh_group_data_clean.tsv')

# Wrangle data
# ------------------------------------------------------------------------------
# Update sex variable to factor variable
dat_srh = dat_srh %>% mutate(sex = sex %>% factor)



# ------------------------------------------------------------------------------
#     4. Correlation and covariance
# ------------------------------------------------------------------------------
# Your turn: two-and-two using the SRH data, calculate the covariance and
# correlation for the 'height' and 'shoe_size' variables
# As usual, do not use the built-in functions in R, but construct the
# calculation, based on what you have been shown in the video
#
# Questions:



# ------------------------------------------------------------------------------
#     1. See if you can conceptually connect covariance to standard deviation
# ------------------------------------------------------------------------------
# The standard deviation is a measure of how much a single variable varies. The
# covariance is similar, but for how two variables vary together.



# ------------------------------------------------------------------------------
#     2. Calculate the covariance for the 'height' and 'shoe_size' variables
# ------------------------------------------------------------------------------

# First, get the vectors we will work on
x = dat_srh %>% pull(height)
y = dat_srh %>% pull(shoe_size)

# Then calculate number of observations and means
x_bar = mean(x)
y_bar = mean(y)
n = length(x)

# Lastly, calculate the covariance
s_xy_1 = 1/(n-1) * sum( (x - x_bar) * (y - y_bar) )
print(s_xy_1)

# OR (not using the sum() function, but a "manual" loop)
my_sum = 0
for( i in 1:n ){
  my_sum = my_sum + ( x[i] - x_bar ) * ( y[i] - y_bar )
}
s_xy_2 = 1/(n-1) * my_sum
print(s_xy_2)

# Compare
s_xy_3 = cov(x,y)
print(s_xy_3)

# In continuation of the first question, compare s_xy with s_x and s_y
s_x_1 = sqrt( 1/(n-1) * sum( ( x - x_bar ) ** 2 ) )
s_y_1 = sqrt( 1/(n-1) * sum( ( y - y_bar ) ** 2 ) )

# Compare
s_x_2 = sd(x)
s_y_2 = sd(y)



# ------------------------------------------------------------------------------
#     3. Calculate the correlation for the 'height' and 'shoe_size' variables
# ------------------------------------------------------------------------------
r_xy_1 = s_xy_1 / ( s_x_1 * s_y_1 )
print(r_xy_1)

# Compare
r_xy_2 = cor(x,y)
print(r_xy_2)



# ------------------------------------------------------------------------------
#     4. Extra: One thing we have not touched upon are the concepts of
#        sensitivity and specificity:
#
#        Your supervisor wants you to calculate the sensitivity and specificity
#        of an assay you have developed.
#
#        Use google to find out what they are and how they are calculated and
#        then calculate them for the data below (Manually, do not use packages!
#        Additionally - try to use tidyverse verbs for manipulating your data)
#        Also, look at the code and see if you can figure our what is going on
#        and why you get different results in A and B:
# ------------------------------------------------------------------------------
set.seed(718391)
n = 100
d = c('TP','FP','TN','FN')

# A
probs   = c(0.25, 0.25, 0.25, 0.25)
results = sample(x = d, size = n, prob = probs, replace = TRUE)
results = as_tibble(table(results))
print(results)

# Get values
FN = results %>% filter(results == 'FN') %>% pull(n)
FP = results %>% filter(results == 'FP') %>% pull(n)
TN = results %>% filter(results == 'TN') %>% pull(n)
TP = results %>% filter(results == 'TP') %>% pull(n)

# Sensitivity
sens_A = TP / ( TP + FN )
print(sens_A)

# Specificity
spec_A = TN / ( TN + FP )
print(spec_A)

# B
probs   = c(0.40, 0.10, 0.40, 0.10)
results = sample(x = d, size = n, prob = probs, replace = TRUE)
results = as_tibble(table(results))
print(results)

# Get values
FN = results %>% filter(results == 'FN') %>% pull(n)
FP = results %>% filter(results == 'FP') %>% pull(n)
TN = results %>% filter(results == 'TN') %>% pull(n)
TP = results %>% filter(results == 'TP') %>% pull(n)

# Sensitivity
sens_B = TP / ( TP + FN )
print(sens_B)

# Specificity
spec_B = TN / ( TN + FP )
print(spec_B)

# Congratulations, you are now allowed to use the following functions in R:
sum()
mean()
sd()
t.test()
power.t.test()
cov()
cor()
sample()
table()
