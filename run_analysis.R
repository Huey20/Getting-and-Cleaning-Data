# 1. Merge the training and test set to create one dataset
## 1.1 Download the data 
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file.url,destfile="dataset.zip")

## 1.2 Unzip the data
unzip(zipfile = "dataset.zip", exdir = "data")

## 1.3 Explore the unzipped data
filepathtodata <- file.path("./data", "UCI HAR Dataset")
list.files(filepathtodata, recursive=TRUE)

## 1.4 Read the training data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

## 1.5 Read the test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

## 1.6 Read features 
features <- read.table("./data/UCI HAR Dataset/features.txt")

## 1.7 Read activity
activitylabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## 1.8 Combine data subject, data activity, data features
datasubject <- rbind(subject_test,subject_train)
dataactivity <- rbind(y_test,y_train)
datafeatures <- rbind(x_test,x_train)

## 1.9 Set column names
colnames(datasubject) <- c("subject")
colnames(dataactivity) <- c("activity")
colnames(datafeatures)<- features$V2

## 1.10 Combine the dataset (by columns)
combineddata<- cbind(datasubject,dataactivity)
data <- cbind(combineddata,datafeatures)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
data_mean_std <- data[,grepl("mean|std|subject|activity",names(data))]

# 3. Describe activity names to name the activities in the data set
## 3.1 Change the activity labels from uppercase to lowercase, and to remove underscore
activitylabels[,2] <- tolower(gsub("_"," ",activitylabels[,2]))

## 3.2 Name the columns of activity labels
colnames(activitylabels) = c("activityid","activitynames")

## 3.3 Merge the datasets and delete redundant column activity
data2 <- merge(data_mean_std,activitylabels, by.x = "activity", by.y="activityid", all=TRUE)
data3 <- data2[,-1]

# 4. Appropriately labels the data set with descriptive variable names
## 4.1 Replace t with time
names(data3) <- gsub("^t", "time", names(data3))

## 4.2 Replace Acc with accelerometer
names(data3) <- gsub("Acc","accelerometer",names(data3))

## 4.3 Replace Gyro with gyroscope
names(data3) <- gsub("Gyro","gyroscope",names(data3))

## 4.4 Replace f with frequency
names(data3) <- gsub("f","frequency",names(data3))

## 4.5 Replace Mag with magnitude
names(data3) <- gsub("Mag","magnitude", names(data3))

## 4.6 Replace bodybody with body
names(data3) <- gsub("BodyBody","body",names(data3))

## 4.7 Replace std with standard deviation
names(data3) <- gsub("std","standarddeviation",names(data3))

## 4.8 Replace Freq with frequency
names(data3) <- gsub("Freq","frequency", names(data3))

## 4.9 Replace Freq$ with frequency
names(data3) <- gsub("Freq$", "frequency", names(data3))

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
## 5.1 Split the data frame, apply mean function, and return result
tidydata = ddply(data3,c("subject","activitynames"),numcolwise(mean))

## 5.2 Write a text file
write.table(tidydata, file="tidydata.txt",row.name=FALSE)
