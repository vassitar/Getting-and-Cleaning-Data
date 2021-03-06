---
title: "Getting and Cleaning Data: Human Activity Recognition Using Smartphones"
author: "Vasilena Taralova"
date: "January 29, 2017"
output: 
   html_document:
    toc: true 
    toc_float: true 
    toc_depth: 2
    depth: 3 
    number_sections: true
    theme: readable 
    highlight: tango 
---



# Introduction

## About the project

This project collects, works with, reshapes and cleans a data set. The goal of the project is to transform the original data into tidy data that can be used for later analysis. The considered data is the "Human Activity Recognition Using Smartphones Data Set" available at: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> 

The project includes all R code necessary to do the following:

 1. Download and unzip the file with the data for the project

 2. Read the train data set 
 
 3. Read the test data set
 
 4. Merge the train and test data sets 
 
 5. Extract the measurements only on the mean and standard deviation 
 
 6. Construct a final tidy data frame from the data frame in point 5, with the average of each variable for each activity and each subject 
 
 7. Write the final tidy data frame to a CSV file 
 
Below we give a detailed description of the transformations performed on the data:

0. Setting the working directory
1. Downloading and unzipping the file with the data for the project
2. Preparation for loading the **train data set**
* Reading the data from the "features.txt" file into the "features" data frame
* Reading the data from the "subject_train.txt" file into the "indexPerson" data frame
* Reading the data from the "y_train.txt" file into the "Activity" data frame
* Reading the data from the "activity_labels.txt" file into the "ActivityNames" data frame
3. Reading the **train data set** from the "X_train.txt" file into the **"trainset"** data frame
* The variables in the "trainset" data frame are assigned names taken from the "features" data frame
* The variable "PersonID" is added to the "trainset" data frame
* The variable "Activity" is added to the "trainset" data frame
* The integer variable "Activity" is transformed into a factor variable, where the labels of the factor levels are taken from the "ActivityNames" data frame
4. Preparation for loading the **test data set**
* Reading the data from the "subject_test.txt" file into the "indexPerson" data frame
* Reading the data from the "y_test.txt" file into the "Activity" data frame
5. Reading the **test data set** from the "X_test.txt" file into the **"testset"** data frame
* The variables in the "testset" data frame are assigned names taken from the "features" data frame
* The variable "PersonID" is added to the "testset" data frame
* The variable "Activity" is added to the "testset" data frame
* The integer variable "Activity" is transformed into a factor variable, where the labels of the factor levels are taken from the "ActivityNames" data frame
6. Merging the train and test data sets with "rbind()"
7. Extracting the measurements only on the mean and standard deviation with the help of the "grep()" function 
8. Constructing the final tidy data frame with the "aggregate()" function 
9. Writing the final tidy data frame to a CSV file with the function "write.csv()" function 
 
## Overview of the dataset

A detailed description is available at the site where the data was obtained:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> 

There is also a paper available: is "Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013".

### Setup of the experiments

*Below we give the information contained in the provided README.txt file.*

The "Human Activity Recognition" database was built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 


### Description of the data

For each record it is provided:

 - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
 
 - Triaxial Angular velocity from the gyroscope. 
 
 - A 561-feature vector with time and frequency domain variables. 
 
 - Its activity label. 
 
 - An identifier of the subject who carried out the experiment.

### Files included in the dataset archive 

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

### Notes 

 - Features are normalized and bounded within [-1,1].

 - Each feature vector is a row on the text file.



# Downloading and unzipping the file with the data for the project

First we set the working directory:


```r
setwd("D:/Coursera_Getting_and_CleaningData/Final_Project")
```

Then we download and unzip the archive:


```r
if(!file.exists("./Human_Activity.zip")){
  
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
    
    download.file(fileUrl, destfile = "./Human_Activity.zip")
    
}

unzip(zipfile = "./Human_Activity.zip", exdir = ".")
```


# Reading the train dataset

## Preparation

We read the file "features.txt" with the names of the measured features and we create a data frame called "features". This data frame contains the names of the variables in the train and test data sets as well as in the merged (train+test) data set:


```r
features <- read.table(file = "./UCI HAR Dataset/features.txt", 
                       sep = "", 
                       header = FALSE)
colnames(features) <- c("index", "name")
```


We read the file "subject_train.txt" and we create a data frame called "indexPerson". This data frame contains the identification numbers of each of the 30 participants in the experiment. The number of rows in the "indexPerson" data frame corresponds to the total number of observations in the train data set. This is due to the fact that each row in the train (and test) data set represents a series of measurements for given activity and given participant, and for each combination (participant, activity) there are multiple observations (i.e. measurements recorded) in the train (and test) data set:


