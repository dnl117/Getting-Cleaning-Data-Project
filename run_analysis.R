library(dplyr)
library(reshape2)

# Read in the Data
xTest <- read.table("UCI HAR dataset/test/X_test.txt", header=FALSE)
xTrain <- read.table("UCI HAR dataset/train/X_train.txt", header=FALSE)
yTest <- read.table("UCI HAR dataset/test/y_test.txt", header=FALSE)
yTrain <- read.table("UCI HAR dataset/train/y_train.txt", header=FALSE)
subject_test <- read.table("UCI HAR dataset/test/subject_test.txt", header=FALSE)
subject_train <- read.table("UCI HAR dataset/train/subject_train.txt", header=FALSE)
features <- read.table("UCI HAR dataset/features.txt", header=FALSE)[,2]

#Combine and add labels to y
yData <- rbind(yTrain, yTest)
yData <- rename(yData, activity = V1)
yData$activity <- factor(yData$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

#Combine and and labels to x
xData <- rbind(xTrain, xTest)
names(xData) <- features

#Combine subject
subject <- rbind(subject_train, subject_test)
subject <- rename(subject, subjectID = V1)

#Combine data and select columns with mean or std
allData <- cbind(subject, yData, xData)
xData_subset <- grepl("mean\\(\\)|std\\(\\)", names(xData))
allData_subset <- allData[,xData_subset]

#Create another tidy dataset
allData_2 <- melt(allData_subset, id=c("subjectID","activity"))
tidyData <- dcast(allData_2, subjectID+activity ~ variable, mean)
View(tidyData)
write.csv(tidyData, "tidyData.txt", row.names = FALSE)
