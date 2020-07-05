## To make heatmaps
# load libraries
if (!require("gplots")) {
        install.packages("gplots", dependencies = TRUE)
        library(gplots)
}
if (!require("RColorBrewer")) {
        install.packages("RColorBrewer", dependencies = TRUE)
        library(RColorBrewer)
}

# load in the data from
#fileName <- file.choose()
fileName <- "Data/AllData.csv"
mydata <- read.csv(fileName, header=TRUE, stringsAsFactors=FALSE)
# make a matrix of the data
mymatrix <- mydata[,c(2:length(mydata))]
# assign row names
rownames(mymatrix) <- mydata[,1]

# draw a heatmap of the effect sizes
pdf("Output/Plots/heatMap.pdf")
heatmap.2(as.matrix(mymatrix),
        scale = "column",
        margins =c(6,24),
        col = rev(brewer.pal(9,"RdGy")),
        tracecol="purple",
        revC = TRUE,
        cexCol = 1)
dev.off() 

