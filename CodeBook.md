# Code Book for **DS3, Week 04, PGA**: Data Science - "Getting and Cleaning Data" by *Johns Hopkins University*. 

<!--- https://atom.io/packages/markdown-preview ---> 
<!--- Atom editor: Show the rendered HTML markdown to the right of the current editor using ctrl-shift-m ---> 


[Data Science - 3rd Course: "Getting and Cleaning Data" by Johns Hopkins University](https://www.coursera.org/learn/data-cleaning/ "Getting and Cleaning Data").
Explicit link: https://www.coursera.org/learn/data-cleaning/

Peer-Graded Assignment [**PGA**]: Getting and Cleaning Data Course Project. 
Explicit link: https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project


# Summary
This code book describes tidy_data.txt file of this repo. Please refer to README.md file inside this repo for generic info of the assignment. 
The chapters herein are:
- Data: describes structure of the dataset 
- Variables: vars being used
- Data Processing aka "Transformations": steps to do to get dataset(s) directly from their origin

# Data
- Input:
	- ZIPped data at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
	- Please see README.md and the run_analysis.R for more details
- Output:
	- Requested "tidy_data.txt" file --> ASCII text file with values separated by spaces [I had a version w/ CSV as well :-)]
	- The very first row has variable names, please see "Variables" chapter below
	- The rest of rows keeps values [observations] of the variables in columns [features]
	- IMPORTANT: the first column is "SubjectNum" - an abstract person ID
	- IMPORTANT: the second column is "Activity" - I call it 'feature' or 'label'

# Variables
NOTE: to obtain names of variables in the output dataset [after you run `run_analysis.R`], you can type/run *names(s)* in R-Studio console. It will yield list of names discussed herein.

Each row contains 88-2= 86 averaged mean/std  measurements, for a given subject and activity.

## Identifiers 
- `SubjectNum` - subject ID, integer, ranges from 1 to 30
	- NOTE: 'subject' is a human :-)
- `Activity` - activity identifier, a string with one of 6 values: 
	- `WALKING`: subject walking
	- `WALKING_UPSTAIRS`: subject walking upstairs
	- `WALKING_DOWNSTAIRS`: subject walking downstairs
	- `SITTING`: subject sitting
	- `STANDING`: subject standing
	- `LAYING`: subject laying

## Measurements/Averages
What are `Averages` ? - All measurements are values in their double floating point representation, normalised within [-1, 1] range (aka per-unit-value). 
According to the original dataset source [please check README.md], before the normalization, accelerometer values were recorded in g's [say, 9.8 m/s/s] while 
gyro values were recorded in radians per second (rad/s). 3-D axes "magnitudes" were *calculated* through the **Euclidean** norm. 
All such measurements are classified within two important domains:
- Time-domain captures of raw signals from accelerometer and gyroscope sensors 
- Frequency-domain signals obtained after the FFT (Fast Fourier Transform) was performed over the time-domain signals [above]

Additional ANGLE variables are made up according to the following:
- Angles between two vectors; where additional vectors are obtained by averaging the signals in a signal window sample
- NOTE: removed from final submission as angles themselves ARE NOT mean/std

### TIME DOMAIN
 [3] "TimeDomainBodyAccelerometerMeanX"                      "TimeDomainBodyAccelerometerMeanY"                     
 [5] "TimeDomainBodyAccelerometerMeanZ"                      "TimeDomainGravityAccelerometerMeanX"                  
 [7] "TimeDomainGravityAccelerometerMeanY"                   "TimeDomainGravityAccelerometerMeanZ"                  
 [9] "TimeDomainBodyAccelerometerJerkMeanX"                  "TimeDomainBodyAccelerometerJerkMeanY"                 
[11] "TimeDomainBodyAccelerometerJerkMeanZ"                  "TimeDomainBodyGyroscopeMeanX"                         
[13] "TimeDomainBodyGyroscopeMeanY"                          "TimeDomainBodyGyroscopeMeanZ"                         
[15] "TimeDomainBodyGyroscopeJerkMeanX"                      "TimeDomainBodyGyroscopeJerkMeanY"                     
[17] "TimeDomainBodyGyroscopeJerkMeanZ"                      "TimeDomainBodyAccelerometerMagnitudeMean"             
[19] "TimeDomainGravityAccelerometerMagnitudeMean"           "TimeDomainBodyAccelerometerJerkMagnitudeMean"         
[21] "TimeDomainBodyGyroscopeMagnitudeMean"                  "TimeDomainBodyGyroscopeJerkMagnitudeMean"             

