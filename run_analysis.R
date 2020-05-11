## ---------------------------------------------------------------------------------------
## SUMMARY: 
##          Coursera: Johns Hopkins University: Data Science Specialization
##          Course #3 - Getting and Cleaning Data
##
##          Peer-graded Assignment: Getting and Cleaning Data Course Project
##
## .R MODULE NAMING CONVENSION, EXAMPLE
##          ds3_w4pga1_1.R: ds3= Data Science (Course) #3; w4= Week #4; 
##                          pga1= Peer Graded Assignment #1; _1 = problem #1 
##          
##          General Notation: dsA_wBqC_D.R 
##          - ds = DataScience specialization
##          - A  = Course #A - e.g. 3= getting and cleaning data
##          - wB = Week #B - e.g. [w1] for Week #1
##          - qC = <Activity Type> #C - e.g. [Quiz1] or Q1 for short
##          --- can be Quiz, Video, Problem, Assignment, ...
##          - _D = Problem/Question number, D# - e.g. [_5] stand for question number 5
##
## REFS
##          https://www.coursera.org/learn/data-cleaning?specialization=jhu-data-science
##
##          (!) WHY? --> https://www.kaggle.com/questions-and-answers/40640 - Why would we combine both train and test data sets
##                       ---> https://www.kaggle.com/pliptor/a-pca-playground
##                            https://www.kaggle.com/c/titanic/discussion/37730
##                            https://www.kaggle.com/pliptor/a-pca-playground (!)
##
##          (Background of the scope) 
##          https://www.itnews.com/article/2115126/big-data--activity-tracking--and-the-battle-for-the-world-s-top-sports-brand.html
##
##          http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##          https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## Intent:  see below
##
## Author:  oseng, https://github.com/eng-r
## Contact: <public e-mail> 51923315+eng-r@users.noreply.github.com
## Date:    01-May ... 09-May-2020
## Version: 0.2b
## --------------------------------------------------------------------------------------

rm(list = ls())

library(stringr)
library(utils)
library(dplyr)
# The principal function provided by the magrittr package is %>%
# install.packages("magrittr")
library("magrittr")

# ---------------------------------------------------------------------------------------
# GENERAL INSTRUCTIONS
# 0. Install missing packages (R-Studio command prompt), if any:
#      ---> install.packages("<some name>")
# 1. Run R-Studio, load this .R script, got to 'Session' -> 'Set Working Directory' ...
#       ... -> To Source File Location
# 2. At console, type and invoke: source("<this script>.R")
# 3. Delete from hard drive destFile and infoFile if you want download from scratch
# 3b. Delete unzipped folder if want a clean reproduction 
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# THE INTENT
# "The purpose of this project is to demonstrate your ability to collect, work with, 
# and clean a data set."
# https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project
# ---------------------------------------------------------------------------------------
"
The purpose of this project is to demonstrate your ability to collect, 
work with, and clean a data set. The goal is to prepare tidy data that can be used 
for later analysis. You will be graded by your peers on a series of yes/no questions 
related to the project. You will be required to submit: 
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or 
work that you performed to clean up the data called CodeBook.md. 

You should also include a README.md in the repo with your scripts. 
This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable 
computing - see for example this article. 
https://www.itnews.com/article/2115126/big-data--activity-tracking--and-the-battle-for-the-world-s-top-sports-brand.html

Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced 
algorithms to attract new users. The data linked to from the course website represent 
data collected from the accelerometers from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement.
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive variable names.
    From the data set in step 4, creates a second, independent tidy data set with the 
    average of each variable for each activity and each subject.
"

# ---------------------------------------------------------------------------------------

"
Review criteria

    The submitted data set is tidy.
    The Github repo contains the required scripts.
    GitHub contains a code book that modifies and updates the available codebooks 
       with the data to indicate all the variables and summaries calculated, 
       along with units, and any other relevant information.
    The README that explains the analysis files is clear and understandable.
    The work submitted for this project is the work of the student who submitted it.
"

# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#                      *** SOME HELPER FUNCTIONS / API ***
#
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# SANITY CHECK 
# ---------------------------------------------------------------------------------------
sanityCheck_AreFaturesUnique_ThisProblemScope <- function(dataFrame) {
  ind <- which(duplicated(colnames(dataFrame)) == TRUE)
  nonUniqueFeatures <- colnames(dataFrame)[ind]
  # print("Non-unique column names: ")
  # print(nonUniqueFeatures)

  # sanity check for _OUR TASK_
  # Extracts only the measurements on the mean and standard deviation for each measurement.
  L1 <- length(which(str_detect(tolower(nonUniqueFeatures), "mean")==TRUE))       # see "ThisProblemScope" :-)
  L2 <- length(which(str_detect(tolower(nonUniqueFeatures), "std")==TRUE))

  # REF: https://stackoverflow.com/questions/14577412/how-to-convert-variable-object-name-into-string
  cat("Checking", deparse(substitute(dataFrame)))

  # in this specifi case '&' and '&&' are both OK (!) - Warning though...
  if(L1 == 0 && L2 == 0) {  # https://www.quora.com/What-is-the-difference-between-and-and-between-and-in-R
     print("LUCKY YOU: mean AND standard deviation features [columns] are unique")
  } else {
     print("WARNING: non-unique mean OR standard deviation features [columns] are found")
  }
}

# ---------------------------------------------------------------------------------------
# RETURN DATAFRAME W/ MEAN/STD
# ---------------------------------------------------------------------------------------
select_ThisProblemScope <- function(dataFrame) {
  ind1 <- which(str_detect(tolower(colnames(dataFrame)), "mean") == TRUE)
  ind2 <- which(str_detect(tolower(colnames(dataFrame)), "std") == TRUE)

  cat("Debug Index1/2: ", length(ind1), length(ind2), "\n")

  X1 <- dataFrame[c(1, 2, ind1)]  # include SUBJECT, LABEL which are the first 2 columns
  X2 <- dataFrame[ind2]

  X <- cbind(X1, X2)  
  X
}

# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#                         *** SCRIPT ENTRY POINT ***
#
# ---------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

datasetSubfolder <- "UCI HAR Dataset"

# ---------------------------------------------------------------------------------------
# 1. Downloading and Unzipping
# ---------------------------------------------------------------------------------------

# let's download from the web source 
fileUrl <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
# NOTE: in my .gitignore I have:  
#
# Data/ds3_w4pga1_1.zip
# Data/ds3_w4pga1_1_info.txt
# Data/UCI HAR Dataset/ - see (NOTE 1*) below
#

destFile <- "Data/ds3_w4pga1_1.zip"
infoFile <- "Data/ds3_w4pga1_1_info.txt"

# --- download only if there is no file yet on hard drive
if(!file.exists(destFile)) {
    dir.create(file.path("Data"), showWarnings = FALSE)
    print("Downloading local copy of dataset ZIP. Wait...")
    download.file(fileUrl, destfile= destFile)  # same naming convention as .R
    dateDownloaded <- date()
    # dateDownloaded etc - let's save for our own records
    write.table(df<- data.frame(dateDownloaded, fileUrl, destFile), file = infoFile, sep= ", ")
    print("...created local copy of dataset ZIP")
} else {    # "else" must be on the same line as closing "}" from the "if"
    print("Using pre-downloaded local copy of dataset ZIP.")  
}

# as a result I had:
# trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
# Content type 'application/zip' length 62556944 bytes (59.7 MB)
# downloaded 59.7 MB

list.files()
# https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/unzip
# use install.packages("utils") if not installed yet
# 
# library(utils) # used to unzip; assuming the packaged has been installed 

# (NOTE 1*) UCI HAR Dataset will created at the level as .R script
if(!file.exists(datasetSubfolder)) {
  print("Unzipping local copy of the dataset.")  
  debug_1 <- unzip(destFile, files = NULL, list = FALSE, overwrite = TRUE, 
            junkpaths = FALSE, exdir = ".", 
            unzip = "internal", setTimes = FALSE)
} else {
    print("Using existing unZIPped local copy of the dataset.")  
}

