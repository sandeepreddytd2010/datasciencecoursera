library(dplyr)
#Assign each data to Respective variables

features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merges the training and the test data sets to create single data set

X<- rbind(x_test,x_train)
Y<- rbind(y_test,y_train)
subject <- rbind(subject_test,subject_train)
Merged_Data <- cbind(subject, Y, X)

#Extracts only measurements on the mean and standard deviation for each measurement
TidyData_ms <- Merged_Data %>% select(subject,code,contains("mean"),contains("std"))

#Uses descriptive activity names to name the activities in the data set
TidyData_ms$code <- activities[TidyData_ms$code,2]

#Appropriately labels the data set with descriptive variable names
names(TidyData_ms) [2] <- "Activity"
names(TidyData_ms) <- gsub("BodyBody","Body",names(TidyData_ms))
names(TidyData_ms) <- gsub("angle","Angle",names(TidyData_ms))
names(TidyData_ms)<-gsub("^t", "time", names(TidyData_ms))
names(TidyData_ms)<-gsub("^f", "frequency", names(TidyData_ms))
names(TidyData_ms)<-gsub("Acc", "Accelerometer", names(TidyData_ms))
names(TidyData_ms)<-gsub("Gyro", "Gyroscope", names(TidyData_ms))
names(TidyData_ms)<-gsub("Mag", "Magnitude", names(TidyData_ms))

#independent tidy data set with the average of each variable for each activity and each subject
Final <- TidyData_ms %>% group_by(subject,Activity) %>% summarise_all(mean)

write.table(Final, "Tidy_Data.txt", row.name=FALSE)

