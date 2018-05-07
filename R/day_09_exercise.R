# ------------------------------------------------------------------------------
#     4. Data manipulation and visualisation
# ------------------------------------------------------------------------------
#
# Your supervisor has given you an analysis output and asked you to extract
# relevant information. She has put the file in dropbox for you to retrieve:
# https://www.dropbox.com/s/df0o48306hf9z8n/data.dat?dl=0
rm(list=ls())
library('tidyverse')
d = read_tsv(file = 'data/data.tsv', skip = 1)
# Questions
#
#     1. Come up with and answer 3 questions based on the data. Look at the data
#        and think of 3 things, that would be relevant to communicate?

#     2. How many peptides are in the data?
d %>% nrow

#     3. How many unique peptides are in the data?
d %>% select(Peptide) %>% distinct %>% nrow

#     4. How many peptides contain a tryptophan?
d %>% filter(Peptide %>% str_detect("W")) %>% nrow
d %>% filter(str_detect(Peptide, "W")) %>% nrow # Equivalent

#     5. How many peptides starts with a glutamine?
d %>% filter(Peptide %>% str_sub(1,1) == "Q")
d %>% filter(Peptide %>% str_sub(1,1) %>% str_detect("Q"))

#     6. How many peptides are binders?
d %>% select(NB) %>% distinct # What does the column contain
d %>% filter(NB==1) %>% nrow
d %>% group_by(NB) %>% summarise(n = n())
d %>% count(NB)
d %>% count(NB) %>% filter(NB==1) %>% pull(n)

#     7. Which rank cut off was used to identify a binder?
d %>% filter(NB==1) %>% summarise(cut_off = max(Rank)) %>% pull
d %>% filter(NB==1) %>% arrange(Rank) %>% tail(1) %>% pull(Rank)
d %>% filter(NB==1) %>% arrange(desc(Rank)) %>% head(1) %>% pull(Rank)

#     8. Using the package 'ggseqlogo', make a sequence logo of binding peptides
#install.packages('ggseqlogo')
library('ggseqlogo')
d %>% filter(NB == 1) %>% pull(Peptide) %>% ggseqlogo

#     9. Which HLA-allele was used for this binding analysis?
# HLA-A*02:01 (From sequence logo)

#    10. Which fraction of binders has a leucine at p2 and a valine at p9?
tmp = d %>% filter(NB == 1, str_sub(Peptide, 2, 2) == 'L',
                   str_sub(Peptide, 9, 9) == 'V') %>% nrow
a10 = tmp / a6
print(a10)

#    11. Which fraction of non-binders has a leucine at p2 and a valine at p9?
tmp = d %>% filter(NB == 0, str_sub(Peptide, 2, 2) == 'L',
                   str_sub(Peptide, 9, 9) == 'V') %>% nrow
a11 = tmp / (a2 - a6)
print(a11)

#    12. What is the sequence of the best binder?
a12 = d %>% arrange(Rank) %>% head(1) %>% pull(Peptide)
print(a12)

#    13. What is the sequence of the 2nd best binder?
a13 = d %>% arrange(Rank) %>% head(2) %>% tail(1) %>% pull(Peptide)
print(a13)

#    14. Compare the sequences from q12 and q13, do you see what you expect?

#    15. Compare positions 2 and 9 from the sequence logo from q7 with the PCA
#        plot from last session. Discuss if the logo matches the PCA plot