# ---------------------------------------------------------------------------------------
# 2. Load training and test datasets
# ---------------------------------------------------------------------------------------
# library(dplyr) # moved to the top 

# ---------------------------------------------------------------------------------------
fullFName_Label_Train <- paste(datasetSubfolder, "/train/", "y_train.txt", sep= "");
fullFName_Data_Train <- paste(datasetSubfolder, "/train/", "X_train.txt", sep= "");
fullFName_Subject_Train <- paste(datasetSubfolder, "/train/", "subject_train.txt", sep= "");

fullFName_Label_Test  <- paste(datasetSubfolder, "/test/" , "y_test.txt", sep= "");
fullFName_Data_Test  <- paste(datasetSubfolder, "/test/",  "X_test.txt", sep= "");
fullFName_Subject_Test <- paste(datasetSubfolder, "/test/", "subject_test.txt", sep= "");

cat("Files to deal with: ", "[", fullFName_Label_Train, "] [", fullFName_Label_Test, "] [", fullFName_Data_Train, "] [", fullFName_Data_Test, "]", "\n", sep="")

featuresFName <- "features.txt"
activityFName <- "activity_labels.txt"
fullFName_Features <- paste(datasetSubfolder, "/", featuresFName, sep= "")
fullFName_Activity <- paste(datasetSubfolder, "/", activityFName, sep= "")

# --- load supportive names -----------------------------------------------------------------------------------------
features <- read.table(fullFName_Features, stringsAsFactors= FALSE)
activities <- read.table(fullFName_Activity, stringsAsFactors= FALSE)  # activities$V2 carries actual str-form names 

# subject, aka 'person #' :-)
trainSubject <- read.table(fullFName_Subject_Train)
testSubject <- read.table(fullFName_Subject_Test)

# get rid of 'data frame' representation - we are going to insert it as numerical values column
# similar to labels which are str[]
trainSubject <- as.numeric(unlist(trainSubject))
testSubject <- as.numeric(unlist(testSubject))

# --- load trainData first ------------------------------------------------------------------------------------------
print("Loading datasets...")
trainData <- read.table(fullFName_Data_Train)
## make meaningful column names based on known features names that we loaded separately
#colnames(trainData)<-features$V2

# --- load testData secondly ----------------------------------------------------------------------------------------
testData <- read.table(fullFName_Data_Test)
## make meaningful column names based on known features names that we loaded separately
#colnames(testData)<-features$V2
print("...complete")

# --- load trainLabel -----------------------------------------------------------------------------------------------
# --- load testLabel ------------------------------------------------------------------------------------------------
trainLabel <- read.table(fullFName_Label_Train)
testLabel  <- read.table(fullFName_Label_Test)

## make meaningful activities names across the whole dataset w/ activities IDs 
## based on known activities reference table [activity_labels.txt] that we loaded separately
## REF: https://stackoverflow.com/questions/14417612/r-replace-an-id-value-with-a-name
## 
#trainLabel2 <- activities[match(trainLabel$V1, activities$V1), "V2"]   # "V2" holds names of activities ...
#testLabel2 <- activities[match(testLabel$V1, activities$V1), "V2"]     # ...while "V1" hold IDs - numerical values
#

trainLabel <- as.numeric(unlist(trainLabel))
testLabel <- as.numeric(unlist(testLabel))

# ---------------------------------------------------------------------------------------
# 3. Merging 2 sets: training and test
# ---------------------------------------------------------------------------------------

# --- 3b First, add labels as a first column and then make sounding column names --------
# --- 3b2 Add subject as 1st - was overlooked at first pass

## Mutate data frames by adding  columns
trainData2 <- mutate(trainData, subject= trainSubject, label= trainLabel)    # give name "label" to the new column 
# REF: https://stackoverflow.com/questions/22286419/move-a-column-to-first-position-in-a-data-frame
trainData2<- select(trainData2, subject, label, everything())   # move this column to be the first one

