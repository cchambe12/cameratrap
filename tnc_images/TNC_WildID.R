## 14 January 2019 - Cat ##
## Consolidating image names for Wild.ID upload. Trying to train a new machine learning tool

## 14 January 2019 -- Wild.ID recognizes different cameras being used so need to separate out into multiple deployments and train from there

## Housekeeping
rm(list=ls())
options(stringsAsFactors=FALSE)

## Load Libraries
library(dplyr)
library(tidyr)

# Set WD
setwd("~/Documents/git/cameratrap/tnc_images/")

## Start cleaning
tnc<- read.csv("All_images.csv", header=TRUE)
tnc <- stack(tnc)
tnc <- tnc[!(tnc$values==""),]

tnc$`Camera Trap Name` <- paste(tnc$values, tnc$ind, sep="_")
tnc$values <- NULL
tnc$ind <- NULL

tnc$Latitude <- 41.801757
tnc$Longitude <- -72.684274

#write.csv(tnc, file=("tnc_train_wildid.csv"), row.names = FALSE)


cam8a <- tnc[grep("CAM08A", tnc$`Camera Trap Name`), ]
write.csv(cam8a, file=("cam8a.csv"), row.names = FALSE)

cam8b <- tnc[grep("CAM08B", tnc$`Camera Trap Name`), ]
write.csv(cam8b, file=("cam8b.csv"), row.names = FALSE)

cam8c <- tnc[grep("CAM08C", tnc$`Camera Trap Name`), ]
write.csv(cam8c, file=("cam8c.csv"), row.names = FALSE)

cam8d <- tnc[grep("CAM08D", tnc$`Camera Trap Name`), ]
write.csv(cam8d, file=("cam8d.csv"), row.names = FALSE)

cam8e <- tnc[grep("CAM08E", tnc$`Camera Trap Name`), ]
write.csv(cam8e, file=("cam8e.csv"), row.names = FALSE)

cam8f <- tnc[grep("CAM08F", tnc$`Camera Trap Name`), ]
write.csv(cam8f, file=("cam8f.csv"), row.names = FALSE)





