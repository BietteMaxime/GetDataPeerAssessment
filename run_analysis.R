source("setup.R")

MakeDataSetLoader <- function(datasetDirPath)
{
    ## Loading matching tables to label columns and activities correctly
    featuresNamesFilePath <- paste(datasetDirPath,'features.txt', sep='')
    print("Loading features names")
    featuresNames <- read.table(featuresNamesFilePath)
    names(featuresNames) <- c('featureid','featurename')
    
    activityLabelsFilePath <- paste(datasetDirPath,'activity_labels.txt', sep='')
    print("Loading activity names")
    activityLabels <- read.table(activityLabelsFilePath)
    names(activityLabels) <- c('activityid','activitylabel')

    DataSetLoader <- function(setname)
    {
        subjectsFilePath <- paste(datasetDirPath,setname,'/subject_',setname,'.txt', sep='')
        print(paste("Loading",subjectsFilePath))
        subjects <- read.table(subjectsFilePath)
        
        
        trainingActivityIdsFilePath <- paste(datasetDirPath,setname,'/y_',setname,'.txt', sep='')
        print(paste("Loading",trainingActivityIdsFilePath))
        trainingActivityIds <- read.table(trainingActivityIdsFilePath)
        
        dataSetFilePath <- paste(datasetDirPath,setname,'/X_',setname,'.txt', sep='')
        print(paste("Loading",dataSetFilePath))
        dataSet <- read.table(dataSetFilePath)
        print("Binding activity labels column")
        dataSet <- cbind(dataSet,factor(trainingActivityIds[[1]],levels=activityLabels$activityid,labels=activityLabels$activitylabel))
        print("Naming columns")
        names(dataSet) <- c(as.character(featuresNames$featurename),'activitylabels')
        
        # Cleaning up
        #rm(trainingSetFilePath)
        #rm(featuresNames)
        #rm(featuresNamesFilePath)
        
        dataSet
    }
    
    DataSetLoader
}
## Instructions
#You should create one R script called run_analysis.R that does the following:
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## 1. Merging the two sets
#'train/X_train.txt': Training set.
#'test/X_test.txt': Test set.


#DataSetLoader <- MakeDataSetLoader(datasetDirPath)
#trainingSet <- DataSetLoader('train')
