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

# Program of the day
# ------------------------------------------------------------------------------
#     1. Midway evaluation
#     2. Recapitulation of previous class
#     3. Summary of statistical concepts
#     4. Correlation and covariance



# ------------------------------------------------------------------------------
#     1. Midway evaluation
# ------------------------------------------------------------------------------
# Hand out



# ------------------------------------------------------------------------------
#     2. Recapitulation of previous class
# ------------------------------------------------------------------------------
# See R/day_05.R and R/day_05_exercise.R



# ------------------------------------------------------------------------------
#     3. Summary of statistical concepts
# ------------------------------------------------------------------------------
# We have now been through:
#      - Descriptive statistics
#      - Statistical inference (sample versus population)
#      - The normal distibution (aka Gaussian)
#      - Confidence intervals
#      - The standard normal distribution (standard-/z-score normalisation)
#      - Hypothesis testing (null versus alternative)
#      - p-values
#      - Level of significance
#      - Power
#      - Alpha values
#      - Beta values
#      - Type I error
#      - Type II error
#      - Confusion matrices
#      - False positives
#      - False negatives



# ------------------------------------------------------------------------------
#     4. Correlation and covariance
# ------------------------------------------------------------------------------
# Your turn: two-and-two using the SRH data, calculate the covariance and
# correlation for the 'height' and 'shoe_size' variables
# As usual, do not use the built-in functions in R, but construct the
# calculation, based on what you have been shown in the video
#
# Questions:
#     1. See if you can conceptually connect covariance to standard deviation
#     2. Calculate the covariance for the 'height' and 'shoe_size' variables
#     3. Calculate the correlation for the 'height' and 'shoe_size' variables
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
#
set.seed(718391)
n = 100
d = c('TP','FP','TN','FN')

# A
probs   = c(0.25, 0.25, 0.25, 0.25)
results = sample(x = d, size = n, prob = probs, replace = TRUE)
results = as_tibble(table(results))
print(results)

# B
probs   = c(0.40, 0.10, 0.40, 0.10)
results = sample(x = d, size = n, prob = probs, replace = TRUE)
results = as_tibble(table(results))
print(results)
