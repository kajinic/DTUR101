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
#   1. Recapitulation of previous class
#   2. Manual t-test for shoe_size variable in our data
#   3. Level of significance, type I and II errors
#   4. Statistical power

# ------------------------------------------------------------------------------
#   1. Recapitulation of previous class
# ------------------------------------------------------------------------------
# See R/day_04.R

# ------------------------------------------------------------------------------
#   2. Manual t-test for shoe_size variable in our data
# ------------------------------------------------------------------------------
# See R/day_04_exercise.R

# ------------------------------------------------------------------------------
#   3. Level of significance, type I and II errors
# ------------------------------------------------------------------------------
# White board and class discussion, based on 4 posed questions:
# In the context of a statistical hypothesis, i.e.:
#     Null: H0: u_0 = u_1
#     Alt:  H1: u_0 != u_1
# Questions:
#     1. What is a p-value?
#     2. What is the level of significance?
#     3. What is a type I error?
#     4. What is a type II error?

# ------------------------------------------------------------------------------
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
#
# All you need can be found at the very end of video 1
# You will need prior knowledge about the height of men vs. women. (Hint: Look
# at the manual t-test you did at day 04)
