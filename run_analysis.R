############################################ SUMMARY ###########################################
##
## This script run the analysis required by the coursera course Getting and Cleaning Data.
## It assumes the data are downloaded and put in the 'data' folder in the working directory.
## If the data are not there it will download them and unzip them.
## A Helper function was created, the main analysis is after its definition.
##
## Usage: source('run_analysis.R')
## 
## Output: the file 'tidy.txt'
##
############################################ FUNCTIONS ###########################################

## MakeDataSetLoader, helper function that build the function to load dataset from the UCI HAR Dataset and that cache common data.
## Inputs: datasetDirPath and pathSeparator, strings to help building the path to load the files.
## Output: DataSetLoader, function to load datasets
MakeDataSetLoader <- function(datasetDirPath)
{
    ## Loading matching tables to label columns and activities correctly
  
    # Features name, correspond to each column of the dataset.
    featuresNamesFilePath <- file.path(datasetDirPath,'features.txt')
    featuresNames <- read.table(featuresNamesFilePath)
    names(featuresNames) <- c('featureid','featurename')
    
    # Activity labels, table associating an id with a human readable name.
    activityLabelsFilePath <- file.path(datasetDirPath, 'activity_labels.txt')
    activityLabels <- read.table(activityLabelsFilePath)
    names(activityLabels) <- c('activityid','activitylabel')

    
    ## DataSetLoader, load a specific dataset from the UCI HAR Dataset.
    ## Input: setname, the name of the set to load. 'train' or 'test'
    ## Output: dataSet, the dataset loaded from X_test.txt with the additional data provided to identify the features, activities and subjects.
    ## Free varaibles: datasetDirPath and pathSeparator, variables to help building the paths to load the files.
    DataSetLoader <- function(setname)
    {      
        ## Loading the subject ids matching each row of dataset
        subjectsFilePath <- file.path(datasetDirPath, setname, paste('subject_',setname,'.txt', sep=''))
        subjectsIds <- read.table(subjectsFilePath)
        
        ## Loading the activity ids matching each row of the dataset
        trainingActivityIdsFilePath <- file.path(datasetDirPath,setname,paste('y_',setname,'.txt', sep=''))
        trainingActivityIds <- read.table(trainingActivityIdsFilePath)
        
        ## Loading the main part of the dataset
        dataSetFilePath <- file.path(datasetDirPath, setname, paste('X_',setname,'.txt', sep=''))
        dataSet <- read.table(dataSetFilePath)
        
        ## Adding the columns with activities labels
        ## A factor is created to match the ids with their name.
        dataSet <- cbind(dataSet,factor(trainingActivityIds[[1]],levels=activityLabels$activityid,labels=activityLabels$activitylabel))
        
        ## Adding the subjects ids
        ## A factor is created in order to keep the logic of ids and not numbers.
        dataSet <- cbind(dataSet,factor(subjectsIds[[1]]))
        
        ## Naming correctly the columns with the features names and the additional columns
        names(dataSet) <- c(as.character(featuresNames$featurename),'activity','subject')
        
        dataSet
    }
    
    # Return the function loading the datasets
    DataSetLoader
}

############################################ ANALYSIS ###########################################

## Setting up data variables
dataDirPath <- "data"
datasetDirPath <- file.path(dataDirPath, "UCI HAR Dataset")
zipFilename <- "UCI HAR Dataset.zip"
zipPath <- file.path(dataDirPath, zipFilename)
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Downloading/Unzipping data
if(!file.exists(dataDirPath)){ dir.create(dataDirPath) }
if(!file.exists(zipPath)){ download.file(zipUrl, zipPath, mode="wb") }
if(!file.exists(datasetDirPath)) unzip(zipPath, exdir=dataDirPath)

## Instructions
#You should create one R script called run_analysis.R that does the following:
#

# 1. Merges the training and the test sets to create one data set.
DataSetLoader <- MakeDataSetLoader(datasetDirPath)
mergedDataSet <- rbind(DataSetLoader('train'),DataSetLoader('test'))

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
filteredDataSet <- mergedDataSet[grep('(mean\\(\\)|std\\(\\))|^(activity|subject)$',names(mergedDataSet),ignore.case=T)]

# 3. Uses descriptive activity names to name the activities in the data set.
#(Done in step 1)

# 4. Appropriately labels the data set with descriptive activity names.
#(Done in step 1)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
tidyDataSet<-dcast(melt(filteredDataSet,id=c("subject","activity")),subject+activity~variable,mean)
#tidyDataSet <- aggregate(filteredDataSet[-67:-68],by=list(subject=filteredDataSet$subject,activity=filteredDataSet$activity), mean)

# Saving the tidy dataset
write.table(tidyDataSet,file="tidy.txt")
