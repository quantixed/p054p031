if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
if (!requireNamespace("cBioPortalData", quietly = TRUE))
  BiocManager::install("cBioPortalData")
if (!requireNamespace("cBioPortalData", quietly = TRUE))
  BiocManager::install("AnVIL")

library(cBioPortalData)
library(AnVIL)

cbio <- cBioPortal()
acc <- cBioPortalData(api = cbio, by = "hugoGeneSymbol", studyId = "acc_tcga",
                      genePanelId = "IMPACT341",
                      molecularProfileIds = c("acc_tcga_rppa", "acc_tcga_linear_CNA")
)

BiocManager::install("curatedTCGAData")

install("MultiAssayExperiment")
install("curatedTCGAData")
install("TCGAutils")

vignette("curatedTCGAData")

curatedTCGAData(diseaseCode = "*", assays = "*", dry.run = TRUE)

unlink("~/.cache/cBioPortalData/")
