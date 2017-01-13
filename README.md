---
title: "Getting and Cleaning Data: Course Project"
author: "V. Taralova"
output: html_document
---

# Description

This repository contains a project that collects, works with, reshapes and cleans a data set. The goal of the project is to transform the original data into tidy data that can be used for later analysis. The considered data is the "Human Activity Recognition Using Smartphones Data Set" available at: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> 
 
# Contents of the repository

The repository contains one script named "run_analysis.R" and a "CodeBook.md"
file. The "CodeBook.md" file contains information about the variables, the data, and any transformations performed to clean up the data. The R script  includes all code necessary to do the following:

1. Download and unzip the file with the data for the project
2. Read the train data set 
3. Read the test data set
4. Merge the train and test data sets 
5. Extract the measurements only on the mean and standard deviation 
6. Construct a final tidy data frame from the data frame in point 5, with the average of each variable for each activity and each subject 
7. Write the final tidy data frame to a txt file 

More details are available in the "CodeBook.md" file.
