#load activities in a vector and set the names
activities <-read.csv("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep =" ")
names(activities) <- c("activityid","activity")

#load test data in a data table and set the names of activityid and subjectid 
xtest= read.table("./UCI HAR Dataset/test/X_test.txt")
ytest= read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest= read.table("./UCI HAR Dataset/test/subject_test.txt")
names(ytest) <- "activityid"
names(subjecttest) <- "subjectid"

#load trainings data in a data table and set the names of activityid and subjectid 
xtrain= read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain= read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain= read.table("./UCI HAR Dataset/train/subject_train.txt")
names(ytrain) <- "activityid"
names(subjecttrain) <- "subjectid"

#merge/bind test and trainings data
test<-cbind(subjecttest,ytest,xtest)
train<-cbind(subjecttrain,ytrain,xtrain)
dataset<- rbind(test,train)

#get the mean and std columns
features<-read.table("./UCI HAR Dataset/features.txt")
extractids <- grep("mean|std",features[,2])
extractdataset <- dataset[,c(1,2,extractids+2)]

#add an activity column
mergedData = merge(activities,extractdataset, by.x="activityid", by.y="activityid", all=TRUE)
variablenames <-gsub("()","",gsub("-","",features[extractids,2]),fixed = TRUE)

#set the names of mean and std columns
names(mergedData)[4:(length(variablenames)+3)] <-variablenames

#calculate the average of every column per activity aund subject
averagedataset <-aggregate(mergedData[,4:(length(variablenames)+3)], list(mergedData$activity,mergedData$subjectid), mean)
names(averagedataset)[1:2] <-c("activity","subjectid")

#write the data into a file
write.table(averagedataset, file = "averagedData.txt", row.names = FALSE)
