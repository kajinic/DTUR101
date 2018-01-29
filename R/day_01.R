# A number
2

# An addition
2+3

# A subtraction
2-3

# A power
2^5

# Another power
2**5

# Variables
a = 2
a
b = 3
b

# Adding variables
a + b

# Change one variable
a = 8

# add them again
a + b

# Character variables (strings)
a =  "s"
a

b = "t"
b

# Strings can be longer
c = "This is a sentence"
c

# You use strings to name data variables, e.g. samples
d = "Sample_4882"
d

# Booleans - These are a bit more tricky

# Assign TRUE - Note we're NOT quoting
a = TRUE
a

# Assign FALSE
b = FALSE
b

# We can combine booleans and evaluate the statement
a & b
a && b
a | b
a || b

# If we change the values, the evaluations also change
a = TRUE
b = TRUE
a & b
a && b
a | b
a || b

# Short example of an if-statement
a = TRUE
if( a ){ print("yes") }
b = FALSE
if( b ){ print("yes") }

# A bit more tricky
a
if( a == TRUE ){ print("1") }
if( a == FALSE ){ print("2") }

# Comparing variables
a = 2
b = 3

# Is a equal to b?
a == b

# Is a not equal to b?
a != b

# Is a larger than b?
a > b

# Is a smaller than b?
a < b

# Larger than or equal to example
a = 2
b = 2
a > b
a < b
a >= b
a <= b

# ------------------------------------------------------------------------------
# Vectors
# ------------------------------------------------------------------------------

# A numerical vector
c(1,2,3,4,5,6,7,8,9,10)

# Character vector
c('a','b','c','d','e')

# Note that the above is equal to this
c("a","b","c","d","e")

# You can do math on vectors!
c(1,2,3,4,5,6,7,8,9,10) + 2

# So you needn't write
c(1,2,3,4) + c(2,2,2,2)

# Vectors with different lengths
c(1,2,3) + c(1,2,3,4)

# Vectors with special different lengths
c(1,2,3) + c(1,2,3,4,5,6)

# What can we store in a vector?
c("a",1,TRUE)

# A vector can ONLY hold same type values
c(1,TRUE)

# Let us try a few functions, which can be applied to vectors

# Get the length of the vector
length(c("a","b","c","d","e"))

# Index the vector
c("a","b","c","d","e")[c(1,2)]

# A little trick to create sequences of numbers
seq(1,3)

# This is the same as
1:3

# Let us index the vector from before
c("a","b","c","d","e")[1:2]

# Let us get the first and the last position of the vector!
v = c("a","b","c","d","e")
v[c(1,length(v))]

# Let us get the dimension!
dim(v)

# ------------------------------------------------------------------------------
# Matrices
# ------------------------------------------------------------------------------

# Let us make a numeric matrix
m_num = matrix(1:12, nrow = 3, ncol = 4)
m_num

# and a character matrix
m_chr = matrix(c("a","b","c","d","e","f"), nrow = 2, ncol = 3)
m_chr

# Small boolean trick
TRUE + 0

# Let us index the matrices

# Specific single value
m_num[2,4]

# Extract a specific row or column
m_num[2,]
m_num[,4]

# Get the dimension of the matrix
dim(m_num)

# Let us make the matrix look like something we know!
m = m_num

# Set rownames
rownames(m) = c('s1','s2','s3')
colnames(m) = c('v1','v2','v3','v4')

# Let us try to index again, now on row/col names
m["s1",]
m[,"v3"]

# ------------------------------------------------------------------------------
# Descriptive statistics
# ------------------------------------------------------------------------------

# Build empty data matrix
data = matrix(nrow = 10,ncol = 1)
rownames(data) = c('Mikael','Keith','Trine','Nikolaj','Kamilla','Ulla','Nadia',
                   'Jeppe','Christina','Leon')
colnames(data) = c('height')

# Get values!
data['Mikael','height'] = 185

# Note this is the same as
data[1,1] = 185

# Let us do that in a less silly way
data[,'height'] = c(185,182,172,184,164,163,174,200,178,195)
data

# What kind of structure is data?
str(data)

# Let us upgrade the matrix to a data frame
data = as.data.frame(data)

# Look at the structure again
str(data)

# Now we can get a single variable directly by name
data$height

# Now we add a new variable
data$eyecolour = c('brown','brown','green','blue','blue','blue','green','blue',
                   'green','brown')

# Let us try to calculate the mean of the data using a for loop
heights = data$height
n = length(heights)
sum = 0
for( i in 1:n ){
  sum = sum + heights[i]
}
dat_mean = sum / n

# Let us do this in a less silly way
heights
mean(heights)

# The standard deviation is obtained like so
dat_sd = sd(heights)

# State the values we calculated as a data summary
paste0("mean (+/-) sd = ",dat_mean," (+/-) ",dat_sd)



