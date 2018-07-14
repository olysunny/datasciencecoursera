library(dplyr)
library(tidyr)

# download data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
              ,"project.zip")


# read data
unzip("project.zip")
setwd("/Users/a123/Desktop/R/Getting and Cleaning Data/UCI HAR Dataset")

test_y<-read.table("./test/y_test.txt")
test_x<-read.table("./test/X_test.txt")
test_sub<-read.table("./test/subject_test.txt")
train_y<-read.table("./train/y_train.txt")
train_x<-read.table("./train/X_train.txt")
train_sub<-read.table("./train/subject_train.txt")

## 1 Merges the training and the test sets to create one data set.
test<-cbind(test_y,test_sub,test_x)
train<-cbind(train_y,train_sub,train_x)
data<-rbind(train,test)

## 2 Extracts only the measurements on the mean and standard deviation for each measurement.
feature<-read.table("features.txt")
t1<-grep("mean",feature$V2)
t2<-grep("std",feature$V2)
data<-data[,c(1,2,t1+2,t2+2)]


## 3 Uses descriptive activity names to name the activities in the data set
des<-read.table("./activity_labels.txt")
data2<-merge(des,data,by="V1")


## 4 Appropriately labels the data set with descriptive variable names.
names(data2)<-c("act","act_des","sub",as.vector(feature[c(t1,t2),2]))
write.csv(data2,"q4.csv")

## 5 From the data set in step 4, creates a second, independent tidy data 
## set with the average of each variable for each activity and each subject.
data3<- data2 %>%
        mutate(act_sub=paste(act,"_",sub,sep="")) %>%
        select(c(-1,-2,-3)) %>%
        group_by(act_sub) %>%
        summarise_all(funs(mean))
write.csv(data3,"q5.csv")
write.table(data3,"q5.text",row.names = F)

