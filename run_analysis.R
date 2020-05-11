## ---------------------------------------------------------------------------------------
## SUMMARY: 
##          Coursera: Johns Hopkins University: Data Science Specialization
##          Course #3 - Getting and Cleaning Data
##          Peer-graded Assignment: Getting and Cleaning Data Course Project
## REFS
##          https://www.coursera.org/learn/data-cleaning?specialization=jhu-data-science
##          (Background of the scope) 
##          https://www.itnews.com/article/2115126/big-data--activity-tracking--and-the-battle-for-the-world-s-top-sports-brand.html
##
## Author:  oseng, https://github.com/eng-r
## Contact: <public e-mail> 51923315+eng-r@users.noreply.github.com
## Date:    01-May ... 09, 10-May-2020 [Wrap up on 10-May-2020]
## Version: 0.2c
## --------------------------------------------------------------------------------------

rm(list = ls())

# if you miss any of the packages, run install.packages("<package name>") 
# at R-Studio console
library(stringr)
library(utils)
library(dplyr)
library("magrittr") # The principal function provided by the magrittr package is %>%

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

# ---------------------------------------------------------------------------------------
#
#                      *** SOME HELPER FUNCTIONS / API ***
#
# ---------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------
# RETURN DATAFRAME W/ MEAN/STD
# ---------------------------------------------------------------------------------------
select_ThisProblemScope <- function(dataFrame) {
  ind1 <- which(str_detect(tolower(colnames(dataFrame)), "mean") == TRUE)
  ind2 <- which(str_detect(tolower(colnames(dataFrame)), "std") == TRUE)

  # cat("Debug Index1/2: ", length(ind1), length(ind2), "\n")

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

# ---------------------------------------------------------------------------------------
# 1. Downloading and Unzipping
# ---------------------------------------------------------------------------------------
# let's download from the web source 
fileUrl <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
# Web file to the problem will be downloaded as this one
destFile <- "Data/ds3_w4pga1_1.zip"   
# this fiel I personally want to have to keep track of history 
infoFile <- "Data/ds3_w4pga1_1_info.txt"

# --- download only if there is no file yet on hard drive
if(!file.exists(destFile)) {
    # on Win platform we have to create a subfolder for the very first use
    # if it does not exist yet; if it does exist, no bad things will happen 
    dir.create(file.path("Data"), showWarnings = FALSE)  

    print("Downloading local copy of dataset ZIP. Wait...")  # takes time 
    download.file(fileUrl, destfile= destFile)  # same naming convention as .R

    # archive metadata
    # dateDownloaded etc - let's save for our own records
    dateDownloaded <- date()
    write.table(df<- data.frame(dateDownloaded, fileUrl, destFile), file = infoFile, sep= ", ")

    print("...created local copy of dataset ZIP")

} else {    # "else" must be on the same line as closing "}" from the "if"
    print("Using pre-downloaded local copy of dataset ZIP.")  
}

# list.files()

# (NOTE 1*) UCI HAR Dataset will be created at the level as .R script
if(!file.exists("UCI HAR Dataset")) {  # we know this name by looking into ZIP :-)
  print("Unzipping local copy of the dataset.")  # takes time to unZIP
  debug_1 <- unzip(destFile, files = NULL, list = FALSE, overwrite = TRUE, 
            junkpaths = FALSE, exdir = ".", 
            unzip = "internal", setTimes = FALSE)
} else {
    print("Using existing unZIPped local copy of the dataset.")  
}

# ---------------------------------------------------------------------------------------
# 2. Load datasets and files in support
# ---------------------------------------------------------------------------------------
# --- load supportive info --------------------------------------------------------------
features     <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors= FALSE)
# activities$V2 carries actual str-form names 
activities <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors= FALSE)  

trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
testSubject  <- read.table("UCI HAR Dataset/test/subject_test.txt")
# get rid of 'data frame' representation - we are going to insert it 
# as numerical values column
trainSubject <- as.numeric(unlist(trainSubject))
testSubject <- as.numeric(unlist(testSubject))

