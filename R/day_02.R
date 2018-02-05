# Clear workspace
rm(list=ls())


# Recap
#  - Arithmetrics
#  - Variables
#  - Data types: character, numeric, logical
#  - Boolean operations on logicals
#  - If() statement
#  - Vectors
#  - Vector operations
#  - Vector indexing
#  - Matrices
#  - Matrix operations
#  - Matrix indexing
#  - Creating a data matrix
#  - Data frames
#  - Descriptive statistics
#  - for loop
#  - string concatenation



# Build empty data matrix
data = matrix(nrow = 10, ncol = 1)
print(data)
rownames(data) = c('Mikael','Keith','Trine','Nikolaj','Kamilla','Ulla','Nadia',
                   'Jeppe','Christina','Leon')
colnames(data) = c('height')
print(data)

# Add data to the height variable
data[,'height'] = c(185,182,172,184,164,163,174,200,178,195)
print(data)

# Access variables
data[,'height']

# Let us upgrade the matrix to a data frame
data = as.data.frame(data)

# Access variables
data$height

# Now we add a new variable
data$eyecolour = c('brown','brown','green','blue','blue','blue','green','blue',
                   'green','brown')
print(data)

# Problem!
data$he
data$ey

# This is not good if you write a script and then later add a new variable
# called 'he' or 'ey'

# You need to be tidy!
library('tidyverse')

# Convert data to tibble
data = data %>% as_tibble

# Now we can no longer do this
data$he
data$ey

# We want to create a pipeline instead of building our functions inside out
# example of base vs tidyverse
n = 100

# This requires explanation
sign(round(mean(sample(rnorm(n),10)),3))

# This pipeline is self explanatory
n %>% rnorm %>% sample(10) %>% mean %>% round(3) %>% sign

# Example of adding variables:
# Names
data = data %>% mutate(name = c('Mikael','Keith','Trine','Nikolaj','Kamilla',
                                'Ulla','Nadia','Jeppe','Christina','Leon'))
# Sex
data = data %>%
  mutate(sex = c('M','M','F','M','F','F','F','M','F','M') %>% factor)


# ------------------------------------------------------------------------------
# Work on an Excel file
# ------------------------------------------------------------------------------
library("readxl")
dat_srh = read_excel(path = "data/srh_group_data.xlsx")

# We can look at the data spreadsheet-stylish
dat_srh %>% View

# Briefly on missing data, typical values
NA
NaN

# We can have the empty values, the nothing
NULL

# and more importantly, we can check for these values
a = c()
is.null(a)
a = NA
is.na(NA)
a = NaN
is.nan(a)

# Let's remove the rows with missing data
dat_srh %>% filter(complete.cases(.))

# Filter on specific variable
dat_srh %>% filter(!is.na(Shoesize))

# Look at subset of data, with respect to rows
dat_srh %>% filter(!is.na(Shoesize)) %>% View

# Look at subset of data, with respect to columns
dat_srh %>% select(Name, height, Shoesize) %>% View

# Let's combine these
dat_srh %>% filter(!is.na(Shoesize)) %>% select(Name, height, Shoesize) %>% View

# Let's expand this pipeline to include plotting
dat_srh %>% filter(!is.na(Shoesize)) %>% select(Name, height, Shoesize) %>%
  ggplot(aes(x = Shoesize, y  = height)) +
  geom_smooth(method="lm") +
  geom_point() +
  geom_text(aes(label=Name),nudge_y = 1) +
  xlab("Explanatory variable: Shoe size") +
  ylab("Response variable: Height") +
  ggtitle("Modelling height as a function of shoe size") +
  theme_bw()
ggsave(filename = 'figures/shoe_size_vs_height.png',
       width = 8, height = 5)

