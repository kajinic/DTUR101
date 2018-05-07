# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())



# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')



# Program of the day
# ------------------------------------------------------------------------------
#     1. Recapitulation of previous class
#     2. Writing functions in R
#     3. Cheat sheets
#     4. Data manipulation and visualisation



# ------------------------------------------------------------------------------
#     1. Recapitulation of previous class
# ------------------------------------------------------------------------------
# See R/day_09.R and R/day_09_exercise.R


# ------------------------------------------------------------------------------
#     2. Writing functions in R
# ------------------------------------------------------------------------------

# Define a function
f = function(x){
  y = 2 * x + 3
  return(y)
}

# Call the function with a single number
f(x = 3)

# Call the function with a multiple numbers
f(x = 1:5)

# Please note, 'f' and 'f2' are equivalent. A function always return the last
# thing it calculated. I recommend using return(), so that you force yourself
# to think about exactly what is being returned
f2 = function(x){
  2 * x + 3
}

f3 = function(x){
  y = 2 * x + 3
  z = 4 * x - 17
  return(cbind(y, z))
}

f4 = function(x){
  y = 2 * x + 3
  z = 4 * x - 17
  return(rbind(y, z))
}

f5 = function(x){
  y = 2 * x + 3
  z = 4 * x - 17
  return(list(y = y, z = z))
}

# First task today:
#     Write a function, which takes a vector of strings, removes any empty
#     strings and return the "cleaned" vector of non-empty strings
str_rm_empty = function(x){
  return( x[x!=''] )
}

# ------------------------------------------------------------------------------
#     3. Cheat sheets
# ------------------------------------------------------------------------------

# https://www.rstudio.com/resources/cheatsheets/

# ------------------------------------------------------------------------------
#     4. Data manipulation and visualisation
# ------------------------------------------------------------------------------

# Tasks
#     1. Read the 'fold_change.xlsx' file into R
#     2. Open the 'fold_change.xlsx' in excel and compare
#     3. Read in ALL the sheets and combine them into ONE data tibble
#        (Hint, put each sheet in one variable and combine subsequently)
rm(list=ls())
library('tidyverse')
library('readxl')
fc_sheets = excel_sheets('data/fold_change.xlsx')

BC_46 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.46')
BC_61 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.61')
BC_70 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.70')
BC_78 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.78')
BC_98 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.98')

fc = bind_rows(BC_46, BC_61, BC_70, BC_78, BC_98)

# Let us see how many samples are in each buffy coat
fc %>% count(sample)


fc = fc %>%
  group_by(sample) %>% 
  mutate(count_sum = sum(count.1), count_frac = count.1 / count_sum) %>%
  ungroup %>% 
  mutate(response = ifelse(p <= 0.001 &                      # Criteria for
                             log_fold_change >= 1 &          # defining a 
                             count_frac >= 1/1000, 1, 0) %>% # response
           factor)

# Get the numbers
fc %>% count(sample, response)

fc %>%
  ggplot(aes(x = -log10(p), y = HLA.allele, colour = response)) +
  geom_point(position="jitter") +
  theme_bw()
