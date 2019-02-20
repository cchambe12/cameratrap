## Working on Machine Learning Code
# 2 January 2018 - Cat
## Based off Tabak 2018 paper - using code from https://github.com/mikeyEcology/MLWIC

# Clear workspace
rm(list=ls()) # remove everything currently held in the R memory
options(stringsAsFactors=FALSE)
graphics.off()

# Load libraries
#library(devtools)
#devtools::install_github("mikeyEcology/MLWIC")
library(reticulate)
library(tensorflow)
library(MLWIC)

setup(python_loc = "/Users/CatherineChamberlain/anaconda3/bin/python") ## takes a minute or two!

setwd("~/Documents/git/cameratrap")

## Step 2: load tensorflow - 
#devtools::install_github("rstudio/tensorflow")
#library(tensorflow)
#install_tensorflow()
sess = tf$Session() ## Sometimes gives error "I tensorflow/core/platform/cpu_feature_guard.cc:141] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA"
 # Doesn't seem to pose a problem for our uses
hello <- tf$constant('Hello, TensorFlow!')
sess$run(hello)

# Step 3: edit names in dataframe
#d<-read.csv("image_labels.csv")
#d$a<-substr(d$EK000002.JPG.0, 0, 12)
#d$b<-substr(d$EK000002.JPG.0, 14, 14)
#d<-d[,-1]
#colnames(d)<-c("a", "b")
#d$a<-as.character(d$a)
#d<-unname(d)
#write.csv(d, file="~/Documents/git/cameratrap/image_labels.csv", row.names=FALSE)


if(FALSE){
  
## Prepare for Training using Wild.ID classifications
tr<-read.csv("WildlifeDetections_CameraTrap.csv", header=TRUE)
trx<-subset(tr, select=c("Sampling.Event", "Raw.Name", "Genus", "Species"))

trx$imageID <- paste(trx$Sampling.Event, trx$Raw.Name, sep="_")
trx$animaltype <- paste(trx$Genus, trx$Species, sep="_")
trx$class <- as.integer(as.factor(trx$animaltype))

#specieslist <- subset(trx, select=c("animaltype", "class"))
#specieslist <- specieslist[!duplicated(specieslist),]
#write.csv(specieslist, file="listofspecies.csv", row.names=FALSE)

trx <- subset(trx, select=c("imageID", "class"))
images <- trx

colnames(trx) <- NULL
write.csv(trx, file="train_image_labels.csv", row.names=FALSE)

### Prepare for download...
images$camera <- substr(images$imageID, 0, 6)
images$camera <- ifelse(images$camera == "ATXing", substr(images$imageID, 8, 13), images$camera)

cam01A <- images[(images$camera=="CAM01A"),]

file.copy("source_file.txt", "destination_folder")

fileNames <- Sys.glob("*.csv")

train(path_prefix = "/Users/CatherineChamberlain/Documents/git/cameratrap/images", # this is the absolute path to the images. 
      data_info = "/Users/CatherineChamberlain/Documents/git/cameratrap/train_image_labels.csv", # this is the location of the csv containing image information. It has Unix linebreaks and no headers.
      model_dir = "/Users/CatherineChamberlain/Documents/git/cameratrap", # assuming this is where you stored the L1 folder in Step 3 of the instructions: github.com/mikeyEcology/MLWIC/blob/master/README
      python_loc = "/usr/local/bin/", # the location of Python on your computer. 
      num_classes = 3, # this is the number of species from our model. When you train your own model, you will replace this with the number of species/groups of species in your dataset
      log_dir_train = "/Users/CatherineChamberlain/Documents/git/cameratrap/training_output" # this will be a folder that contains the trained model (call it whatever you want). You will specify this folder as the "log_dir" when you classify images using this trained model. For example, the log_dir for the model included in this package is called "USDA182"
)

}



classify(path_prefix = "/Users/CatherineChamberlain/Documents/git/cameratrap/images", # this is the absolute path to the images.
         data_info = "/Users/CatherineChamberlain/Documents/git/cameratrap/image_labels.csv", # this is the location of the csv containing image information. It has Unix linebreaks and no headers.
         model_dir = "/Users/CatherineChamberlain/Documents/git/cameratrap", # assuming this is where you stored the L1 folder in Step 3 of the instructions: github.com/mikeyEcology/MLWIC/blob/master/README
         python_loc = "/usr/local/bin/", # the location of Python on your computer. 
         save_predictions = "model_predictions.txt" # this is the default and you should use it unless you have reason otherwise.
)

make_output(output_location = "~/Documents/git/cameratrap", # the output csv will be stored on my dekstop
            output_name = "zamba_results.csv", # the name of the csv I want to create with my output
            model_dir = "~/Documents/git/cameratrap", # the location where I stored the L1 folder
            saved_predictions = "output_class_names.txt" # the same name that I used for save_predictions in the classify function (if I didn't use default, I would need to change this).
)


######## Now check out example_results.cvs vs wild.id results
exam <- read.csv("example_results.csv", header=TRUE)
exam$Raw.Name <- substr(exam$fileName, 61, 72)

idnames <- read.csv("classID_names.csv", header=TRUE)

exam$Photo.Type.Sp <- NA
for(i in c(1:nrow(exam))){
  for(j in c(1:nrow(idnames)))
      exam$Photo.Type.Sp[i] <- ifelse(exam$guess1[i] == idnames$Class.ID[j], idnames$Group.name[j], exam$Photo.Type.Sp[i])
  
  
}

examx <- subset(exam, select = c("Raw.Name", "Photo.Type.Sp", "guess1"))

verify <- full_join(examx, trx)

animals <- c(0:10, 12:24, 25)

verify$hit <- NA
verify$hit <- ifelse(verify$Photo.Type == "Misfired" & verify$Photo.Type.Sp == "Human",
                     1, verify$hit)
verify$hit <- ifelse(verify$Photo.Type == "Blank" & verify$Photo.Type.Sp == "Empty",
                     1, verify$hit)
verify$hit <- ifelse(verify$Photo.Type == "Animal" & verify$guess1 %in% animals,
                     1, verify$hit)

verify$hit <- ifelse(is.na(verify$hit), 0, verify$hit)

accuracy = length(verify$hit[(verify$hit==1)]) / length(verify$hit) # 71.8% accuracy

misses <- subset(verify, verify$hit == 0)
mis.humans <- subset(misses, misses$Photo.Type=="Misfired")

photos <- unique(mis.humans$Raw.Name)

exam.humans <- exam[(exam$Raw.Name %in% photos),]



