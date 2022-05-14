###############################################################################
# Title               : Getting and Clearning Data Course Project - R Programming 
# Data source         : Course Instructor - Roger D. Peng
# Project Start Date  : May 7, 2022
# Project End Date    : May 7, 2022
# Compiled by         : Trokon Omarley Yeabah
###############################################################################

# install the appropriate packages 
install.packages("dplyr")
install.packages("plyr")
install.packages("knitr")

# load the packages 
library(dplyr)
library(plyr)
library(knitr)

# locate the storage directory and download the dataset
# a. default pathway
setwd ("C:/Users/tyeabah/Documents/Coursera")

# b. create directory, get dataset and unzip
dir.create("myproject")

filelinked <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(filelinked, destfile = "./myproject/accelerometers.zip")
unzip(zipfile = "./myproject/accelerometers.zip", exdir = "./myproject")

# c. get file pathway
file.path("./myproject", "UCI HAR Dataset")
setwd ("C:/Users/tyeabah/Documents/Coursera/myproject")

# d. read in the data
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

# merges the training and the test sets to create one data set
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merge_data <- cbind(subject, y, x)

# extracts only the measurements on the mean and standard deviation for each measurement
tidydata <- merge_data %>%
  select(subject, code, contains("mean"), contains ("std"))

# uses descriptive activity names to name the activities in the data set
tidydata$code <- activities[tidydata$code, 2]

# appropriately labels the data set with descriptive variable names
names(tidydata)[2] = "activity"
names(tidydata) <- gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata) <- gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata) <- gsub("BodyBody", "Body", names(tidydata))
names(tidydata) <- gsub("Mag", "Magnitude", names(tidydata))
names(tidydata) <- gsub("^t", "Time", names(tidydata))
names(tidydata) <- gsub("^f", "Frequency", names(tidydata))
names(tidydata) <- gsub("tBody", "TimeBody", names(tidydata))
names(tidydata) <- gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata) <- gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata) <- gsub("-freq", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata) <- gsub("angle", "Angle", names(tidydata))
names(tidydata) <- gsub("gravity", "Gravity", names(tidydata))

# creates a second, independent tidy data set with the average of each variable, activity and subject
completedata <- tidydata %>%
  group_by(subject, activity)%>%
  summarize_all(funs(mean))

write.table(completedata, "completedata.txt", row.names = FALSE)

#END OF SCRIPT