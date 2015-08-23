# getdata-031 project

# Uses dataset published in
# [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
# Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. 
# International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

# set environment specifics as necessary
# .libPaths(new = "C:/Program Files/R/R-3.2.1/library")
# library("dplyr", lib.loc="C:/Program Files/R/R-3.2.1/library")
# setwd("C:/Coursera/Data Science/getdata-031")

# requires dplyr
library("dplyr")

# Read in the Activity descriptions and column names (features)
activities <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")

# Get the test data 
subject_test <- tbl_df(read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt"))
X_test <- tbl_df(read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt"))
Y_test <- tbl_df(read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt"))

# Get the training data
subject_train <- tbl_df(read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt"))
X_train <- tbl_df(read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"))
Y_train <- tbl_df(read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt"))

# Append the measurement description to the column names for the test and train data.  
# Note we are not just replacing the column names with the descriptive name as the descriptive names are not unique
#   and later operations (select) require unique column names.
# We can remove the prefix (ofiginal column name and dot (e.g. V1., V318.) later once the data set is tidy as the 
#   non-unique columns will no longer be present.
names(X_test) <- paste(names(X_test), features$V2, sep = ".")
names(X_train) <- paste(names(X_train), features$V2, sep = ".")

# add the subject and activity codes to the measurements for both data sets
test <- cbind(select(subject_test, subject = 1), X_test, select(Y_test, activity_code = 1))
train <- cbind(select(subject_train, subject = 1), X_train, select(Y_train, activity_code = 1))

# combine the datasets
combined <- rbind(test, train)

# identify the mean and standard deviation measurements.
# Create a boolean array to represent any columns with "mean" or "std" in the column name
tf <- grepl("mean", names(combined)) | grepl("std", names(combined))
# We need the column position to do our select, so create an array with position of the TRUE values
tfx <- c(1:length(tf))[tf]


smaller <- select(combined, subject, activity_code, tfx)

# remove the Vx. prefix
names(smaller) <- sub("^V\\d+[.]", "", names(smaller))

# set the activiity description activity_desc by associating the activity code with the description from 
# activity_labels.txt 
smaller <- mutate(smaller, activity_desc = activities[activity_code, 2])

#remove the activity_code now that we have the activity_desc
smaller <- select(smaller, subject, activity_desc, everything(), -activity_code)

nurow <- smaller[1,]    # used to create a summary line of the mean of each measurement for each subject/activity
tidy <- NULL            # initial new summary data set

for(s in unique(smaller$subject))           # for each subject
{
    nurow$subject = s
    for(a in unique(smaller$activity_desc)) #for each activity
    {
        nurow$activity_desc <- a
        for(c in 3:81)                      # for each measurement column
        {
            # take the average of the readings for that column for that subject / activity 
            nurow[,c] <- mean(filter(smaller, subject == s, activity_desc == a)[,c])
        }
        tidy <- rbind(tidy, nurow)          # add the summarized row to the new tidy dataset
    }
}

# write the tidy data set to a file
write.table(tidy, file="tidy.txt", row.names = FALSE)

