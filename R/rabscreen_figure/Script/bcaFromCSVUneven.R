## this script will calculate effect sizes of a dataset
## uses bias corrected accelerated bootstrap method
## output is used to generate plots in Igor (not in R)

library(bootstrap)

# import data
filename <- file.choose()
myrawdata <- read.csv(filename, header=TRUE, stringsAsFactors=FALSE)
# find the mean of the control values (assume it is in 1st column)
ctrlmean <- mean(myrawdata[,1], na.rm=TRUE)
# subtract mean from the data
mydiffdata <- myrawdata - ctrlmean
# uneven number of rows mean NaNs, deal with them
mydata <- lapply(mydiffdata, function(col)col[!is.na(col)])
# don't need to work on the first column
cols <- length(mydata) - 1
# make empty vector to take the mean
mymeans <- rep(NA, cols)
mybcalo <- rep(NA, cols)
mybcahi <- rep(NA, cols)
# use a for loop to get for each mean diff, low and high BCa CI 
for (i in 1:cols ){
  mymeans[i] <- mean(mydata[[i+1]])
  bca = bcanon(mydata[[i+1]],10000,mean,alpha=0.025)
  mybcalo[i] <- bca$conf[1,2]
  bca = bcanon(mydata[[i+1]],10000,mean,alpha=0.975)
  mybcahi[i] <- bca$conf[1,2]
}
result <- data.frame(mymeans,mybcalo,mybcahi)

# save to Output/Data with same name as input csv
outputName <- basename(filename)
pathToDataSave <-  paste0("Output/Data/", outputName)

write.csv(result, file = pathToDataSave, row.names=FALSE)

