library(tidyverse)
library(RColorBrewer)

df <- read.delim2("Data/alterations_across_samples_TPDs.tsv")

summaryDF <- df %>%
  group_by(Study.ID) %>%
  summarise(TPD52 = sum(match(TPD52,"AMP"), na.rm = TRUE) / n(),
            TPD52L1 = sum(match(TPD52L1,"AMP"), na.rm = TRUE) / n(),
            TPD52L2 = sum(match(TPD52L2,"AMP"), na.rm = TRUE) / n(),
            TPD52L3 = sum(match(TPD52L3,"AMP"), na.rm = TRUE) / n())

# add all frequencies from gene columns
summaryDF$All <- rowSums(summaryDF[,c(2,3,4,5)])

# load cancer names
# https://gdc.cancer.gov/resources-tcga-users/tcga-code-tables/tcga-study-abbreviations
study_lookup <- read.delim2("Data/study_lookup.txt")
summaryDF$Study.Abbreviation <- toupper(gsub("_tcga_pan_can_atlas_2018","",summaryDF$Study.ID))
summaryDF <- merge(summaryDF,study_lookup)
# make df more simple and change names
keeps <- c("Study.Name", "All", "TPD52", "TPD52L1", "TPD52L2", "TPD52L3")
summaryDF <- summaryDF[keeps]
names(summaryDF)[names(summaryDF)=="Study.Name"] <- "Cancer"
# make tidy
summary_df_long <- summaryDF %>% 
  gather(key = gene, value = freq, 2:6)

p1 <- ggplot(data = summary_df_long, aes(x = Cancer, y = gene, fill = freq)) +
  geom_tile() +
  coord_flip() +
  scale_fill_gradient(low = "#fee0d2", high = "#de2d26") +
  labs(x = "", y = "") +
  theme_minimal()

ggsave("Output/Plots/TPD.pdf", plot = p1, useDingbats = FALSE)

rab_all <- read.delim2("Data/alterations_across_samples_allRabs.tsv")

summary_rab_all <- rab_all %>%
  group_by(Study.ID) %>%
  summarise(all = sum(Altered) / n())

summary_rab_all$Study.Abbreviation <- toupper(gsub("_tcga_pan_can_atlas_2018","",summary_rab_all$Study.ID))
summary_rab_all <- merge(summary_rab_all,study_lookup)
names(summary_rab_all)[names(summary_rab_all)=="Study.Name"] <- "Cancer"

p2 <- ggplot(data = summary_df_long, aes(x = Cancer, y = all, fill = all)) +
  geom_tile() +
  coord_flip() +
  scale_fill_gradient(low = "#fee0d2", high = "#de2d26") +
  labs(x = "", y = "") +
  theme_minimal()