[49] "TimeDomainBodyAccelerometerStdX"                       "TimeDomainBodyAccelerometerStdY"                      
[51] "TimeDomainBodyAccelerometerStdZ"                       "TimeDomainGravityAccelerometerStdX"                   
[53] "TimeDomainGravityAccelerometerStdY"                    "TimeDomainGravityAccelerometerStdZ"                   
[55] "TimeDomainBodyAccelerometerJerkStdX"                   "TimeDomainBodyAccelerometerJerkStdY"                  
[57] "TimeDomainBodyAccelerometerJerkStdZ"                   "TimeDomainBodyGyroscopeStdX"                          
[59] "TimeDomainBodyGyroscopeStdY"                           "TimeDomainBodyGyroscopeStdZ"                          
[61] "TimeDomainBodyGyroscopeJerkStdX"                       "TimeDomainBodyGyroscopeJerkStdY"                      
[63] "TimeDomainBodyGyroscopeJerkStdZ"                       "TimeDomainBodyAccelerometerMagnitudeStd"              
[65] "TimeDomainGravityAccelerometerMagnitudeStd"            "TimeDomainBodyAccelerometerJerkMagnitudeStd"          
[67] "TimeDomainBodyGyroscopeMagnitudeStd"                   "TimeDomainBodyGyroscopeJerkMagnitudeStd"              

### FREQUENCY DOMAIN

[23] "FrequencyDomainBodyAccelerometerMeanX"                 "FrequencyDomainBodyAccelerometerMeanY"                
[25] "FrequencyDomainBodyAccelerometerMeanZ"                 "FrequencyDomainBodyAccelerometerMeanFreqX"            
[27] "FrequencyDomainBodyAccelerometerMeanFreqY"             "FrequencyDomainBodyAccelerometerMeanFreqZ"            
[29] "FrequencyDomainBodyAccelerometerJerkMeanX"             "FrequencyDomainBodyAccelerometerJerkMeanY"            
[31] "FrequencyDomainBodyAccelerometerJerkMeanZ"             "FrequencyDomainBodyAccelerometerJerkMeanFreqX"        
[33] "FrequencyDomainBodyAccelerometerJerkMeanFreqY"         "FrequencyDomainBodyAccelerometerJerkMeanFreqZ"        
[35] "FrequencyDomainBodyGyroscopeMeanX"                     "FrequencyDomainBodyGyroscopeMeanY"                    
[37] "FrequencyDomainBodyGyroscopeMeanZ"                     "FrequencyDomainBodyGyroscopeMeanFreqX"                
[39] "FrequencyDomainBodyGyroscopeMeanFreqY"                 "FrequencyDomainBodyGyroscopeMeanFreqZ"                
[41] "FrequencyDomainBodyAccelerometerMagnitudeMean"         "FrequencyDomainBodyAccelerometerMagnitudeMeanFreq"    
[43] "FrequencyDomainBodyAccelerometerJerkMagnitudeMean"     "FrequencyDomainBodyAccelerometerJerkMagnitudeMeanFreq"
[45] "FrequencyDomainBodyGyroscopeMagnitudeMean"             "FrequencyDomainBodyGyroscopeMagnitudeMeanFreq"        
[47] "FrequencyDomainBodyGyroscopeJerkMagnitudeMean"         "FrequencyDomainBodyGyroscopeJerkMagnitudeMeanFreq"    

[69] "FrequencyDomainBodyAccelerometerStdX"                  "FrequencyDomainBodyAccelerometerStdY"                 
[71] "FrequencyDomainBodyAccelerometerStdZ"                  "FrequencyDomainBodyAccelerometerJerkStdX"             
[73] "FrequencyDomainBodyAccelerometerJerkStdY"              "FrequencyDomainBodyAccelerometerJerkStdZ"             
[75] "FrequencyDomainBodyGyroscopeStdX"                      "FrequencyDomainBodyGyroscopeStdY"                     
[77] "FrequencyDomainBodyGyroscopeStdZ"                      "FrequencyDomainBodyAccelerometerMagnitudeStd"         
[79] "FrequencyDomainBodyAccelerometerJerkMagnitudeStd"      "FrequencyDomainBodyGyroscopeMagnitudeStd"             
[81] "FrequencyDomainBodyGyroscopeJerkMagnitudeStd"         


### ANGLES
 [REMOVED] from the final submission - they are not 'mean/std' angles.

# Transformations/Pipelines

# THE END
