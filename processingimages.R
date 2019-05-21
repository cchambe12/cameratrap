## Working on Machine Learning Code
# 2 January 2018 - Cat
## Based off Tabak 2018 paper - using code from https://github.com/mikeyEcology/MLWIC

# Clear workspace
rm(list=ls()) # remove everything currently held in the R memory
options(stringsAsFactors=FALSE)
graphics.off()

#### Need to follow a number of steps before classifying your images. For more detailed directions
# follow the workflow given above -  Based off Tabak 2018 paper - using code from https://github.com/mikeyEcology/MLWIC
## Below are shortcut reminders of what needs to happen first. It is primarily based for Mac's, for direction for Windows follow the link above

## 0) BACK UP YOUR IMAGES!!!!

# 1) Install MLWIC package as seen below

# Load libraries
#library(devtools)
#devtools::install_github("mikeyEcology/MLWIC")

# 2) Install tensorflow on computer - can follow direction here: https://www.tensorflow.org/install/
library(reticulate)
library(tensorflow)
library(MLWIC)

# 3) Download the L1 folder from here: https://drive.google.com/file/d/1dY-49drRrSotFMHOOPZXrTgl5gqozGVL/view
  ## Make sure to keep this in the same folder as your images. To have more specific directions, follow workflow for Step #3 here: https://github.com/mikeyEcology/MLWIC

# 4) Set up python on your computer. Below we pair it with R functions
setup(python_loc = "/Users/CatherineChamberlain/anaconda3/bin/python") ## takes a minute or two! 
     ### and also depends on your directory! Make sure to change the path, 
      ### you can find your direct path using Terminal or the search function on a Mac

# 5) Set your working directory (i.e., the same folder you designated to put your L1 folder)
setwd("~/Documents/git/cameratrap")

# 6) Check to make sure tensorflow is working...
## load tensorflow - 
#devtools::install_github("rstudio/tensorflow")
#library(tensorflow)
#install_tensorflow()
sess = tf$Session() ## Sometimes gives error "I tensorflow/core/platform/cpu_feature_guard.cc:141] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA"
 # Doesn't seem to pose a problem for our uses
hello <- tf$constant('Hello, TensorFlow!')
sess$run(hello)

# 7) Make sure your photos have unique IDs
    ### If the camera ID is different but the image names are the same, just add the camera ID to the front of the image name
    ## a fast way to do this is to copy the camera ID name, select all images from that camera date, right click, 
    ## click "Rename XX items", and copy and pasting camera ID name in the dropdown, and select 'before name'


# 8) Resize your images on your Mac (need to find directions for Windows on this part...)
  ## Select all of your images and drag them onto the Resize_Images app in your cameratrap folder
    ### don't include any folders, just select all images and then drag them over the application
  ## This may take a few minutes depending on how many images you have

  ############### This is how build a new app in Automator #####################
 ## a. Click on the magnifying glass in the top right corner of your Mac window
  # b. Search for 'Automator' and click 'enter'
  # c. In Automator, click on 'Files and Folders' on the left, then click on 'New Folder' 
      # in the middle panel. Drag the 'New Folder' option to the right pane. 
  # d. Rename the folder to "Resized Images"
  # d. Drag 'Get Folder Contents' into the right pane
  # e. Click on Photos on the left. Then drag 'Change Type of Images' into the right. Click 'Don't Add' !!
  # f. Drag 'Scale Images' into the right pane. Again click 'Don't Add' !!
  # g. Have 'To Size (pixels)' selected and then type in 256 into the box under the 'Scale Images' heading
  ##############################################################################

# 9) Make sure all of your images are in a folder called 'images' without any subfolders (this should happen automatically if you use Resize_Images.app)

# 10) Create a new .csv file. One column should have all of your image names and the 
      ### second column should be all zeros. Do not name the columns (i.e., no column headers)!

### To retrain the machine learning tool change if(FALSE) to if(TRUE) on line 78...

if(FALSE){
train(path_prefix = "/Users/CatherineChamberlain/Documents/git/cameratrap/images", # this is the absolute path to the images. 
      data_info = "/Users/CatherineChamberlain/Documents/git/cameratrap/train_image_labels.csv", # this is the location of the csv containing image information. It has Unix linebreaks and no headers.
      model_dir = "/Users/CatherineChamberlain/Documents/git/cameratrap", # assuming this is where you stored the L1 folder in Step 3 of the instructions: github.com/mikeyEcology/MLWIC/blob/master/README
      python_loc = "/usr/local/bin/", # the location of Python on your computer. 
      num_classes = 28, # this is the number of species from our model. When you train your own model, you will replace this with the number of species/groups of species in your dataset
      log_dir_train = "/Users/CatherineChamberlain/Documents/git/cameratrap/training_output" # this will be a folder that contains the trained model (call it whatever you want). 
              ### You will specify this folder as the "log_dir" when you classify images using this trained model. 
              ### For example, the log_dir for the model included in this package is called "USDA182"
)


}


### To classify images using the Tabak et al. 2018 USDA182 machine learning tool
classify(path_prefix = "/Users/CatherineChamberlain/Documents/git/cameratrap/images", # this is the absolute path to the images.
         data_info = "/Users/CatherineChamberlain/Documents/git/cameratrap/image_labels.csv", # this is the location of the csv containing image information. It has Unix linebreaks and no headers.
         model_dir = "/Users/CatherineChamberlain/Documents/git/cameratrap", # assuming this is where you stored the L1 folder in Step 3 of the instructions: github.com/mikeyEcology/MLWIC/blob/master/README
         python_loc = "/usr/local/bin/", # the location of Python on your computer. 
         save_predictions = "model_predictions.txt" # this is the default and you should use it unless you have reason otherwise.
)

## Makes it into nicer, more user friendly output
make_output(output_location = "~/Documents/git/cameratrap", # the output csv will be stored on my dekstop
            output_name = "tnc_nottrained_results.csv", # the name of the csv I want to create with my output
            model_dir = "~/Documents/git/cameratrap", # the location where I stored the L1 folder
            saved_predictions = "output_class_names.txt" # the same name that I used for save_predictions in the classify function (if I didn't use default, I would need to change this).
)






