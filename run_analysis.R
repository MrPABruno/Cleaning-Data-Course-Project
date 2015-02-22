##Download and unzip data files
if(!file.exists("./data/cleaningproject")) {
        dir.create("./data/cleaningproject")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/cleaningproject/projectdata.zip")
unzip(zipfile = "./data/cleaningproject/projectdata.zip", exdir = "./data/cleaningproject")

##Read data files into tables
testDataPath <- "./data/cleaningproject/UCI HAR Dataset/test"
trainDataPath <- "./data/cleaningproject/UCI HAR Dataset/train"
subjectTest <- read.table(paste(testDataPath, "subject_test.txt", sep = "/"), header = FALSE)
subjectTrain <- read.table(paste(trainDataPath, "subject_train.txt", sep = "/"), header = FALSE)
featuresTest <- read.table(paste(testDataPath, "X_test.txt", sep = "/"), header = FALSE)
featuresTrain <- read.table(paste(trainDataPath, "X_train.txt", sep = "/"), header = FALSE)
activityTest <- read.table(paste(testDataPath, "y_test.txt", sep = "/"), header = FALSE)
activityTrain <- read.table(paste(trainDataPath, "y_train.txt", sep = "/"), header = FALSE)

##Merge data
dataSubject <- rbind(subjectTrain, subjectTest)
dataFeatures <- rbind(featuresTrain, featuresTest)
dataActivity <- rbind(activityTrain, activityTest)

names(dataSubject) <- "subject"
names(dataActivity) <- "activity"
featuresNames <- read.table("./data/cleaningproject/UCI HAR Dataset/features.txt", head = FALSE)
names(dataFeatures) <- featuresNames$V2

dataMerged <- cbind(dataSubject, dataActivity)
data <- cbind(dataFeatures, dataMerged)

##Extract only means and std
subsetFeaturesNames <- c(grep("mean()", featuresNames$V2), grep("std()", featuresNames$V2))
library(dplyr)
meanstdFeaturesNames <- featuresNames[subsetFeaturesNames, 2]
subsetFeaturesNames <- c(as.character(meanstdFeaturesNames), "subject", "activity" )
subsetData <- subset(data, select = subsetFeaturesNames)

#Use descriptive activity names
activityNames <- read.table("./data/cleaningproject/UCI HAR Dataset/activity_labels.txt", header = FALSE)
subsetData <- mutate(subsetData, activity_name = activityNames[activity, 2])

#Use descriptive variable names
names(subsetData) <- gsub("^t", "Time_", names(subsetData))
names(subsetData) <- gsub("^f", "Frequency_", names(subsetData))
names(subsetData) <- gsub("BodyBody", "Body_", names(subsetData))
names(subsetData) <- gsub("Acc", "Accelerometer_", names(subsetData))
names(subsetData) <- gsub("Jerk", "Jerk_", names(subsetData))
names(subsetData) <- gsub("Mag", "Magnitude_", names(subsetData))
names(subsetData) <- gsub("Gyro", "Gyroscope_", names(subsetData))
names(subsetData) <- gsub("-mean", "mean_", names(subsetData))
names(subsetData) <- gsub("-std", "std_", names(subsetData))

#Tidy data set
tidyData <- aggregate(. ~subject + activity_name, subsetData, mean)
tidyData <- arrange(tidyData, subject, activity_name)
write.table(tidyData, file = "tidydata.txt", row.names = FALSE)
