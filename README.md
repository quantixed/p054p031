# p054p031
Code and data for Larocque et al. manuscript `#p054p031`

**Intracellular nanovesicles mediate &alpha;5&beta;1 integrin trafficking during cell migration**

Gabrielle Larocque, Daniel J. Moore, Méghane Sittewelle, Cansu Küey, Joseph H.R. Hetmanski, Penelope J. La-Borde, Beverley J. Wilson, Nicholas I. Clarke, Patrick T. Caswell and Stephen J. Royle

*bioRxiv* [doi: 10.1101/2020.08.19.257287](https://doi.org/10.1101/2020.08.19.257287)

## Data

- `cell_migration` cell track data in excel workbooks or directories of CSV files for analysis using [CellMigration](https://doi.org/10.5281/zenodo.3369643)
- `cell_shape` IMOD models and corresponding text files (produced by `model2point`) for analysis using [CellShape](https://doi.org/10.5281/zenodo.3931238)
- `variance` excel workbooks with spatiotemporal data for Rab GTPases and TPD54 mutants.

Data for R plots are in the `R` directory.


## Scripts

- `ImageVariance.ipf` a workflow to analyze cropped images for spatiotemporal variance in IgorPro
- `MakeEffectSizeGraph.ipf` simple graphing procedure using R output of estimation statistics e.g. `rabscreen_figure`- `MitoAggregation.ipf` analysis of outputs from the Fiji script `MitoAggregation.ijm` which will extract statistics of mitochondria from cell limages- `ProteomicsProcs.ipf` a workflow used in conjunction with [VolcanoPlot](https://github.com/quantixed/VolcanoPlot)


## R Code

Three R projects to generate plots in the paper.

- `cancer_figure` - plotting data from TCGA
- `heatmap_figure` - hierarchical clustering of Rab screen data
- `rabscreen_figure` - calculating effect sizes from raw data

All work in a similar way. Data files are in the `Data` directory and are processed by an R script in `Script` to generate outputs that are saved to `Output/Data` or `Output/Plots`.