# Clear workspace
# ------------------------------------------------------------------------------
rm(list=ls())

# Load libraries
# ------------------------------------------------------------------------------
library('tidyverse')
library('readxl')

# Load data
# ------------------------------------------------------------------------------

# Note multiple sheets!
BC_46 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.46')
BC_61 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.61')
BC_70 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.70')
BC_78 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.78')
BC_98 = read_excel(path = 'data/fold_change.xlsx', sheet = 'BC.98')

peptide_data = read_excel(path = 'data/Virus peptides.xlsx')

# Wrangle data
# ------------------------------------------------------------------------------
p_cut   = 0.001
lfc_cut = 1
bcd = bind_rows(BC_46,BC_61,BC_70,BC_78,BC_98) %>% 
  group_by(sample) %>% 
  mutate(count_sum = sum(count.1), count_frac = count.1 / count_sum) %>%
  ungroup %>% 
  mutate(response = ifelse(p <= 0.001 & log_fold_change >= 1 &
                             count_frac >= 1/1000, 1, 0) %>% factor)

peptide_data %>%
  rename(peptide_seq = Sekvens) %>%
  mutate(Peptide = Peptid %>% str_split(' ') %>% map(1) %>% unlist) %>%
  select(Peptide, peptide_seq) %>% 
  right_join(bcd, by = 'Peptide')





# Plot data
# ------------------------------------------------------------------------------
bcd %>%
  select(sample, count.1, input.1, input.2, input.3) %>%
  gather(key, value, -sample) %>%
  ggplot(aes(x = sample, y = value, fill = key)) +
  geom_boxplot(alpha = 0.5) +
  scale_y_continuous(trans="log10") +
  theme_bw()






stop()

# P-value based plots
bcd %>%
  filter(p <= p_cut) %>% 
  ggplot(aes(x = pMHC, y = minus_log10_p)) +
  geom_bar(stat='identity', alpha = 0.5) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1),
        panel.grid.major.x = element_blank()) +
  facet_wrap(~sample, ncol = 1)

bcd %>% filter(p <= p_cut) %>%
  ggplot(aes(x = sample, y = pMHC)) +
  geom_tile(aes(fill = minus_log10_p)) +
  scale_fill_gradient(low = "yellow", high = "red") +
  scale_x_discrete(expand = c(0,0)) +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank()) +
  ylab("Peptide-MHC-complex") +
  xlab("Buffy Coat sample") +
  labs(fill = "-log10(p)") +
  ggtitle(label = "pMHC Positive Responses per Buffy Coat at p <= 0.05")

bcd %>%
  ggplot(aes(x = pMHC, y = minus_log10_p, label = pMHC_lbl_p, colour = response_p)) +
  geom_point() +
  geom_text_repel(size = 2) +
  facet_wrap(~sample, ncol = 1) +
  geom_hline(yintercept = p_cut, linetype = 'dashed', colour = 'grey') +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_blank(),
        legend.position = 'bottom')

# LFC based plots
p1 = bcd %>%
  filter(log_fold_change >= lfc_cut) %>% 
  ggplot(aes(x = pMHC, y = log_fold_change)) +
  geom_bar(stat='identity', alpha = 0.5) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1),
        panel.grid.major.x = element_blank()) +
  facet_wrap(~sample, ncol = 1)

p2 = bcd %>%
  filter(log_fold_change >= lfc_cut) %>%
  ggplot(aes(x = sample, y = pMHC)) +
  geom_tile(aes(fill = log_fold_change)) +
  scale_fill_gradient(low = "yellow", high = "red") +
  scale_x_discrete(expand = c(0,0)) +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank()) +
  ylab("Peptide-MHC-complex") +
  xlab("Buffy Coat sample") +
  labs(fill = "log(FC)") +
  ggtitle(label = "pMHC Positive Responses per Buffy Coat at log(FC) >= 2")

p3 = bcd %>%
  ggplot(aes(x = pMHC, y = log_fold_change, label = pMHC_lbl_lfc, colour = response_lfc)) +
  geom_point() +
  geom_text_repel(size = 2) +
  facet_wrap(~sample, ncol = 1) +
  geom_hline(yintercept = lfc_cut, linetype = 'dashed', colour = 'grey') +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_blank(),
        legend.position = 'bottom')


bcd %>%
  ggplot(aes(x = log_fold_change, y = minus_log10_p, colour = sample)) +
  geom_point() +
  geom_hline(yintercept = -log10(p_cut), linetype = 'dashed', colour = 'grey') +
  geom_vline(xintercept = lfc_cut, linetype = 'dashed', colour = 'grey') +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = 'bottom')
