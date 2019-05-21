## Let's check out this USDA model output...
# 29 April 2019 - Cat

# Clear workspace
rm(list=ls()) # remove everything currently held in the R memory
options(stringsAsFactors=FALSE)
graphics.off()

## Libraries
library(dplyr)
library(ggplot2)

### Need to update everything... 
if(FALSE){
ouch <- read.csv("~/Downloads/gnarly.csv", header=FALSE)
ouch$V1 <- gsub(".*imagesall/\\s*|'.*", '', ouch$V1)
ouch$labels <- 0
write.csv(ouch, file="~/Documents/git/imagesall_labels_new.csv", row.names = FALSE)
}

# Set Working directory
setwd("~/Documents/git/cameratrap")

#Load the data
results <- read.csv("test_results_newusda.csv", header=TRUE)
classes <- read.csv("listofnames.csv", header=TRUE)

results$image <- gsub(".*/\\s*|'.*", '', results$fileName)

## Below are classes that shouldn't be found here so I am telling the model to use the second guess if
# its first guess is one below (e.g., wild pig)
if(TRUE){
errors <- c(4, 17)

results <- results[(results$guess1>=0.7),]

results$modelfix<-NA
results$modelfix <- ifelse(results$guess1==22, results$guess2, results$guess1)
results$modelfix <- ifelse(results$guess1==1, results$guess2, results$modelfix)
results$modelfix <- ifelse(results$modelfix%in%errors, 18, results$modelfix)
}

#results$modelfix <- results$guess1
results$camera <- gsub("_.*", '', results$image)

classes$modelfix<-classes$Class.ID
classes$group<-classes$Group.name
classes$taxa<-classes$scientific_name

results <- left_join(results, classes)

tocheck <- read.csv("~/Documents/git/cameratrap/WildlifeDetections_CameraTrap.csv", header=TRUE)
trx<-subset(tocheck, select=c("Sampling.Event", "Raw.Name", "Genus", "Species"))

trx$image <- paste(trx$Sampling.Event, trx$Raw.Name, sep="_")
trx$taxa <- paste(trx$Genus, trx$Species, sep=" ")

trx$camera <- substr(trx$image, 0, 6)
trx$camera <- ifelse(trx$camera == "ATXing", substr(trx$image, 8, 13), trx$camera)

results$camera <- ifelse(results$camera=="CAM6A", "CAM06A", results$camera)

### Here the model uses different classifications of species so I am standardizing the way Andy Wood identified species
# and how that would translate to the model's classifications
if(TRUE){
trx$taxa <- ifelse(trx$taxa=="Vulpes vulpes", "Vulpes vulpes and Urocyon Cinereoargentus", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Canis latrans", "Canidae", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Sciurus carolinensis", "Sciurus spp.", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Sylvilagus floridanus", "Leporidae", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Turdus migratorius", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Carduelis tristis", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Dumetella carolinensis", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Quiscalus quiscula", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Zenaida macroura", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Corvus brachyrhynchos", "Corvidae", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Urocyon cinereoargenteus", "Vulpes vulpes and Urocyon Cinereoargentus", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Passer domesticus", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Butorides virescens", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Neovison vison", "Mustelidae", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Cardinalis cardinalis", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Tamias striatus", "Rodentia", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Lontra canadensis", "Mustelidae", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Ardea herodias", "Aves", trx$taxa)
trx$taxa <- ifelse(trx$taxa=="Martes pennanti", "Mustelidae", trx$taxa)
}
trx<-subset(trx, select=c("camera", "image", "taxa"))

trx <- left_join(trx, classes)

goo <- trx[!(trx$scientific_name!=trx$taxa),]
goo <- na.omit(goo)

trx$checkedbyhand <- trx$Class.ID 
trx <- subset(trx, select=c("image", "camera","checkedbyhand"))

#### Just a quick test - 
checkingmod <- left_join(results, trx)

foo <- checkingmod[!is.na(checkingmod$checkedbyhand),]

howmanymatch <- unique(trx$image)
howaccurate <- checkingmod[(checkingmod$image%in%howmanymatch),]

howaccurate$correct <- ifelse(howaccurate$modelfix == howaccurate$checkedbyhand, 1, 0)
sum(as.numeric(howaccurate$correct), na.rm=TRUE)

####

results.sub <- subset(results, select=c("modelfix", "group", "taxa", "camera", "image"))
uninteresting <- c("Empty", "Human", "Vehicle")
results.sub.noempt <- results.sub[!(results.sub$group%in%uninteresting),]

location <- read.csv("~/Documents/git/cameratrap/WildlifeDetections_CameraTrap.csv", header=TRUE)
location <- subset(location, select=c("Sampling.Event", "Raw.Name", "Latitude", "Longitude" ))

location$image <- paste(location$Sampling.Event, location$Raw.Name, sep="_")

location$camera <- substr(location$image, 0, 6)
location$camera <- ifelse(location$camera == "ATXing", substr(location$image, 8, 13), location$camera)
location$site <- paste(location$Latitude, location$Longitude, sep=" x ")
location <- subset(location, select=c("camera", "site"))
location<-location[!duplicated(location),]

goober <- left_join(results.sub.noempt, location)


rmcams <- c("CAM10A", "CAM11A", "CAM11B")
goober <- goober[!(goober$camera%in%rmcams),]
goober$site <- ifelse(is.na(goober$site), "CAM07A", goober$site)
#goober <- goober[!is.na()]
library(RColorBrewer) 
colourCount =length(unique(goober$group))
quartz()
ggplot(goober, aes(x=group, fill=group)) + geom_bar() + theme_classic() + facet_wrap(~site) +
  theme(axis.text.x = element_text(angle=45, hjust=0.95)) + xlab("") + ylab("Number of images") +
  scale_fill_manual(values = colorRampPalette(brewer.pal(8, "Dark2"))(colourCount))