```r
indexPerson <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt", 
                          sep = "", 
                          header = FALSE)
colnames(indexPerson) <- c("PersonID")
```

In the "Activity" data frame we store the data from the "y_train.txt" file. This file contains information about the type of activity the measurements in the train data set ("X_train.txt") were taken for. In other words, each observation (row) in the train (and test) data set corresponds to one of six activities: "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING" and "LAYING", which are coded with the numbers from 1 to 6.  Hence, the number of observations in the "Activity" data frame is equal to the number of observations in the  train data set.


```r
Activity <- read.table(file = "./UCI HAR Dataset/train/y_train.txt", 
                       sep = "", 
                       header = FALSE)
colnames(Activity) <- c("activityID")
```

Lastly, we create the data frame "ActivityNames" which contains the names (labels) of the considered activities together with their coding numbers, which are used in the files "y_train.txt" and "y_test.txt":


```r
ActivityNames <- read.table(file = "./UCI HAR Dataset/activity_labels.txt", 
                            sep = "", 
                            header = FALSE,
                            stringsAsFactors = FALSE)
colnames(ActivityNames) <- c("id", "activityName")
```


## Reading the train data


```r
trainset <- read.table(file = "./UCI HAR Dataset/train/X_train.txt", 
                       sep = "", 
                       header = FALSE)
```

We take the names of the variables for the "trainset" data frame from the "features" data frame. We do this to appropriately label the dataset with descriptive variable names:


```r
colnames(trainset) <- features$name

# Adding the PersonID column to the training data frame:
trainset$PersonID <- indexPerson$PersonID

# Adding the Activity column to the training data frame:
trainset$Activity <- Activity$activityID
```

We transform the "Activity" variable (from the "trainset" data frame) into factor and we label the factor levels with the activity names contained in the "ActivityNames" data frame:


```r
trainset$Activity <- factor(trainset$Activity, 
                            labels = ActivityNames$activityName)
```

The train dataset has 7352 rows (observations) and 563 columns (variables):


```r
dim(trainset)
```

```
## [1] 7352  563
```

# Reading the test dataset

## Preparation

The steps here are the same as in 3.1. We use the "features" and "ActivityNames" data frames unchanged, as we created them in 3.1, because they are the same both for the train and the test data set. We recycle the "indexPerson" and "Activity" data frames by reading the respective text files corresponding to the test data:


```r
indexPerson <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt", 
                          sep = "", 
                          header = FALSE)
colnames(indexPerson) <- c("PersonID")


Activity <- read.table(file = "./UCI HAR Dataset/test/y_test.txt", 
                       sep = "", 
                       header = FALSE)
colnames(Activity) <- c("activityID")
```


## Reading the test data


```r
testset <- read.table(file = "./UCI HAR Dataset/test/X_test.txt", 
                      sep = "", 
                      header = FALSE)

colnames(testset) <- features$name

# Adding the "PersonID" column to the test data set:
testset$PersonID <- indexPerson$PersonID

# Adding the "Activity" column to the test data set:
testset$Activity <- Activity$activityID

# Transforming the "Activity" variable into factor:
testset$Activity <- factor(testset$Activity, 
                           labels = ActivityNames$activityName)
```

The test dataset has 2947 rows (observations) and 563 columns (variables):


```r
dim(testset)
```

```
## [1] 2947  563
```


# Merging the train and the test datasets

We create the "human.activity" data frame, which is composed of the merged "trainset" and "testset" data frames:


```r
human.activity <- rbind(trainset, testset)
```

The "human.activity" data frame has the following dimensions:


```r
dim(human.activity)
```

```
## [1] 10299   563
```

# Extracting measurements only on the mean and standard deviation 

We will extract only the data on the mean and standard deviation for each measurement. However, except the obvious mean and standard deviation variables, such as:

1 tBodyAcc-mean()-X

2 tBodyAcc-mean()-Y

3 tBodyAcc-mean()-Z

4 tBodyAcc-std()-X

5 tBodyAcc-std()-Y

6 tBodyAcc-std()-Z,

there are also variables of the following type:

373 fBodyAccJerk-meanFreq()-X

374 fBodyAccJerk-meanFreq()-Y

375 fBodyAccJerk-meanFreq()-Z,

as well as the "angle" variables:

555 angle(tBodyAccMean,gravity)

