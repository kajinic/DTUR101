# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())



# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')
library('readxl')



# Define functions
# ------------------------------------------------------------------------------
read_all_excel_sheets = function(file){
  list_of_sheets = lapply(excel_sheets(file), read_excel, path = file)
  return( do.call(rbind, list_of_sheets) )
}



# Load data
# ------------------------------------------------------------------------------
read_dat   = read_all_excel_sheets(
  file = 'data/week12_data/_raw/fold_change.xlsx')
virus_peps = read_excel(
  path = 'data/week12_data/_raw/Virus peptides.xlsx')



# Wrangle data
# ------------------------------------------------------------------------------
# You can check for multiple sheets in excel files using this command
excel_file = 'data/week12_data/_raw/fold_change.xlsx'
excel_file %>% excel_sheets %>% print

# Add variable to the virus peps
virus_peps = virus_peps %>% mutate(Peptide = str_c("v", Nr))

# Whoops! The 'Peptide' variable contained weird notation e.g. "v4 (C1)", we
# need to get rid of that:
virus_peps = virus_peps %>%
  mutate(Peptide = Peptide %>% str_split(" ") %>% map(1) %>% unlist)

# Now, we can join the data sets
dat_combi = read_dat %>% full_join(virus_peps, by = 'Peptide')

# Low and behold, there are peptides missing! I.e. NA is found in the "Sekvens"
# variable:
dat_combi %>% filter(is.na(Sekvens)) %>% print

# We recieve yet another excel sheet:
plate_layouts = read_excel(path = 'data/week12_data/_raw/Book1.xlsx')

# The data obviously contiain two tables, so we need to split them.
# Since the layouts are static (384 well std), we can make an exception
# and use hard coding to solve the issue at hand
barcode_36 = plate_layouts %>% slice(1:16) %>% select(-`Barcode 36`) %>% 
  rename(row_id = X__1)

peptide_1 = plate_layouts %>% slice(19:34)
colnames(peptide_1) = plate_layouts %>% slice(18)
peptide_1 = peptide_1 %>% select(-`Peptide 1`)
colnames(peptide_1)[1] = 'row_id'

# Convert to long format and join to create well mapping between
# barcodes and peptides
barcode_36_long = barcode_36 %>%
  gather(col_id, value, -row_id) %>%
  mutate(plate_id = str_c(row_id, '_', col_id))

peptide_1_long = peptide_1 %>%
  gather(col_id, value, -row_id) %>%
  mutate(plate_id = str_c(row_id, '_', col_id))

layout_combi = barcode_36_long %>%
  full_join(peptide_1_long , by = c('plate_id', 'row_id', 'col_id')) %>% 
  rename(barcode = value.x, peptide = value.y) %>% 
  select(plate_id, row_id, col_id, barcode, peptide)

# Check dimenstions, long-format should have 384 rows, one for each well
stopifnot(nrow(layout_combi) == 384)

# We now have the following data tibbles:
dat_combi
layout_combi

