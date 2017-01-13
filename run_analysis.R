#--------------------------------------
# 0. Setting the working directory:
#--------------------------------------

setwd("D:/Coursera_Getting_and_CleaningData/Final_Project")

#-------------------------------------------------------------------------
# 1. Downloading and unzipping the file with the data for the project:
#-------------------------------------------------------------------------

if(!file.exists("./Human_Activity.zip")){
  
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
    
    download.file(fileUrl, destfile = "./Human_Activity.zip")
    
}

unzip(zipfile = "./Human_Activity.zip", exdir = ".")


#----------------------------------
# 2. Reading the train data set
#----------------------------------
# 2.1 Preparation:
#----------------------------------

# We read the file "features.txt" with the names of the measured features
# and we create a data frame called "features". This data frame contains 
# the names of the variables in the train and test data sets as well as
# in the merged (train+test) data set.
features <- read.table(file = "./UCI HAR Dataset/features.txt", 
                       sep = "", 
                       header = FALSE)
colnames(features) <- c("index", "name")


# We read the file "subject_train.txt" and we create a data frame called
# "indexPerson". This data frame contains the identification numbers of 
# each of the 30 participants in the experiment. The number of rows in 
# the "indexPerson" data frame corresponds to the total number of observations
# in the train data set. This is due to the fact that each row in the train
# (and test) data set represents a series of measurements for given activity
# and given participant, and for each combination (participant, activity)
# there are multiple observations (i.e. measurements recorded) in the train 
# (and test) data set. 
indexPerson <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt", 
                          sep = "", 
                          header = FALSE)
colnames(indexPerson) <- c("PersonID")

# In the following data frame we store the data from the "y_train.txt" file.
# This file contains information about the type of activity the measurements
# in the train data set ("X_train.txt") were taken for. In other words, each
# observation/row in the train (and test) data set corresponds to one of 
# six activities: "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
# "SITTING", "STANDING" and "LAYING", which are coded with the numbers from
# 1 to 6.  Hence, the number of observations in the "Activity" data frame is 
# equal to the number of observations in the  train data set. 
Activity <- read.table(file = "./UCI HAR Dataset/train/y_train.txt", 
                       sep = "", 
                       header = FALSE)
colnames(Activity) <- c("activityID")


# Lastly, we create the data frame "ActivityNames" which contains the 
# names (labels) of the considered activities together with their coding 
# numbers, which are used in the files "y_train.txt" and "y_test.txt".
ActivityNames <- read.table(file = "./UCI HAR Dataset/activity_labels.txt", 
                            sep = "", 
                            header = FALSE,
                            stringsAsFactors = FALSE)
colnames(ActivityNames) <- c("id", "activityName")


#-------------------------------
# 2.2 Reading the train data:
#-------------------------------

trainset <- read.table(file = "./UCI HAR Dataset/train/X_train.txt", 
                       sep = "", 
                       header = FALSE)

# We take the names of the variables for the "trainset" data frame from
# the "features" data frame. This covers point 3 from the project requirements,
# which states that we must appropriately label the data set with 
# descriptive variable names.
colnames(trainset) <- features$name

# Adding the PersonID column to the training data frame:
trainset$PersonID <- indexPerson$PersonID

# Adding the Activity column to the training data frame:
trainset$Activity <- Activity$activityID

# Turning the Activity variable into factor: 
# In order to do this, we label the factor levels with the activity names 
# contained in the "ActivityNames" data frame. This way we use 
# "descriptive activity names to name the activities in the data set" 
# as is stated in the project requirements (point 4).
trainset$Activity <- factor(trainset$Activity, 
                            labels = ActivityNames$activityName)




#-----------------------------------
# 3. Reading the test data set
#-----------------------------------
# 3.1 Preparation:
#-----------------------------------

# The steps here are the same as in 2.1.
# We use the "features" and "ActivityNames" data frames unchanged, 
# as we created them in 2.1, because they are the same both for the train
# and the test data set. We recycle the "indexPerson" and "Activity"
# data frames by reading the respective text files corresponding to
# the test data.

indexPerson <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt", 
                          sep = "", 
                          header = FALSE)
colnames(indexPerson) <- c("PersonID")


Activity <- read.table(file = "./UCI HAR Dataset/test/y_test.txt", 
                       sep = "", 
                       header = FALSE)
colnames(Activity) <- c("activityID")


#-------------------------------
# 3.2 Reading the test data:
#-------------------------------

testset <- read.table(file = "./UCI HAR Dataset/test/X_test.txt", 
                      sep = "", 
                      header = FALSE)

colnames(testset) <- features$name

# Adding the PersonID column to the test data set:
testset$PersonID <- indexPerson$PersonID

# Adding the Activity column to the test data set:
testset$Activity <- Activity$activityID

# Turning the Activity variable into factor:
testset$Activity <- factor(testset$Activity, 
                           labels = ActivityNames$activityName)




#----------------------------------
# 4. Merging the two data sets
#----------------------------------


# We create the "human.activity" data frame, which is composed of the 
# merged "trainset" and "testset" data frames.
human.activity <- rbind(trainset, testset)


#--------------------------------------------------------------------------
# 5. Extracting the measurements only on the mean and standard deviation 
#--------------------------------------------------------------------------