556 angle(tBodyAccJerkMean),gravityMean)

557 angle(tBodyGyroMean,gravityMean)

558 angle(tBodyGyroJerkMean,gravityMean)

559 angle(X,gravityMean)

560 angle(Y,gravityMean)

561 angle(Z,gravityMean),

which also contain the word "mean" in their names. This makes the problem of extracting the measurements on the mean ambiguous. Therefore, we provide the R code for different extracting scenarios, but we choose one of them - *the third option*, in order to proceed further with the analysis. We use regular expressions to select only the measurements on the mean and standard deviation. Below we give the different options:

 - Option 1: Extracts all of the variables containing in their name the words "mean", "Mean" or "std":


```r
meanstd <- grep("[mM]ean|std", names(human.activity))
```

 - Option 2: Extracts all of the variables containing in their name the words "mean" or "std". The variables of the type "fBodyAccJerk-meanFreq()-Y" belong to this category:
 

```r
meanstd <- grep("mean|std", names(human.activity))
```

 - *Option 3*: Extracts all of the variables containing in their name the words "mean" or "std" and then excludes the variables of the type "fBodyAccJerk-meanFreq()-Y" (i.e. containing "meanFreq"):
 

```r
meanstd <- grep("mean|std", names(human.activity))
meanFreq <- grep("meanFreq", names(human.activity))
meanstd <- meanstd[!meanstd %in% meanFreq]
```

The variable "meanstd" is an integer vector containing the indices of the variables in the "human.activity" data frame which satisfy the condition in Option 3. 

Below we identify the indices of the variables "Activity" and "PersonID" which we also want to keep in the transformed "human.activity" data frame: 


```r
ind <- c(match("Activity", names(human.activity)), 
         match("PersonID", names(human.activity)))
```

Finally we extract only the measurements on the mean and standard deviation, together with the variables "Activity" and "PersonID":


```r
human.activity <- human.activity[ , c(meanstd, ind)]
```


# Constructing the final tidy data frame

Here we compute the mean of each variable in the updated "human.activity" data frame. Furthermore, the mean is computed for each unique combination of activity and participant. This means that for each combination (activity, participant) we subset only the observations (rows) of the "human.activity" data frame that correspond to this combination and then we calculate the average of each variable in the data frame (except for "Activity" and "PersonID").

In the updated data frame "human.activity" we identify again the indices of the variables "Activity" and "PersonID":


```r
ind <- c(match("Activity", names(human.activity)), 
         match("PersonID", names(human.activity)))
```

We construct the tidy data frame with the help of the "aggregate()" function. As stated in the R documentation, the function "splits the data into subsets, computes summary statistics for each, and returns the result in a convenient form". Since we do not want "aggregate()" to compute the mean of the variables "Activity" and "PersonID", we exclude these variables from the "human.activity" data frame: "x = human.activity[ ,-ind]". Then we pass to the "by" argument the list of grouping elements - "PersonID" and "Activity". Finally, we set the "FUN" argument to "mean", which tells R that we want to compute the mean for each numeric variable in the "human.activity[, -ind]" data frame. The value that the "aggregate()" function returns is stored in the variable "tidy.activity" which is "a data frame with columns corresponding to the grouping variables in "by", followed by aggregated columns from x" (as is stated in the R documentation):


```r
tidy.activity <- aggregate(x = human.activity[ ,-ind], 
                           by = list(personID = human.activity$PersonID,
                                     activity = human.activity$Activity),
                           FUN = mean, 
                           na.rm = TRUE)
```

After that we change the names of the columns containing the averaged measurements:


```r
NamesMean <- paste("Mean_", names(human.activity)[-ind], sep = "")
```

We identify the indices of the variables "activity" and "personID" in the "tidy.activity" data frame:


```r
indices <- c(match("activity", names(tidy.activity)), 
             match("personID", names(tidy.activity)))
```

and we name the variables in the "tidy.activity" data frame:


```r
colnames(tidy.activity)[-indices] <- NamesMean
```

Finally we transform the "activity" variable into a factor with levels labeled with the descriptive activity names:


```r
tidy.activity$activity <- factor(tidy.activity$activity, 
                                 labels = ActivityNames$activityName)
```

The final tidy dataset has 180 observations of 68 features:


```r
dim(tidy.activity)
```

```
## [1] 180  68
```

# Writing the final tidy data frame to a txt file


```r
write.table(tidy.activity, "tidy_human_activity.txt", row.name=FALSE)
```