testData2 <- mutate(testData, subject= testSubject, label= testLabel)    
testData2 <- select(testData2, subject, label, everything()) 

testData2 <- arrange(testData2, subject, label)
trainData2 <- arrange(trainData2, subject, label)

# make meaningful column names 
colnames(trainData2) <- c("SubjectNum", "Activity", features$V2)   # rename to fit the assignment 
colnames(testData2) <- c("SubjectNum", "Activity", features$V2)   

# --- 3c Now, do the rest ---------------------------------------------------------------

# --- 3c.1 - Sanity check first ---------------------------------------------------------
sanityCheck_AreFaturesUnique_ThisProblemScope(trainData2)
sanityCheck_AreFaturesUnique_ThisProblemScope(testData2)

"
# clean up now a bit
# -- remove Data --- 
rm(testData)
rm(trainData)
rm(testLabel)
rm(trainLabel)
# rm(activities)
# rm(features)
rm(trainSubject)
rm(testSubject)

# -- remove values --- 
rm(trainLabel2)
rm(testLabel2)
rm(infoFile)
rm(fileUrl)
rm(activityFName)
rm(datasetSubfolder)
rm(destFile)
rm(featuresFName)
rm(fullFName_Label_Train)
rm(fullFName_Data_Train)
rm(fullFName_Label_Test)
rm(fullFName_Data_Test)
rm(fullFName_Features)
rm(fullFName_Activity)
rm(fullFName_Subject_Test)
rm(fullFName_Subject_Train)
"

# --- 3c.2 - Do the merge of two pre-processed dataset ----------------------------------
# mergedData = merge(trainData2, testData2, by.x="LABEL", by.y="LABEL",all=FALSE)
# https://www.pluralsight.com/guides/splitting-combining-data-r
mergedData <- rbind(trainData2, testData2)
# glimpse(mergedData)


selectedData <- select_ThisProblemScope(mergedData)
# X <- colMeans(selectedData[, 2:dim(selectedData)[2]])
 
# gr <- group_by(selectedData, selectedData$LABEL)  # returns a tibble, or tbl_df, is a modern reimagining of the data.frame
## https://datacarpentry.org/R-genomics/04-dplyr.html
## https://rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
#  dplyr::summarise_each(... , funs(mean))

# https://www.guru99.com/r-aggregate-function.html

s <- selectedData %>%
	group_by(SubjectNum, Activity) %>%
	summarise_each(funs(mean))

options(pillar.sigfig = 9)  
print(s)


# FROM ASSIGNMENT:
# Please upload the tidy data set created in step 5 of the instructions. 
# Please upload your data set as a txt file created with write.table() 
# using row.name=FALSE (do not cut and paste a dataset directly 
# into the text box, as this may cause errors saving your submission).

# replace numeric values w/ char names
s$Activity <- activities[match(s$Activity, activities$V1), "V2"]   # "V2" holds names of activities ...

# make column names tidy as well
# ref: names(selectedData) gives vars names

