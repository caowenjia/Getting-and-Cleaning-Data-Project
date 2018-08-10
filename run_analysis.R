

#0.Downlaod data from webstie
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"getdata_dataset.zip",method="curl")
#1.Merges the training and the test sets to create one data set.
test_x<-read.table("UCI HAR Dataset/test/X_test.txt")
test_y<-read.table("UCI HAR Dataset/test/Y_test.txt")
train_x<-read.table("UCI HAR Dataset/train/X_train.txt")
train_y<-read.table("UCI HAR Dataset/train/Y_train.txt")
test<-cbind(test_y,test_x)
train<-cbind(train_y,train_x)
all<-data.frame(rbind(test,train))
#Dataset all combines test and train dataset


#2.Extracts only the measurements on the mean and standard deviation for each measurement.
all_x<-data.frame(rbind(test_x,train_x))
var_name<-read.table("UCI HAR Dataset/features.txt")
var_name1<-var_name[,2]
var_name1<-as.character(var_name1)
colnames(all_x)<-c(var_name1)
#colnames(all)<-c("activtiy",var_name1)
##Look into feature data set to get varibles with mean or stdev
des_var<-grep("mean()|std()", var_name[,2])
#take desired varibles all dataset to get the desired dataset with only means and standardeviations
all_x_stats<-all_x[,c(des_var)]
all_stats<-cbind(rbind(test_y,train_y),all_x_stats)


#3.Uses descriptive activity names to name the activities in the data set
##Merge the dataset with features_info.txt to get descriptive names for the data set generated in the previous step
install.packages('data.table')
library(data.table)
activity_des<-data.table(read.table("UCI HAR Dataset/activity_labels.txt"))
colnames(activity_des)<-c("Activity_cd","Activity_desc")
setkey(activity_des,Activity_cd)
all_stats<-data.table(all_stats)
setnames(all_stats,old=c("V1"), new=c("Activity_cd"))
setkey(all_stats,Activity_cd)
all_stats1<-merge(activity_des,all_stats)
#In all_stats1, Activity_cd is the code(1-6), Activity_desc describles the activity 

#4.Appropriately labels the data set with descriptive variable names.
colnames(all_stats1)
#all_stats1 generated above has variable names that are descriptive that are easy for data users to udnerstand

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_sum<-aggregate(all_stats1[,3:81],list(all_stats1$Activity_cd,all_stats1$Activity_desc),mean)
#data_sum summrized the mean of each varible on all_stats1 with descriptive lables,
