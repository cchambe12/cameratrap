## Working on Machine Learning Code
# 2 January 2018 - Cat
## Based off Tabak 2018 paper - using code from https://github.com/mikeyEcology/MLWIC

library(reticulate)
library(tensorflow)
library(MLWIC)

#setwd("/n/wolkovich_lab/Lab/Cat/tnc")

#setup(python_loc = "/n/home00/cchamberlain/.conda/envs/tf1.12_cuda9/bin/python/") ## takes a minute or two! 
if(FALSE){
train(path_prefix = "/n/wolkovich_lab/Lab/Cat/tnc/images", # this is the absolute path to the images. 
      data_info = "/n/wolkovich_lab/Lab/Cat/tnc/train_image_labels.csv", # this is the location of the csv containing image information. It has Unix linebreaks and no headers.
      model_dir = "/n/wolkovich_lab/Lab/Cat/tnc", # assuming this is where you stored the L1 folder in Step 3 of the instructions: github.com/mikeyEcology/MLWIC/blob/master/README
      python_loc = "/n/home00/cchamberlain/.conda/envs/tf1.12_cuda9/bin/", # the location of Python on your computer. 
      num_classes = 28, # this is the number of species from our model. When you train your own model, you will replace this with the number of species/groups of species in your dataset
      log_dir_train = "/n/wolkovich_lab/Lab/Cat/tnc/training_output" # this will be a folder that contains the trained model (call it whatever you want). 
              ### You will specify this folder as the "log_dir" when you classify images using this trained model. 
              ### For example, the log_dir for the model included in this package is called "USDA182"
)
}

classify(path_prefix = "/n/wolkovich_lab/Lab/Cat/tnc/imagesall", # this is the absolute path to the images.
         data_info = "/n/wolkovich_lab/Lab/Cat/tnc/imageall_labels.csv", # this is the location of the csv containing image information. It has Unix linebreaks and no headers.
         model_dir = "/n/wolkovich_lab/Lab/Cat/tnc", # assuming this is where you stored the L1 folder in Step 3 of the instructions: github.com/mikeyEcology/MLWIC/blob/master/README
         python_loc = "/n/home00/cchamberlain/.conda/envs/tf1.12_cuda9/bin/", # the location of Python on your computer. 
         #log_dir = "/n/wolkovich_lab/Lab/Cat/tnc/training_output",
         save_predictions = "model_predictions_usda_all.txt" # this is the default and you should use it unless you have reason otherwise.
)

make_output(output_location = "/n/wolkovich_lab/Lab/Cat/tnc", # the output csv will be stored
            output_name = "test_results_usda_all.csv", # the name of the csv I want to create with my output
            model_dir = "/n/wolkovich_lab/Lab/Cat/tnc", # the location where I stored the L1 folder
            saved_predictions = "model_predictions_usda_all.txt" # the same name that I used for save_predictions in the classify function (if I didn't use default, I would need to change this).
)