#
# [1] "SubjectNum"                           "Activity"                             "tBodyAcc-mean()-X"                   
# [4] "tBodyAcc-mean()-Y"                    "tBodyAcc-mean()-Z"                    "tGravityAcc-mean()-X"                
# [7] "tGravityAcc-mean()-Y"                 "tGravityAcc-mean()-Z"                 "tBodyAccJerk-mean()-X"               
#[10] "tBodyAccJerk-mean()-Y"                "tBodyAccJerk-mean()-Z"                "tBodyGyro-mean()-X"                  
#[13] "tBodyGyro-mean()-Y"                   "tBodyGyro-mean()-Z"                   "tBodyGyroJerk-mean()-X"              
#[16] "tBodyGyroJerk-mean()-Y"               "tBodyGyroJerk-mean()-Z"               "tBodyAccMag-mean()"                  
#[19] "tGravityAccMag-mean()"                "tBodyAccJerkMag-mean()"               "tBodyGyroMag-mean()"                 
#[22] "tBodyGyroJerkMag-mean()"              "fBodyAcc-mean()-X"                    "fBodyAcc-mean()-Y"                   
#[25] "fBodyAcc-mean()-Z"                    "fBodyAcc-meanFreq()-X"                "fBodyAcc-meanFreq()-Y"               
#[28] "fBodyAcc-meanFreq()-Z"                "fBodyAccJerk-mean()-X"                "fBodyAccJerk-mean()-Y"               
#[31] "fBodyAccJerk-mean()-Z"                "fBodyAccJerk-meanFreq()-X"            "fBodyAccJerk-meanFreq()-Y"           
#[34] "fBodyAccJerk-meanFreq()-Z"            "fBodyGyro-mean()-X"                   "fBodyGyro-mean()-Y"                  
#[37] "fBodyGyro-mean()-Z"                   "fBodyGyro-meanFreq()-X"               "fBodyGyro-meanFreq()-Y"              
#[40] "fBodyGyro-meanFreq()-Z"               "fBodyAccMag-mean()"                   "fBodyAccMag-meanFreq()"              
#[43] "fBodyBodyAccJerkMag-mean()"           "fBodyBodyAccJerkMag-meanFreq()"       "fBodyBodyGyroMag-mean()"             
#46] "fBodyBodyGyroMag-meanFreq()"          "fBodyBodyGyroJerkMag-mean()"          "fBodyBodyGyroJerkMag-meanFreq()"     
#[49] "angle(tBodyAccMean,gravity)"          "angle(tBodyAccJerkMean),gravityMean)" "angle(tBodyGyroMean,gravityMean)"    
#[52] "angle(tBodyGyroJerkMean,gravityMean)" "angle(X,gravityMean)"                 "angle(Y,gravityMean)"                
#[55] "angle(Z,gravityMean)"                 "tBodyAcc-std()-X"                     "tBodyAcc-std()-Y"                    
#[58] "tBodyAcc-std()-Z"                     "tGravityAcc-std()-X"                  "tGravityAcc-std()-Y"                 
#[61] "tGravityAcc-std()-Z"                  "tBodyAccJerk-std()-X"                 "tBodyAccJerk-std()-Y"                
#[64] "tBodyAccJerk-std()-Z"                 "tBodyGyro-std()-X"                    "tBodyGyro-std()-Y"                   
#[67] "tBodyGyro-std()-Z"                    "tBodyGyroJerk-std()-X"                "tBodyGyroJerk-std()-Y"               
#[70] "tBodyGyroJerk-std()-Z"                "tBodyAccMag-std()"                    "tGravityAccMag-std()"                
#[73] "tBodyAccJerkMag-std()"                "tBodyGyroMag-std()"                   "tBodyGyroJerkMag-std()"              
#[76] "fBodyAcc-std()-X"                     "fBodyAcc-std()-Y"                     "fBodyAcc-std()-Z"                    
#[79] "fBodyAccJerk-std()-X"                 "fBodyAccJerk-std()-Y"                 "fBodyAccJerk-std()-Z"                
#[82] "fBodyGyro-std()-X"                    "fBodyGyro-std()-Y"                    "fBodyGyro-std()-Z"                   
#[85] "fBodyAccMag-std()"                    "fBodyBodyAccJerkMag-std()"            "fBodyBodyGyroMag-std()"              
#[88] "fBodyBodyGyroJerkMag-std()"     
#

# duplicates to be gone 
names(s) <- gsub("BodyBody", "Body", x= names(s))

# shorer name is OK to me personally but to be on a nerd wave :-) let's make fun replacing to the longer names
names(s)<-gsub("Acc",  "Accelerometer", x= names(s))
names(s)<-gsub("Gyro", "Gyroscope",     x= names(s))

names(s)<-gsub("Mag",  "Magnitude",     x= names(s))

# all which starts w/ t or f - let's change to Time/Frequency
names(s) <- gsub("^t", "Time",      x= names(s))
# names(s)<-gsub("tBody", "TimeBody", names(s))
names(s) <- gsub("^f", "Frequency", x= names(s))

