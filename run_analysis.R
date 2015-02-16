#set the location of the files

fileLoc<-file.path("./data","UCI HAR Dataset")
files<-list.files(fileLoc,recursive=TRUE)

#read the activity files (y_test.txt and y_train.txt)

ActivityTest<-read.table(file.path(fileLoc,"test","y_test.txt"),header=FALSE)
ActivityTrain<-read.table(file.path(fileLoc,"train","y_train.txt"),header=FALSE)

#read the Subject files (subject_train.txt and subject_test.txt)

SubjectTest<-read.table(file.path(fileLoc,"test", "subject_test.txt"),header=FALSE)
SubjectTrain<-read.table(file.path(fileLoc,"train","subject_train.txt"),header=FALSE)

#read the Features files (features.txt for the names)
#(X_test.txt and X_train.txt for the values)
FeaturesNames<-read.table(file.path(fileLoc,"features.txt"),header=FALSE)
FeaturesTest<-read.table(file.path(fileLoc,"test","X_test.txt"),header=FALSE)
FeaturesTrain<-read.table(file.path(fileLoc,"train","X_train.txt"),header=FALSE)

#Project Task 
#1 Mergest the training and the test sets to create one data set

Subject<-rbind(SubjectTrain,SubjectTest)
Activity<-rbind(ActivityTrain,ActivityTest)
Features<-rbind(FeaturesTrain,FeaturesTest)

#set names to variables for readability
names(Subject)<-c("Subject")
names(Activity)<-c("Activity")
names(Features)<-FeaturesNames$V2

#merge columns to get the data frame "Data" for all data

Alldata<-cbind(Subject,Activity)
Data<-cbind(Features,Alldata)

#################################################

#Project Task
#2 Extracts only the measurements on the mean and standard deviation for each
#measurement.

subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)",FeaturesNames$V2)]
VariableNames<-c(as.character(subFeaturesNames),"Subject","Activity")
Data<-subset(Data,select=VariableNames)

################################################

#Project Task
#3 Uses descriptive activity names to name the activities in the data set.

activityLabels<-read.table(file.path(fileLoc,"activity_labels.txt"),header=FALSE)
Data[,68]<-activityLabels[Data[,68],2]


################################################

#Project Task
#4 Appropriately labels the data set with descriptive variable names.
# this will make it easier to read data

names(Data)<-gsub("^t","time",names(Data))
names(Data)<-gsub("^f","frequency",names(Data))
names(Data)<-gsub("Acc","Accelerometer",names(Data))
names(Data)<-gsub("Gyro","Gyroscope",names(Data))
names(Data)<-gsub("Mag","Magnitude",names(Data))
names(Data)<-gsub("BodyBody","Body",names(Data))

################################################

#Project Task
#5 From the data set in step4, create a second, independent tidy data set with the average
# of each variable for each activity and each subject.

library(plyr)
Data2<-aggregate(.~Subject + Activity, Data, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2,file="tidydataProject2015.txt",row.name=FALSE)




