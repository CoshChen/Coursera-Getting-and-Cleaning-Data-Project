features <- read.table('./UCI HAR Dataset/features.txt',header=FALSE)
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE) #6 obs. of  2 variables

# load train data
subjectTrain <- read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE)
XTrain <- read.table('./UCI HAR Dataset/train/X_train.txt',header=FALSE)
yTrain <- read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE)

# load test data
subjectTest <- read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE)
XTest <- read.table('./UCI HAR Dataset/test/X_test.txt',header=FALSE)
yTest <- read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE)

# Merge the training and the test sets
subjectSet <- rbind(subjectTrain, subjectTest)
featureSet <- rbind(XTrain, XTest)
activitySet <- rbind(yTrain, yTest)

names(subjectSet)<-c("subject")
names(activitySet)<- c("activity")
names(featureSet)<- features$V2

finalSet <- cbind(subjectSet, activitySet, featureSet)

# Extract only the measurements on the mean and standard deviation
subFeatures <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
subFinalSet <- subset(finalSet,select=c("subject", "activity", as.character(subFeatures)))

# Use descriptive activity names to name the activities in the data set
subFinalSet$activity <- factor(subFinalSet$activity, levels = activityLabels[,1], labels = activityLabels[,2])

# Label the data set with descriptive variable names.
names(subFinalSet)<-gsub("^t", "time", names(subFinalSet))
names(subFinalSet)<-gsub("^f", "frequency", names(subFinalSet))
names(subFinalSet)<-gsub("Acc", "Accelerometer", names(subFinalSet))
names(subFinalSet)<-gsub("Gyro", "Gyroscope", names(subFinalSet))
names(subFinalSet)<-gsub("Mag", "Magnitude", names(subFinalSet))
names(subFinalSet)<-gsub("BodyBody", "Body", names(subFinalSet))

# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject.
averageSet<- aggregate(. ~subject + activity, subFinalSet, mean)
averageSet<- averageSet[order(averageSet$subject,averageSet$activity),]
write.table(averageSet, file = "averageSet.txt",row.name=FALSE)