# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())



# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')



# Program of the day
# ------------------------------------------------------------------------------
#     1. Recapitulation of previous class
#     2. Working with strings
#     3. Writing functions in R
#     4. Data manipulation and visualisation



# ------------------------------------------------------------------------------
#     1. Recapitulation of previous class
# ------------------------------------------------------------------------------
# See:
#  - R/day_08.R
#  - R/day_08_exercise.R



# ------------------------------------------------------------------------------
#     2. Working with strings
# ------------------------------------------------------------------------------
# For more, see: http://r4ds.had.co.nz/strings.html

my_string = "This is a string"
my_string %>% str_split(' ')

# Returns a list, which is indexed using double squared brackets

# Unlist to get the vector
my_string %>% str_split(' ') %>% unlist

# Collapse the string again
my_string %>% str_split(' ') %>% unlist %>% str_c(collapse = ' ')

# Get part of a string
my_string %>% str_sub(2,4)

# Find out if a string contains a certain word of combination of letters
my_string %>% str_detect("is")
my_string %>% str_detect("this")

# ------------------------------------------------------------------------------
#     3. Writing functions in R
# ------------------------------------------------------------------------------

# We will postpone this to week 10

# ------------------------------------------------------------------------------
#     4. Data manipulation and visualisation
# ------------------------------------------------------------------------------
#
# Your supervisor has given you an analysis output and asked you to extract
# relevant information. She has put the file in dropbox for you to retrieve:
# https://www.dropbox.com/s/df0o48306hf9z8n/data.dat?dl=0
#
# Questions
#
#     1. Come up with and answer 3 questions based on the data. Look at the data
#        and think of 3 things, that would be relevant to communicate?
#
#     2. How many peptides are in the data?
#
#     3. How many unique peptides are in the data?
#
#     4. How many peptides contain a tryptophan?
#
#     5. How many peptides starts with a glutamine?
#
#     6. How many peptides are binders?
#
#     7. Which rank cut off was used to identify a binder?
#
#     8. Using the package 'ggseqlogo', make a sequence logo of binding peptides
#
#     9. Which HLA-allele was used for this binding analysis?
#
#    10. Which fraction of binders has a leucine at p2 and a valine at p9?
#
#    11. Which fraction of non-binders has a leucine at p2 and a valine at p9?
#
#    12. What is the sequence of the best binder?
#
#    13. What is the sequence of the 2nd best binder?
#
#    14. Compare the sequences from q12 and q13, do you see what you expect?
#
#    15. Compare positions 2 and 9 from the sequence logo from q7 with the PCA
#        plot from last session. Discuss if the logo matches the PCA plot
#
