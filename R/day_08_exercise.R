# ------------------------------------------------------------------------------
# First script - Gets the data and makes it nice
# ------------------------------------------------------------------------------



# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')
library('ggbiplot')

# Get data
# ------------------------------------------------------------------------------
bl62_url = 'https://www.ncbi.nlm.nih.gov/Class/FieldGuide/BLOSUM62.txt'
bl62_mat = read_table(file = bl62_url, comment = '#')

# Clean data
# ------------------------------------------------------------------------------
rm_chars = c('B','Z','X','*')
bl62_mat = bl62_mat %>% dplyr::rename(name = X1) %>%
  select_if((colnames(.) %in% rm_chars) %>% `!`) %>%
  filter((name %in% rm_chars) %>% `!`)

# Write data
# ------------------------------------------------------------------------------
write_tsv(x = bl62_mat, path = 'data/01_BLOSUM62.tsv')



# ------------------------------------------------------------------------------
# Second script - Computes and visualises the PCA
# ------------------------------------------------------------------------------



# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')

# Functions
# ------------------------------------------------------------------------------
assign_chemistry_sigma_aldrich = function(aa){
  aa = as.character(aa)
  chemistry = c('A' = 'Hydrophobic aliphatic',
                'I' = 'Hydrophobic aliphatic',
                'L' = 'Hydrophobic aliphatic',
                'M' = 'Hydrophobic aliphatic',
                'V' = 'Hydrophobic aliphatic',
                'F' = 'Hydrophobic aromatic',
                'W' = 'Hydrophobic aromatic',
                'Y' = 'Hydrophobic aromatic',
                'N' = 'Neutral polar',
                'C' = 'Neutral polar',
                'Q' = 'Neutral polar',
                'S' = 'Neutral polar',
                'T' = 'Neutral polar',
                'D' = 'Acidic',
                'E' = 'Acidic',
                'R' = 'Basic',
                'H' = 'Basic',
                'K' = 'Basic',
                'G' = 'unique',
                'P' = 'unique')
  return(factor(chemistry[aa]))
}

# Load data
# ------------------------------------------------------------------------------
bl62_tbl = read_tsv(file = 'data/01_BLOSUM62.tsv')

# Wrangle data
# ------------------------------------------------------------------------------

# Convert tibble to matrx to use base prcomp function
bl62_mat = bl62_tbl %>% select(-name) %>% as.matrix %>% as.data.frame

# Add rownames
rownames(bl62_mat) = colnames(bl62_mat)

# Do PCA
# ------------------------------------------------------------------------------
# Compute PCA
bl62_pca = bl62_mat %>% prcomp(scale. = TRUE, center = TRUE)

# Add chemistry
bl62_mat$chemistry = assign_chemistry_sigma_aldrich(aa = rownames(bl62_mat))

# Visualise
# ------------------------------------------------------------------------------

# PCA plot
bl62_pca %>%
  ggbiplot(groups = bl62_mat$chemistry, ellipse = TRUE, circle = TRUE) +
  geom_point(colour = "white") +
  geom_text(aes(label=rownames(bl62_pca$rotation),colour=bl62_mat$chemistry)) +
  theme_bw()

# Scree plot
bl62_pca %>%
  ggscreeplot() +
  theme_bw()
