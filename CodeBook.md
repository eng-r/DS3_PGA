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

## NOTES on Terminology
- Accelerometer sensor measures acceleration
- Gyroscope sensor measures angular velocity
- Body acceleration vs Gravity acceleration - see "Jorge-Luis Reyes-Ortiz book @ Google search"
    - In brief: gravitational and body motion components from the sensor acceleration signal were separated via Butterworth 
low-pass filter into body acceleration and gravity [page 294 of "Depp Learning with TenzorFlow" 2nd Edition, by G. Zaccone and Md. R. Karim - Packt> edition]
- Jerk is a derivation of the acceleration in time
- Magnitude of acceleration vs Acceleration [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6566970/]
    - Acceleration is defined as the time rate of change of velocity. Since velocity has both magnitude and direction, so does acceleration. In other words, 
acceleration is a vector. The length of the vector is its magnitude. Its direction is the direction of the vector 
    - So the magnitude of acceleration is the magnitude of the acceleration vector while the direction of the acceleration is the direction of the acceleration vector

### TIME DOMAIN
#### Time-Domain Averages (Means)
- Mean of body acceleration, X/Y/Z directions
   - TimeDomainBodyAccelerometerMeanX
   - TimeDomainBodyAccelerometerMeanY 
   - TimeDomainBodyAccelerometerMeanZ 

- Mean of gravity acceleration, X/Y/Z directions
   - TimeDomainGravityAccelerometerMeanX
   - TimeDomainGravityAccelerometerMeanY
   - TimeDomainGravityAccelerometerMeanZ

- Mean of body acceleration jerk, X/Y/Z directions
   - TimeDomainBodyAccelerometerJerkMeanX
   - TimeDomainBodyAccelerometerJerkMeanY
   - TimeDomainBodyAccelerometerJerkMeanZ

- Mean of body angular velocity, X/Y/Z directions
   - TimeDomainBodyGyroscopeMeanX
   - TimeDomainBodyGyroscopeMeanY
   - TimeDomainBodyGyroscopeMeanZ

- Mean of jerk of body angular velocity, X/Y/Z directions
   - TimeDomainBodyGyroscopeJerkMeanX
   - TimeDomainBodyGyroscopeJerkMeanY
   - TimeDomainBodyGyroscopeJerkMeanZ

- Mean of magnitude of body acceleration
   - TimeDomainBodyAccelerometerMagnitudeMean

- Mean of magnitude of gravity acceleration
   - TimeDomainGravityAccelerometerMagnitudeMean

- Mean of magnitude of jerk of body acceleration
   - TimeDomainBodyAccelerometerJerkMagnitudeMean

- Mean of magnitude of of body angular velocity
   - TimeDomainBodyGyroscopeMagnitudeMean

- Mean of magnitude of jerk of body body angular velocity
   - TimeDomainBodyGyroscopeJerkMagnitudeMean

#### Time-Domain Standard Deviations (STD)
Plase refer to the above "Average" chapter and substitute Std with Mean. Otherwise, it is a very similar channels description

   - TimeDomainBodyAccelerometerStdX 
   - TimeDomainBodyAccelerometerStdY 
   - TimeDomainBodyAccelerometerStdZ 
   - TimeDomainGravityAccelerometerStdX
   - TimeDomainGravityAccelerometerStdY
   - TimeDomainGravityAccelerometerStdZ
   - TimeDomainBodyAccelerometerJerkStdX
   - TimeDomainBodyAccelerometerJerkStdY
   - TimeDomainBodyAccelerometerJerkStdZ
   - TimeDomainBodyGyroscopeStdX
   - TimeDomainBodyGyroscopeStdY
   - TimeDomainBodyGyroscopeStdZ
   - TimeDomainBodyGyroscopeJerkStdX
   - TimeDomainBodyGyroscopeJerkStdY
   - TimeDomainBodyGyroscopeJerkStdZ
   - TimeDomainBodyAccelerometerMagnitudeStd
   - TimeDomainGravityAccelerometerMagnitudeStd
   - TimeDomainBodyAccelerometerJerkMagnitudeStd
   - TimeDomainBodyGyroscopeMagnitudeStd
   - TimeDomainBodyGyroscopeJerkMagnitudeStd