# be consistent in upper/lower cases 
names(s)<-gsub("angle", "Angle",     names(s))  # 'x' can be omited 
names(s)<-gsub("gravity", "Gravity", names(s))

# REF EXAMPLE below:
# https://stackoverflow.com/questions/49681952/removing-replacing-brackets-from-r-string-using-gsub
# gsub("[()]", "", "(abc)")
# The additional square brackets mean "match any of the characters inside".
#

# all having () be replaced to more nice
names(s) <- gsub("-mean()", "Mean",       x= names(s)) # , ignore.case = TRUE)
names(s) <- gsub("-std()",  "Std",        x= names(s), ignore.case = T)
names(s) <- gsub("-freq()", "Frequency",  x= names(s), ignore.case = TRUE)

names(s) <- gsub("[()]", "", names(s)) #, ignore.case = TRUE)

# dump it now to the file!
write.table(s[, 1:dim(s)[2]], file = "ds3_w4pga1_1_results.csv", sep= ",", row.names= FALSE, quote= F)

# as a result of names modification:
# 
# > names(s)
#  [1] "SubjectNum"                                      "Activity"                                       
#  [3] "TimeBodyAccelerometerMean-X"                     "TimeBodyAccelerometerMean-Y"                    
#  [5] "TimeBodyAccelerometerMean-Z"                     "TimeGravityAccelerometerMean-X"                 
#  [7] "TimeGravityAccelerometerMean-Y"                  "TimeGravityAccelerometerMean-Z"                 
#  [9] "TimeBodyAccelerometerJerkMean-X"                 "TimeBodyAccelerometerJerkMean-Y"                
# [11] "TimeBodyAccelerometerJerkMean-Z"                 "TimeBodyGyroscopeMean-X"                        
# [13] "TimeBodyGyroscopeMean-Y"                         "TimeBodyGyroscopeMean-Z"                        
# [15] "TimeBodyGyroscopeJerkMean-X"                     "TimeBodyGyroscopeJerkMean-Y"                    
# [17] "TimeBodyGyroscopeJerkMean-Z"                     "TimeBodyAccelerometerMagnitudeMean"             
# [19] "TimeGravityAccelerometerMagnitudeMean"           "TimeBodyAccelerometerJerkMagnitudeMean"         
# [21] "TimeBodyGyroscopeMagnitudeMean"                  "TimeBodyGyroscopeJerkMagnitudeMean"             
# [23] "FrequencyBodyAccelerometerMean-X"                "FrequencyBodyAccelerometerMean-Y"               
# [25] "FrequencyBodyAccelerometerMean-Z"                "FrequencyBodyAccelerometerMeanFreq-X"           
# [27] "FrequencyBodyAccelerometerMeanFreq-Y"            "FrequencyBodyAccelerometerMeanFreq-Z"           
# [29] "FrequencyBodyAccelerometerJerkMean-X"            "FrequencyBodyAccelerometerJerkMean-Y"           
# [31] "FrequencyBodyAccelerometerJerkMean-Z"            "FrequencyBodyAccelerometerJerkMeanFreq-X"       
# [33] "FrequencyBodyAccelerometerJerkMeanFreq-Y"        "FrequencyBodyAccelerometerJerkMeanFreq-Z"       
# [35] "FrequencyBodyGyroscopeMean-X"                    "FrequencyBodyGyroscopeMean-Y"                   
# [37] "FrequencyBodyGyroscopeMean-Z"                    "FrequencyBodyGyroscopeMeanFreq-X"               
# [39] "FrequencyBodyGyroscopeMeanFreq-Y"                "FrequencyBodyGyroscopeMeanFreq-Z"               
# [41] "FrequencyBodyAccelerometerMagnitudeMean"         "FrequencyBodyAccelerometerMagnitudeMeanFreq"    
# [43] "FrequencyBodyAccelerometerJerkMagnitudeMean"     "FrequencyBodyAccelerometerJerkMagnitudeMeanFreq"
# [45] "FrequencyBodyGyroscopeMagnitudeMean"             "FrequencyBodyGyroscopeMagnitudeMeanFreq"        
# [47] "FrequencyBodyGyroscopeJerkMagnitudeMean"         "FrequencyBodyGyroscopeJerkMagnitudeMeanFreq"    
# [49] "AngletBodyAccelerometerMean,Gravity"             "AngletBodyAccelerometerJerkMean,GravityMean"    
# [51] "AngletBodyGyroscopeMean,GravityMean"             "AngletBodyGyroscopeJerkMean,GravityMean"        
# [53] "AngleX,GravityMean"                              "AngleY,GravityMean"                             
# [55] "AngleZ,GravityMean"                              "TimeBodyAccelerometerStd-X"                     
# [57] "TimeBodyAccelerometerStd-Y"                      "TimeBodyAccelerometerStd-Z"                     
# [59] "TimeGravityAccelerometerStd-X"                   "TimeGravityAccelerometerStd-Y"                  
# [61] "TimeGravityAccelerometerStd-Z"                   "TimeBodyAccelerometerJerkStd-X"                 
# [63] "TimeBodyAccelerometerJerkStd-Y"                  "TimeBodyAccelerometerJerkStd-Z"                 
# [65] "TimeBodyGyroscopeStd-X"                          "TimeBodyGyroscopeStd-Y"                         
# [67] "TimeBodyGyroscopeStd-Z"                          "TimeBodyGyroscopeJerkStd-X"                     
# [69] "TimeBodyGyroscopeJerkStd-Y"                      "TimeBodyGyroscopeJerkStd-Z"                     
# [71] "TimeBodyAccelerometerMagnitudeStd"               "TimeGravityAccelerometerMagnitudeStd"           
# [73] "TimeBodyAccelerometerJerkMagnitudeStd"           "TimeBodyGyroscopeMagnitudeStd"                  
# [75] "TimeBodyGyroscopeJerkMagnitudeStd"               "FrequencyBodyAccelerometerStd-X"                
# [77] "FrequencyBodyAccelerometerStd-Y"                 "FrequencyBodyAccelerometerStd-Z"                
# [79] "FrequencyBodyAccelerometerJerkStd-X"             "FrequencyBodyAccelerometerJerkStd-Y"            
# [81] "FrequencyBodyAccelerometerJerkStd-Z"             "FrequencyBodyGyroscopeStd-X"                    
# [83] "FrequencyBodyGyroscopeStd-Y"                     "FrequencyBodyGyroscopeStd-Z"                    
# [85] "FrequencyBodyAccelerometerMagnitudeStd"          "FrequencyBodyAccelerometerJerkMagnitudeStd"     
# [87] "FrequencyBodyGyroscopeMagnitudeStd"              "FrequencyBodyGyroscopeJerkMagnitudeStd"   
# 

"
Please submit a link to a Github repo with the code for performing your analysis. 
The code should have a file run_analysis.R in the main directory that can be run as 
long as the Samsung data is in your working directory. The output should be the 
tidy data set you submitted for part 1. You should include a README.md in the 
repo describing how the script works and the code book describing the variables.
"


## ------------------ SIDE NOTES --------------------------------------------------------
# REF: https://www.kaggle.com/questions-and-answers/40640
#

"
One important reason to combine sets is to maintain consistency between the sets. 
For example for categorical encoding, If all categories aren't present in both sets 
(and even if they are) they might be labelled differently if done in two separate operations. 
Or in unsupervised processing, like word2vec, you want to use an overall corpus of 
text, rather than two separate, smaller corpuses 
"

"
Here's another one to support Gareth's statement. 
PCA is another method that would require joint processing. I'm not sure if this is easily 
readable but I made this kernel recently to visually see the effectiveness of 
joint processing with PCA.
https://www.kaggle.com/pliptor/a-pca-playground
"

## --- THE END --------------------------------------------------------------------------
