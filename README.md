# **DS3, Week 04, PGA**: Data Science - "Getting and Cleaning Data" by *Johns Hopkins University*. 

<!--- https://atom.io/packages/markdown-preview ---> 
<!--- Atom editor: Show the rendered HTML markdown to the right of the current editor using ctrl-shift-m ---> 


[Data Science - 3rd Course: "Getting and Cleaning Data" by Johns Hopkins University](https://www.coursera.org/learn/data-cleaning/ "Getting and Cleaning Data") [https://www.coursera.org/learn/data-cleaning/]

Peer-graded Assignment: Getting and Cleaning Data Course Project.
https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project

## Overview
One of exciting areas in data science today is wearable computing - see for example this article: [*Big data, activity tracking, and the battle for the world's top sports brand*](https://www.itnews.com/article/2115126/big-data--activity-tracking--and-the-battle-for-the-world-s-top-sports-brand.html) [link checked on 10-May-2020]. 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.

In this project, data collected from accelerometers and gyroscopes of the Samsung Galaxy S smartphone were retrieved, cleaned, 
and processed to prepare a requested "tidy" data usable for later analysis.

This repo has the following files:
- `README.md`, the file you're reading
	- data set overview + creation info
- `CodeBook.md`
	- "code book" - a file that describes the datasets content (such as data, variables and transformations throughout data generation)
- `run_analysis.R`
	- requested R script created to produce the output data set below 
- `tidy_data.txt`
	- requested file with dataset = assignment results

## Prehistory 
Original work used for this project is filed in open source space, the [Human Activity Recognition Using Smartphones Data Set]
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#).
The link tells how the data were collected:

* The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 
3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The experiments have been video-recorded to label the data manually. The obtained dataset has been 
randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
 
* The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise 
filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
The sensor acceleration signal, which has gravitational and body motion components, 
was separated using a Butterworth low-pass filter into body acceleration and gravity. 
The gravitational force is assumed to have only low frequency components, therefore a 
filter with 0.3 Hz cutoff frequency was used. From each window, a vector of 
features was obtained by calculating variables from the time and frequency domain.

# What's done during this exercise?
- Training and test data are merged together to create one data set
- The measurements on the mean and standard deviation are extracted 
- These extracted measurements are  averaged for each SUBJECT (aka 'human') and ACTIVITY
- Resultant data set is produced on hard drive as an ASCII file (I used CSV)

## In-Depth Journey

Assuming corresponfing libraries are installed [*check .R for comments on that*], 
anyone can use provided `run_analysis.R` R script [*the solution*] to create the requested data set. 
Note that `.R script` is rather self-explanatory - it has sounding naming/wording and comments.

The solution script retrieves the original ZIPped dataset from Web and makes series of data processing steps [aka *transformations*]
to obtain the requested final dataset. The steps described below are leading to the **tidy dataset** per the assignment 
requirement. As mentioned, please use **Code Book** for details on transformations/dataset names. 

- Check if files exist on workstation and download/unzip source Web data if needed 
- Pull-in [read] miscellaneous .TXT files to have training, test data and associated 'helper' activity, features, and subject info read as well 
- As requested, merge training and test datasets to obtain a single dataset
- Manipulate with column and row names to make them descriptive and understandable by a human - "label" dataset
- Extract only mean and standard deviation measurements as requested 
- Per exercise, create a second independent tidy dataset (must be with *each* variable average value for *each* subject AND *each* activity
- Write the manipulated dataset to the `tidy_data.txt` file as requested 

# Notes on reproducibility
- The `tidy_data.txt` in this repository was created by running the `run_analysis.R` script
- Used R version is version 3.6.3 (2020-02-29) [snapshot on **10-May-2020**]
- Platform: x86_64-w64-mingw32
- R-Studio @ Windows 10 machine: Version 1.2.5042
- Attached packages used during the R-Studio session [you need to insatll them if you don't have it]:
	- dplyr_0.8.5
	- magrittr_1.5
	- stringr_1.4.0
	- reshape2_1.4.4
	- data.table_1.12.8 

# THE END
