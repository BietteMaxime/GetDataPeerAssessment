## Setting up working directory
setwd("~")
if(!file.exists("~/R/Workspace/GetDataPeerAssessment"))
{
    setwd("~/R/Workspace")
    system(command="git clone git@github.com:BietteMaxime/GetDataPeerAssessment.git GetDataPeerAssessment")
}
setwd("~/R/Workspace/GetDataPeerAssessment/")

## Setting up data variables
dataDirPath <- "./data/"
datasetDirPath <- paste(dataDirPath, "UCI HAR Dataset/", sep="")
zipFilename <- "UCI HAR Dataset.zip"
zipPath <- paste(dataDirPath, zipFilename, sep="")
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Downloading/Unzipping data
if(!file.exists(dataDirPath)){ dir.create(dataDirPath) }
if(!file.exists(zipPath)){ download.file(zipUrl, zipPath, mode="wb", method="curl") }
if(!file.exists(datasetDirPath)) unzip(zipPath, exdir=dataDirPath)
print("Setup completed!")