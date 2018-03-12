# Week 7 - Monday March 12th 2018 13-17

# Today's tasks
#
# Q1:
# You have just been to a meeting with your supervisor. She was recently at a
# conference, where she heard about a super cool method for modelling the
# relationship between two correlated variables. She has asked you to look into
# the method and present it at the next group meeting. Frantically, you (and the
# person next to you) start googl'ing and youtub'ing for 'Ordinary Least
# Squares'
#
# Q2:
# Now that you have your model, calculate the estimated shoe size of a
# newborn baby (assume a height of 50 centimeters)
#
# Q3:
# Do you believe your estimate? Why/why not?



# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')
library('broom')

# Load data
# ------------------------------------------------------------------------------
srh_dat = read_tsv(file = 'data/srh_group_data_clean.tsv')

# ------------------------------------------------------------------------------
# Q1
# ------------------------------------------------------------------------------

# Get the data we will work on:
x = srh_dat %>% pull(height)
y = srh_dat %>% pull(shoe_size)

# Calculate means
x_bar = mean(x)
y_bar = mean(y)

# Calculate standard deviations
s_x = sd(x)
s_y = sd(y)

# Calculate the estimates of 'a' and 'b' in the model
#     y = a + b*x
# using ordinary least squares
b = sum((y - y_bar) * (x - x_bar)) / sum((x - x_bar)^2)
a = y_bar - b * x_bar

# Note that this is equivalent to
b = cor(x, y) / (sd(x) / sd(y))

# Create linear model using built in function
my_lm = srh_dat %>% lm(shoe_size ~ height, data = .)
my_lm %>% summary %>% tidy %>% print



# ------------------------------------------------------------------------------
# Q2
# ------------------------------------------------------------------------------

# Set baby height
baby_height = 50

# Calculate shoe size method 1
baby_shoe_size_1 = my_lm$coefficients["(Intercept)"] + my_lm$coefficients["height"] * baby_height
print(baby_shoe_size_1)

# Calculate shoe size method 2
baby_shoe_size_2 = my_lm %>% predict(newdata = tibble(height = baby_height))
print(baby_shoe_size_2)



# ------------------------------------------------------------------------------
# Q3
# ------------------------------------------------------------------------------
# You'll need to reflect over the dimensions of a baby. Do you think that the
# relative size of a baby's body parts are equal to that of a grown up?
