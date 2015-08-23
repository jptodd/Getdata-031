# Getdata-031
Project work for Coursera Getting and Cleaning Data

Uses dataset published in
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. 
International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

# set environment specifics as necessary
Project dataset must be in the working directory
Assumes extracted into ./getdata-projectfiles-UCI HAR Dataset/

Must have the dplyr package installed.

# Read in the Activity descriptions and column names (features)
The activity descriptions are read from the activity_labels.txt file into the activities vector.
Features.txt is read into the features vector to be used in naming the measurements

# Get the test data 
Read in the subject_test, X_test and Y_test files into tbl_df's of same names

# Get the training data
Read in the subject_train, X_train and Y_train files into tbl_df's of same names

# Append the measurement description to the column names for the test and train data using a "." separator
Note we are not just replacing the column names with the descriptive name as the descriptive names are not unique
  and later operations (select) require unique column names.
We can remove the prefix (ofiginal column name and dot (e.g. V1., V318.) later once the data set is tidy as the 
  non-unique columns will no longer be present.

# add the subject and activity codes to the measurements for both data sets
Use cbind to add columns subject and activity_code to the measurements (train and test)  

# combine the datasets
Using rbind

# identify the mean and standard deviation measurements.
Create a boolean array to represent any columns with "mean" or "std" in the column name
We need the column position to do our select, so create an array with position of the TRUE values

# Select the subject, activity_code, and any columns with "mean" or "std"
Store the results in a data table called smaller

# remove the Vx. prefix from the measurement column names
Leave the descriptive name from features.txt

# set the activiity description activity_desc 
Add new column activity_desc to smaller by associating the activity code 
with the description from activity_labels.txt 

#remove the activity_code now that we have the activity_desc
Use select to arrange the subject and activity_desc as the first columns followed by all std and mean measurements
removing the activity_code.

# create a summary line of the mean of each measurement for each subject/activity
Use the 1 row datatable nurow to summarize the data for each subject and activity combination
For each subject / activity calculate the mean of the measurements in each column
add these calculated rows into a data table called tidy

# write the tidy data set to a file
write the tidy data set to the working directory as "tidy.txt" with no Row Names.

