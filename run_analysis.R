library(dplyr)
library(gdata)
library(plyr)

## Read the data sets into R and assign them variables
Test_Subject <- read.table("./UCI Har Dataset/test/subject_test.txt")
Test_X <- read.table("./UCI Har Dataset/test/X_test.txt")
Test_Y <- read.table("./UCI Har Dataset/test/Y_test.txt")
Train_Subject <- read.table("./UCI Har Dataset/train/subject_train.txt")
Train_X <- read.table("./UCI Har Dataset/train/X_train.txt")
Train_Y <- read.table("./UCI Har Dataset/train/Y_train.txt")

## Merge the data sets into one data.frame in the variable Merged_All
Merged_Test <- cbind(Test_Subject, Test_Y, Test_X)
Merged_Train <- cbind(Train_Subject, Train_Y, Train_X)
Merged_All <- rbind(Merged_Train, Merged_Test)

## Assign column names to the dataset using the features.txt file
Features <- read.table("./UCI HAR Dataset/features.txt")
Feature_Names <- Features[,2]
Feature_Names <- as.character(Feature_Names)
colnames(Merged_All) <- c("Subject", "Activity", Feature_Names)

## Create new dataframe with only columns that represent mean and std
Mean_cols <- Merged_All[,grepl("mean\\(\\)", colnames(Merged_All))]
Std_cols <- Merged_All[,grepl("std\\(\\)", colnames(Merged_All))]
NewDataSet <- cbind(Merged_All[,1:2], Mean_cols, Std_cols)

## Replaces activity codes with activity names
Activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
Activity_labels <- tbl_df(Activity_labels)
colnames(Activity_labels) <- c("Activity", "Activity_Description")
DataSetWithActivityDescriptions <- merge(NewDataSet, Activity_labels, 
                                         by.x = "Activity", by.y = "Activity")
DataSet <- DataSetWithActivityDescriptions[,c(2,69, 3:68)]

## Group data by Subject/Activity Combination
DataSet2 <- DataSet %>% group_by(Subject, Activity_Description) %>% 
        summarise_each(funs(mean))