# In the project assignment it is stated that we should extract
# "only the measurements on the mean and standard deviation for 
# each measurement". However, except the obvious mean and standard  
# deviation variables, such as:
# 1 tBodyAcc-mean()-X
# 2 tBodyAcc-mean()-Y
# 3 tBodyAcc-mean()-Z
# 4 tBodyAcc-std()-X
# 5 tBodyAcc-std()-Y
# 6 tBodyAcc-std()-Z,

# there are also variables of the following type:

# 373 fBodyAccJerk-meanFreq()-X
# 374 fBodyAccJerk-meanFreq()-Y
# 375 fBodyAccJerk-meanFreq()-Z,

# as well as the "angle" variables:

# 555 angle(tBodyAccMean,gravity)
# 556 angle(tBodyAccJerkMean),gravityMean)
# 557 angle(tBodyGyroMean,gravityMean)
# 558 angle(tBodyGyroJerkMean,gravityMean)
# 559 angle(X,gravityMean)
# 560 angle(Y,gravityMean)
# 561 angle(Z,gravityMean),

# which also contain the word "mean" in their names. 
# This makes the problem of extracting the measurements 
# on the mean ambiguous. Therefore, we provide the R code for 
# different extracting scenarios, but we choose one of them in 
# order to proceed further with the analysis. 
# We use regular expressions to select only the measurements 
# on the mean and standard deviation. 

# Below are given the different options:

# Option 1: Extracts all of the variables containing in their name 
# the words "mean", "Mean" or "std":
# meanstd <- grep("[mM]ean|std", names(human.activity))

# Option 2: Extracts all of the variables containing in their name 
# the words "mean" or "std". The variables of the type 
# "fBodyAccJerk-meanFreq()-Y" belong to this category:
# meanstd <- grep("mean|std", names(human.activity))

# Option 3: Extracts all of the variables containing in their name 
# the words "mean" or "std" and then excludes the variables of the type 
# "fBodyAccJerk-meanFreq()-Y" (i.e. containing "meanFreq"):
meanstd <- grep("mean|std", names(human.activity))
meanFreq <- grep("meanFreq", names(human.activity))
meanstd <- meanstd[!meanstd %in% meanFreq]

# The variable "meanstd" is an integer vector containing the indices
# of the variables/columns in the "human.activity" data frame, which
# satisfy the condition in Option 3. 

# Below we identify the indices of the variables "Activity" and "PersonID",
# which we also want to keep in the transformed "human.activity" data frame: 
ind <- c(match("Activity", names(human.activity)), 
         match("PersonID", names(human.activity)))

# Extracting only the measurements on the mean and standard deviation, 
# together with the variables "Activity" and "PersonID":
human.activity <- human.activity[ , c(meanstd, ind)]


#------------------------------------------------
# 6. Constructing the final tidy data frame
#------------------------------------------------

# Here we compute the mean of each variable in the updated "human.activity"
# data frame. Furthermore, the mean is computed for each unique combination  
# of activity and participant. This means that for each combination  
# (activity, participant) we subset only the rows/observations of the 
# "human.activity" data frame that correspond to this combination and then
# we calculate the average of each variable (except for "Activity" and 
# "PersonID") in the data frame.

# In the updated data frame "human.activity" we identify again 
# the indices of the variables "Activity" and "PersonID":
ind <- c(match("Activity", names(human.activity)), 
         match("PersonID", names(human.activity)))



# We construct the tidy data frame with the help of the "aggregate()"
# function. As stated in the R documentation, the function 
# "splits the data into subsets, computes summary statistics for each, 
# and returns the result in a convenient form". 
# Since we do not want "aggregate()" to compute the mean of the 
# variables "Activity" and "PersonID", we exclude these variables
# from the "human.activity" data frame: "x = human.activity[ ,-ind]".
# Then we pass to the "by" argument the list of grouping elements -
# "PersonID" and "Activity". Finally, we set the "FUN" argument to "mean",
# which tells R that we want to cimpute the mean for each numeric variable
# in the "human.activity[, -ind]" data frame. The value  
# that the "aggregate()" function returns is stored in the variable 
# "tidy.activity" which is "a data frame with columns corresponding
# to the grouping variables in "by" followed by aggregated columns from x".
tidy.activity <- aggregate(x = human.activity[ ,-ind], 
                           by = list(personID = human.activity$PersonID,
                                     activity = human.activity$Activity),
                           FUN = mean, 
                           na.rm = TRUE)


# Changing the names of the columns containing the averaged measurements:
NamesMean <- paste("Mean_", names(human.activity)[-ind], sep = "")

# We identify the indices of the variables "activity" and "personID"
# in the "tidy.activity" data frame:
indices <- c(match("activity", names(tidy.activity)), 
             match("personID", names(tidy.activity)))


# Naming the variables in the "tidy.activity" data frame:
colnames(tidy.activity)[-indices] <- NamesMean

# Transforming the "activity" variable into a factor with levels
# labeled with the descriptive activity names:
tidy.activity$activity <- factor(tidy.activity$activity, 
                                 labels = ActivityNames$activityName)



#------------------------------------------------------
# 7. Writing the final tidy data frame to a txt file
#------------------------------------------------------

write.table(tidy.activity, "tidy_human_activity.txt", row.name=FALSE)

