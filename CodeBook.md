---
title: "Code Book: Human Activity Recognition Using Smartphones Data Set "
author: "V. Taralova"
output: html_document
---


# Source of the data

The data for the project is available at:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

A detailed description is available at the site where the data was obtained:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> 

There is also a paper available: is "Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013".

# Setup of the experiments

*Below we give the information contained in the provided README.txt file.*

The "Human Activity Recognition" database was built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 


# Description of the data

## For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

## The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.


# Transformations performed on the data

0. Setting the working directory
1. Downloading and unzipping the file with the data for the project
2. Preparation for loading the **train data set**
  - Reading the data from the "features.txt" file into the "features" data frame
  - Reading the data from the "subject_train.txt" file into the "indexPerson" data frame
  - Reading the data from the "y_train.txt" file into the "Activity" data frame
  - Reading the data from the "activity_labels.txt" file into the "ActivityNames" data frame
3. Reading the **train data set** from the "X_train.txt" file into the **"trainset"** data frame
  - The variables in the "trainset" data frame are assigned names taken from the "features" data frame
  - The variable "PersonID" is added to the "trainset" data frame
  - The variable "Activity" is added to the "trainset" data frame
  - The integer variable "Activity" is transformed into a factor variable, where the labels of the factor levels are taken from the "ActivityNames" data frame
4. Preparation for loading the **test data set**
  - Reading the data from the "subject_test.txt" file into the "indexPerson" data frame
  - Reading the data from the "y_test.txt" file into the "Activity" data frame
5. Reading the **test data set** from the "X_test.txt" file into the **"testset"** data frame
  - The variables in the "testset" data frame are assigned names taken from the "features" data frame
  - The variable "PersonID" is added to the "testset" data frame
  - The variable "Activity" is added to the "testset" data frame
  - The integer variable "Activity" is transformed into a factor variable, where the labels of the factor levels are taken from the "ActivityNames" data frame
6. Merging the train and test data sets with "rbind()"
7. Extracting the measurements only on the mean and standard deviation with the help of the "grep()" function 
8. Constructing the final tidy data frame with the "aggregate()" function 
9. Writing the final tidy data frame to a CSV file with the function "write.csv()" function

