# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')



# Program of the day
# ------------------------------------------------------------------------------
#     1. Recapitulation of previous class (Ordinary Least Squares)
#     2. Does significant correlation imply causation?
#     3. Multiple testing
#     4. PCA



# ------------------------------------------------------------------------------
#     1. Recapitulation of previous class (Ordinary Least Squares)
# ------------------------------------------------------------------------------
# See R/day_07_exercise.R
# Is y ~ x the same as x ~ y?
# No! Because the null-model is different, depending on which variable is on the
# y-axis (the dependent variable), the total-sum-of-squares will be different
# and hence also parameters, statistics and p-values



# ------------------------------------------------------------------------------
#     2. Does significant correlation imply causation?
# ------------------------------------------------------------------------------
# Take a look at:
# http://www.tylervigen.com/spurious-correlations
#
# ...and it should be evident, that correlation does not imply causation!
#
# Also consider this plot:
#
# y "Number of sun-glasses sold"
# ^
# |         x
# |       x
# |     x
# |   x
# | x
# ------------> x = "Number of ice-creams sold"
#
# Do you think, that the number of ice-creams truly by itself impact the number
# of sun-glasses sold?
# (Hint: google for Confounding)

# ------------------------------------------------------------------------------
#     3. Multiple testing
# ------------------------------------------------------------------------------

# Basic principle
# The more tests you perform, the bigger the probability of a false positive
# becomes:
alpha   = 0.05                   # Accepted probability of a false positive
n_tests = 8                      # The number of tests performed
print(1 - (1 - alpha) ^ n_tests) # Probability of a false positive after n tests

# Seeing is believing!
d = tibble(n_tests = seq(1,100), p_FP = 1 - (1 - alpha) ** n_tests)
d %>% 
  ggplot(aes(x = n_tests, y = p_FP)) +
  geom_line() +
  theme_bw()
# If you look at the plot, you can see, that after around 100 tests, the 
# probability of a false positive is 1! See p.adjust to control this

# ------------------------------------------------------------------------------
#     4. PCA
# ------------------------------------------------------------------------------

# Short intro to the BLOSUM62 matrix (See https://en.wikipedia.org/wiki/BLOSUM)

# Your turn:
# Google "BLOSUM62 NCBI" and create a PCA model of the similarities between
# amino acid residues

# Task 1:
# Subset the BLOSUM62 matrix to the 20 proteogenic amino acids

# Task 2:
# Add the chemical profile of each amino acid to the plot

# Task 3:
# Add circle and ellipses to the bi-plot
