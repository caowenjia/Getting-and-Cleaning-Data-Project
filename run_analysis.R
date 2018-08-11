

 #0.Downlaod data from webstie and import all desired datasets
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"getdata_dataset.zip",method="curl")

var_name<-read.table("UCI HAR Dataset/features.txt")

activity_des<-data.table(read.table("UCI HAR Dataset/activity_labels.txt"))

test_x<-read.table("UCI HAR Dataset/test/X_test.txt")
test_y<-read.table("UCI HAR Dataset/test/Y_test.txt")
test_sub<-read.table("UCI HAR Dataset/test/subject_test.txt")

train_x<-read.table("UCI HAR Dataset/train/X_train.txt")
train_y<-read.table("UCI HAR Dataset/train/Y_train.txt")
train_sub<-read.table("UCI HAR Dataset/train/subject_train.txt")

#1.Merges the training and the test sets to create one data set.
 
test<-cbind(test_sub,test_y,test_x)
train<-cbind(train_sub,train_y,train_x)
all<-data.frame(rbind(test,train))
names(all)<-c("Subject","Activity_cd",c(var_name1))
min(all$Subject)
max(all$Subject)
#Dataset all combines test and train datasets


#2.Extracts only the measurements on the mean and standard deviation for each measurement.
var_name<-colnames(all)
des_var<-grep("mean()|std()", var_name)
all_stats<-all[,c(1,2,c(des_var))]
# all_stats contains only mersurements on mean and standard deviation


#3.Uses descriptive activity names to name the activities in the data set
##Merge the dataset with features_info.txt to get descriptive names for the data set generated in the previous step
install.packages('data.table')
library(data.table)
colnames(activity_des)<-c("Activity_cd","Activity_desc")
setkey(activity_des,Activity_cd)
all_stats<-data.table(all_stats)
#setnames(all_stats,old=c("V1"), new=c("Activity_cd"))
setkey(all_stats,Activity_cd)
all_stats1<-merge(activity_des,all_stats)
#In all_stats1, Activity_cd is the code(1-6), Activity_desc describles the activity 

#4.Appropriately labels the data set with descriptive variable names.
colnames(all_stats1)
#all_stats1 generated above has variable names that are descriptive that are easy for data users to udnerstand

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_sum<-aggregate(all_stats1[,4:82],list(all_stats1$Subject,all_stats1$Activity_cd,all_stats1$Activity_desc),mean)
max(data_sum$Group.1)
setnames(data_sum,old=c("Group.1","Group.2","Group.3"),new=c("Subject","Activity_cd","Activity_desc"))
data_sum[with(data_sum,order("Activity_cd")),]
tidy_data<-data_sum
#tidy_data summrized the mean of each varible on all_stats1 with descriptive lables and it is a tidy data set