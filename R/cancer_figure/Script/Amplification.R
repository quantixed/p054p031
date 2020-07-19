library(tidyverse)
library(RColorBrewer)

tpd_filepath <- "Data/alterations_across_samples_TPDs.tsv"
allrab_filepath <- "Data/alterations_across_samples_allRabs.tsv"
invrab_filepath <- "Data/alterations_across_samples_INVRabs.tsv"
ninvrab_filepath <- "Data/alterations_across_samples_NonINVRabs.tsv"

make_the_df <- function(theFile)  {
  df <- read.delim2(theFile)
  nGenes <- (ncol(df) - 4) / 5
  geneNames <- names(df[5:(4+nGenes)])
  binary <- ifelse(df[,5:(4+nGenes)] == "AMP", 1, 0)
  binary <- cbind(binary, All = rowSums(binary))
  binary[,ncol(binary)] <- ifelse(binary[,ncol(binary)] > 0, 1, 0)
  binary <- cbind.data.frame(Study.ID = df$Study.ID, binary)
  tally_df <- binary %>%
    group_by(Study.ID) %>%
    summarise_all(sum)
  total_df <- binary %>%
    group_by(Study.ID) %>%
    summarise(n = n ())
  # calculate freq
  tally_df[,2:(2+nGenes)] <- tally_df[,2:(2+nGenes)] / total_df$n
  # load cancer names n.b. COAD -> COADREAD
  # https://gdc.cancer.gov/resources-tcga-users/tcga-code-tables/tcga-study-abbreviations
  study_lookup <- read.delim2("Data/study_lookup.txt")
  total_df$Study.Abbreviation <- toupper(gsub("_tcga_pan_can_atlas_2018","",total_df$Study.ID))
  total_df <- merge(total_df,study_lookup)
  tally_df$Study.ID <- total_df$Study.Name
  names(tally_df)[names(tally_df)=="Study.ID"] <- "Cancer"
  # make tidy
  df_out <- tally_df %>% 
    mutate(Cancer = factor(Cancer)) %>%
    gather(key = gene, value = freq, 2:(2+nGenes))
  
  return(df_out)
}

make_the_plot <- function(df_for_plotting){
  thePlot <- ggplot(data = df_for_plotting, aes(x = gene, y = Cancer, fill = freq)) +
    geom_tile(colour="white",size=0.25) +
    guides(fill = guide_legend(title = "Frequency", reverse = TRUE)) +
    ylim(rev(levels(tpd_df$Cancer))) +
    coord_equal() +
    scale_fill_gradient(low = "#fee0d2", high = "#de2d26") +
    labs(x = NULL, y = NULL) +
    theme_minimal(base_size=10) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
  return(thePlot)
}

# TPD plots
tpd_df <- make_the_df(tpd_filepath)
p1 <- make_the_plot(subset(tpd_df, gene != "All"))
p2 <- make_the_plot(subset(tpd_df, gene == "All"))
ggsave("Output/Plots/TPDs.pdf", plot = p1)
ggsave("Output/Plots/TPDsCombined.pdf", plot = p2)

# All Rabs plots
allRabs_df <- make_the_df(allrab_filepath)
p3 <- make_the_plot(subset(allRabs_df, gene != "All"))
p4 <- make_the_plot(subset(allRabs_df, gene == "All"))
ggsave("Output/Plots/allRabs.pdf", plot = p3)
ggsave("Output/Plots/allRabsCombined.pdf", plot = p4)

# INV Rabs plots
invRabs_df <- make_the_df(invrab_filepath)
p5 <- make_the_plot(subset(invRabs_df, gene != "All"))
p6 <- make_the_plot(subset(invRabs_df, gene == "All"))
ggsave("Output/Plots/invRabs.pdf", plot = p5)
ggsave("Output/Plots/invRabsCombined.pdf", plot = p6)

# non-INV Rabs plots
ninvRabs_df <- make_the_df(ninvrab_filepath)
p7 <- make_the_plot(subset(ninvRabs_df, gene != "All"))
p8 <- make_the_plot(subset(ninvRabs_df, gene == "All"))
ggsave("Output/Plots/ninvRabs.pdf", plot = p7)
ggsave("Output/Plots/ninvRabsCombined.pdf", plot = p8)
