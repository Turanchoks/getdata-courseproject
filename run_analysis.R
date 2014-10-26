unzip('getdata-projectfiles-UCI HAR Dataset.zip')
library(plyr)

## Reading features table
features <- read.table('UCI HAR Dataset/features.txt', 
                       colClasses = c('integer', 'character'), 
                       col.names = c('feature_id', 'feature'))

## Generating integer vector with ids of columns containing std/mean measurements
features_mean_std <- grep('mean|std', features$feature);

## Reading activities table
activities <- read.table('UCI HAR Dataset/activity_labels.txt', 
                         colClasses = c('integer', 'character'), 
                         col.names = c('activity_id', 'activity'))


## Reading training set, attaching varibale names and extracting only mean/std columns
train_set <- read.table('UCI HAR Dataset/train/X_train.txt', 
                    header = FALSE,
                    row.names = NULL,
                    col.names = features[[2]])[, features_mean_std]
## Attaching activities and subjects
train_set$activity <- join(read.table('UCI HAR Dataset/train/y_train.txt', col.names = c('activity_id')), activities)[[2]]
train_set$subject <- read.table('UCI HAR Dataset/train/subject_train.txt')[[1]]

## Reading test set, attaching varibale names and extracting only mean/std columns?
test_set <- read.table('UCI HAR Dataset/test/X_test.txt', 
                   header = FALSE,
                   row.names = NULL,
                   col.names = features[[2]])[, features_mean_std]

## Attaching activities and subjects
test_set$activity <-join(read.table('UCI HAR Dataset/test/y_test.txt', col.names = c('activity_id')), activities)[[2]]
test_set$subject <- read.table('UCI HAR Dataset/test/subject_test.txt')[[1]]

## Merging datasets
merged <- rbind(train_set, test_set)

## Aggregating means by subject and activity
data <- aggregate(data[, !names(data) %in% c("activity", "subject")], 
                  by = list(Activity = data$activity, Subject = data$subject), 
                  mean)

## Creating a file
write.table(data, 'tidydata.txt', row.names = FALSE)