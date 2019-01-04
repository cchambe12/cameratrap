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
library(MLWIC)
library(reticulate)
library(tensorflow)

## Step 2: load tensorflow - 
devtools::install_github("rstudio/tensorflow")
library(tensorflow)
install_tensorflow(conda="auto")
sess = tf$Session()
hello <- tf$constant('Hello, TensorFlow!')
sess$run(hello)

# Step 3: edit names in dataframe
d<-read.csv("~/Documents/git/cameratrap/image_labels.csv")
colnames(d)<-c("a", "b")
d$a<-as.character(d$a)
colnames(d)<-NULL
write.csv(d, file="~/Documents/git/cameratrap/image_labels.csv", row.names = FALSE)


classify(path_prefix = "/Users/CatherineChamberlain/Documents/git/cameratrap/images", # this is the absolute path to the images.
         log_dir = "training_output",  
         data_info = "~/Documents/git/cameratrap/image_labels.csv", # this is the location of the csv containing image information. It has Unix linebreaks and no headers.
         model_dir = "~/Documents/git/cameratrap", # assuming this is where you stored the L1 folder in Step 3 of the instructions: github.com/mikeyEcology/MLWIC/blob/master/README
         python_loc = "/usr/local/bin/", # the location of Python on your computer. 
         save_predictions = "model_predictions.txt" # this is the default and you should use it unless you have reason otherwise.
)

make_output(output_location = "~/Documents/git/cameratrap", # the output csv will be stored on my dekstop
            output_name = "example_results.csv", # the name of the csv I want to create with my output
            model_dir = "~/Documents/git/cameratrap", # the location where I stored the L1 folder
            saved_predictions = "model_predictions.txt" # the same name that I used for save_predictions in the classify function (if I didn't use default, I would need to change this).
)

train(path_prefix = "~/Documents/git/cameratrap/images", # this is the absolute path to the images. 
      data_info = "~/Documents/git/cameratrap/train_image_labels.csv", # this is the location of the csv containing image information. It has Unix linebreaks and no headers.
      model_dir = "~/Documents/git/cameratrap", # assuming this is where you stored the L1 folder in Step 3 of the instructions: github.com/mikeyEcology/MLWIC/blob/master/README
      python_loc = "/usr/local/bin/", # the location of Python on your computer. 
      num_classes = 3, # this is the number of species from our model. When you train your own model, you will replace this with the number of species/groups of species in your dataset
      log_dir_train = "training_output" # this will be a folder that contains the trained model (call it whatever you want). You will specify this folder as the "log_dir" when you classify images using this trained model. For example, the log_dir for the model included in this package is called "USDA182"
)
