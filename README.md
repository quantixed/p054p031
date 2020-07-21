# p054p031
Code and data for Larocque et al. manuscript `#p054p031`

**Intracellular nanovesicles mediate integrin trafficking during cell migration**

Gabrielle Larocque, Penelope J. La-Borde, Beverley J. Wilson, Daniel J. Moore, Nicholas I. Clarke, Patrick T. Caswell and Stephen J. Royle

*bioRxiv* [to be deposited](https://doi.org/10.1101/X)

## Data

- `cell_migration` cell track data in excel workbooks or directories of CSV files for analysis using [CellMigration](https://doi.org/10.5281/zenodo.3369643)
- `cell_shape` IMOD models and corresponding text files (produced by `model2point`) for analysis using [CellShape](https://doi.org/10.5281/zenodo.3931238)
- `variance` excel workbooks with spatiotemporal data for Rab GTPases and TPD54 mutants.

Data for R plots are in the `R` directory.


## Scripts

- `ImageVariance.ipf` a workflow to analyze cropped images for spatiotemporal variance in IgorPro.


## R Code

Three R projects to generate plots in the paper.

- `cancer_figure` - plotting data from TCGA
- `heatmap_figure` - hierarchical clustering of Rab screen data
- `rabscreen_figure` - calculating effect sizes from raw data

All work in a similar way. Data files are in the `Data` directory and are processed by an R script in `Script` to generate outputs that are saved to `Output/Data` or `Output/Plots`.