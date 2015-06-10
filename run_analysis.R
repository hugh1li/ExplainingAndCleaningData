#download files
if(!file.exists("./data")){dir.create("./data")}
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/D.zip",method="curl")
unzip('D.zip')

#load data into R and merge test set and training set into one var.
setwd('/Users/hugh/Desktop/getting and cleaning data/data/UCI HAR Dataset/test')
test.x<-read.table("X_test.txt") # read X_test.txt
test.y<-read.table("y_test.txt",col.names ='y')  #read file y_test.txt
test.s<-read.table("subject_test.txt",col.names='s')  #read file subject_test.txt
test<-cbind(test.x,test.y,test.s)  #combine them into one
setwd('/Users/hugh/Desktop/getting and cleaning data/data/UCI HAR Dataset/train')
train.x<-read.table('X_train.txt')  # read three training set
train.y<-read.table("y_train.txt",col.names='y')
train.s<-read.table('subject_train.txt',col.names='s')
train<-cbind(train.x,train.y,train.s)
Total<-merge(x = test,y=train,all = TRUE) #merge test and training set

# lable activities
setwd('/Users/hugh/Desktop/getting and cleaning data/data/UCI HAR Dataset')
activity<-read.table("activity_labels.txt")  # read activity label
Total$y[Total$y==1]<-'WALKING'            # change y value to corrsponding character label
Total$y[Total$y==2]<-'WALKING_UPSTAIRS'
Total$y[Total$y==3]<-'WALKING_DOWNSTAIRS'
Total$y[Total$y==4]<-'SITTING'
Total$y[Total$y==5]<-'STANDING'
Total$y[Total$y==6]<-'LAYING'

#extract mean and std features, mean(), std()
f<-read.table('features.txt')      #read the feature names
x<-grep("mean()|std()",f$V2)       # search the required features with mean and std symbol
x1<-grep('meanFreq()',f$V2)
x2<-x[!x %in% x1]                  # throw away the meanFreq() var.
Extract<-Total[,x2]                # extract these required features
colnames(Extract)<-f$V2[x2]         #assign names to these features in new dataset

#File you get at step 4
F<-cbind(Extract,Total[,562:563])

#step 5 file
#ave of each var. for each activity and each subject
str(F)
Final<-aggregate(F[,1:66],by=list(F$s,F$y),mean)  # average by group
write.table(Final,'Refined Data.txt',row.names=FALSE)