### FREQUENCY DOMAIN
Plase refer to the above "Time-Domain" chapters and substitute TimeDomain with FrequencyDomain. Otherwise, it is a very similar channels description

   - FrequencyDomainBodyAccelerometerMeanX
   - FrequencyDomainBodyAccelerometerMeanY
   - FrequencyDomainBodyAccelerometerMeanZ
   - FrequencyDomainBodyAccelerometerMeanFreqX
   - FrequencyDomainBodyAccelerometerMeanFreqY
   - FrequencyDomainBodyAccelerometerMeanFreqZ
   - FrequencyDomainBodyAccelerometerJerkMeanX
   - FrequencyDomainBodyAccelerometerJerkMeanY
   - FrequencyDomainBodyAccelerometerJerkMeanZ
   - FrequencyDomainBodyAccelerometerJerkMeanFreqX
   - FrequencyDomainBodyAccelerometerJerkMeanFreqY
   - FrequencyDomainBodyAccelerometerJerkMeanFreqZ
   - FrequencyDomainBodyGyroscopeMeanX
   - FrequencyDomainBodyGyroscopeMeanY 
   - FrequencyDomainBodyGyroscopeMeanZ 
   - FrequencyDomainBodyGyroscopeMeanFreqX
   - FrequencyDomainBodyGyroscopeMeanFreqY
   - FrequencyDomainBodyGyroscopeMeanFreqZ
   - FrequencyDomainBodyAccelerometerMagnitudeMean
   - FrequencyDomainBodyAccelerometerMagnitudeMeanFreq 
   - FrequencyDomainBodyAccelerometerJerkMagnitudeMean 
   - FrequencyDomainBodyAccelerometerJerkMagnitudeMeanFreq
   - FrequencyDomainBodyGyroscopeMagnitudeMean
   - FrequencyDomainBodyGyroscopeMagnitudeMeanFreq
   - FrequencyDomainBodyGyroscopeJerkMagnitudeMean
   - FrequencyDomainBodyGyroscopeJerkMagnitudeMeanFreq

   - FrequencyDomainBodyAccelerometerStdX
   - FrequencyDomainBodyAccelerometerStdY
   - FrequencyDomainBodyAccelerometerStdZ
   - FrequencyDomainBodyAccelerometerJerkStdX
   - FrequencyDomainBodyAccelerometerJerkStdY
   - FrequencyDomainBodyAccelerometerJerkStdZ
   - FrequencyDomainBodyGyroscopeStdX
   - FrequencyDomainBodyGyroscopeStdY
   - FrequencyDomainBodyGyroscopeStdZ
   - FrequencyDomainBodyAccelerometerMagnitudeStd
   - FrequencyDomainBodyAccelerometerJerkMagnitudeStd
   - FrequencyDomainBodyGyroscopeMagnitudeStd
   - FrequencyDomainBodyGyroscopeJerkMagnitudeStd

### ANGLES
 [REMOVED] from the final submission    - they are not 'mean/std' angles.

# Transformations/Pipelines
Gathering/processing of the orignal datasets plus the requires transformations are coded in run_analysis.R R-script

A link to the source data file is given in the run_analysis.R script. The script applies transformations listed below: 

- Download and unZIP if no copies exist on your workstation
- From unZipped folder, load major datasets AND supplementary files such as 'features' to help the workflow coding 
- Amend training and test datasets with Subject and Activity labels
- Merge training and test datasets --> a single data set is created 
- Pull out mean/std as requested by the assignment problem. [NOTE] - ignore angles
   - Create requested dataset with the average for each Variable grouped for each Activity and each Subject
- Make names tidy [descriptive and "good" names]
- Save results to the requested file

Please see README.md file for more details.

### SANITY CHECK
 - performed on 2020-05-14 01:30:38 CDT

# THE END