# --- load now MAJOR train and test datasets---------------------------------------------
print("Loading datasets...")
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")
testData <- read.table("UCI HAR Dataset/test/X_test.txt")
print("...complete")

# --- load train and test labels--------------------------------------------------------
trainLabel <- read.table("UCI HAR Dataset/train/y_train.txt")
testLabel  <- read.table("UCI HAR Dataset/test/y_test.txt")
trainLabel <- as.numeric(unlist(trainLabel))
testLabel <- as.numeric(unlist(testLabel))

# ---------------------------------------------------------------------------------------
# 3. Adding subject and activity labels
# ---------------------------------------------------------------------------------------
## Mutate data frames by adding  columns
trainData2 <- mutate(trainData, subject= trainSubject, label= trainLabel)    
testData2  <- mutate(testData, subject= testSubject, label= testLabel)    

# move the new columns to be the first ones
trainData2 <- select(trainData2, subject, label, everything())   
testData2  <- select(testData2, subject, label, everything()) 

# make proper ordering - first by subject then by label= activities 
testData2 <- arrange(testData2, subject, label)
trainData2 <- arrange(trainData2, subject, label)

# make meaningful column names and rename to fit the assignment 
colnames(trainData2) <- c("SubjectNum", "Activity", features$V2)   
colnames(testData2) <- c("SubjectNum", "Activity", features$V2)   

# ---------------------------------------------------------------------------------------
# 4. Merging 2 sets
# ---------------------------------------------------------------------------------------
mergedData <- rbind(trainData2, testData2)

# ---------------------------------------------------------------------------------------
# 5. Pull out mean/std as requested by the assignment problem
# ---------------------------------------------------------------------------------------
selectedData <- select_ThisProblemScope(mergedData)   # see routine for the details

s <- selectedData %>%
	group_by(SubjectNum, Activity) %>%
	summarise_each(funs(mean))

options(pillar.sigfig = 9)  # significant digits for print()
# print(s)

# ---------------------------------------------------------------------------------------
# 6. Make it all tidy!
# ---------------------------------------------------------------------------------------
# replace numeric values w/ char names for Activities 
# "V2" holds names of activities ...
s$Activity <- activities[match(s$Activity, activities$V1), "V2"]   

# make column names tidy as well, few actions here 
# duplicates to be gone 
names(s) <- gsub("BodyBody", "Body", x= names(s))
# shorer name is OK to me personally but to be on a nerd wave :-) let's make fun replacing to the longer names
names(s)<-gsub("Acc",  "Accelerometer", x= names(s))
names(s)<-gsub("Gyro", "Gyroscope",     x= names(s))
names(s)<-gsub("Mag",  "Magnitude",     x= names(s))
# all which starts w/ t or f - let's change to Time/Frequency
names(s) <- gsub("^t", "TimeDomain",      x= names(s))
# names(s)<-gsub("tBody", "TimeBody", names(s))
names(s) <- gsub("^f", "FrequencyDomain", x= names(s))

# all having () be replaced to more nice
names(s) <- gsub("-mean()", "Mean",       x= names(s)) # , ignore.case = TRUE)
names(s) <- gsub("-std()",  "Std",        x= names(s), ignore.case = T)
names(s) <- gsub("-freq()", "Frequency",  x= names(s), ignore.case = TRUE)
names(s) <- gsub("[()]", "", names(s)) #, ignore.case = TRUE)

# be consistent in upper/lower cases 
names(s) <- gsub("angle", "Angle",     names(s))  # 'x' can be omited 
names(s) <- gsub("gravity", "Gravity", names(s))

# for angles
names(s) <- gsub("tBody", "TimeDomainBody", names(s))


# ---------------------------------------------------------------------------------------
# 7. Dump it now to the file! - Finally!
# ---------------------------------------------------------------------------------------
write.table(s[, 1:dim(s)[2]], file = "tidy_data.txt", sep= " ", row.names= FALSE, quote= F)

## --- THE END --------------------------------------------------------------------------
