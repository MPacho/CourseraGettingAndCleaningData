### The following script prepares the data from
### Human Activity Recognition Using Smartphones study
### Assumes that working directory is set to the "UCI HAR Dataset" folder 
### analysis conducted on Windows OS.

library(data.table)
library(dplyr)

### ------------------------------------------------------------------------
### (1) Merges the training and the test sets to create one data set

# Read and combine the test and train features datasets together
X_train <- fread("train\\X_train.txt")
X_test <- fread("test\\X_test.txt")
X <- rbind(X_train, X_test)
# Read features labels and attach them as column names to X
features <- fread("features.txt", select = 2, col.names = "name")
names(X) <- features$name

# Read and combine the test and train activity datasets together
y_train <- fread("train\\y_train.txt")
y_test <- fread("test\\y_test.txt")
y <- rbind(y_train, y_test)
# Label activities
names(y) <- "activity_code"

# Read and combine the test and train subject datasets together
subject_train <- fread("train\\subject_train.txt")
subject_test <- fread("test\\subject_test.txt")
subject <- rbind(subject_train, subject_test)
# Label subjects
names(subject) <- "subject"

# Combine subject, activity and features datasets together into one dataset
data <- cbind(subject, y, X)


### ------------------------------------------------------------------------
### (2) Extracts only the measurements on the mean and standard deviation 
### for each measurement

# Find features that end with -mean() or -std()
sel_features <- grep("(-mean\\(\\)|-std\\(\\))$", features$name, value=TRUE)
# Subset the data by retaining only the selected features
data <- data[, c("activity_code", "subject", sel_features), with=FALSE]


### ------------------------------------------------------------------------
### (3) Uses descriptive activity names to name the activities in the data set

# Read the activity labels
activities <- fread("activity_labels.txt", col.names = c("code", "activity"))
# replace activity codes by labels in the data
data <- data %>% merge(activities, by.x="activity_code", by.y="code") %>%
                 select(activity, subject, sel_features)

### ------------------------------------------------------------------------
### (4) Appropriately labels the data set with descriptive variable names

# In my opinion the original variable names are descriptive enough, given their 
# relatively large lengths.
# During the course it was suggested that variable names should be put to lower case
# and that any abbriviations should be expanded. However in this particular case
# those two transformations would significantly decrease user experience: it would
# make variable names very long and illegible. This is why the decision has been made
# to skip those suggestions.
# Variable name cleaning will be thus limited only to:
# - getting rid of non-alphanumeric characters
# - expanding "t" and "f" at the beginning of each variable name into "time" and "freq" 
#   respectively for more clarity.
# - assuring camel case 

sel_features <- ifelse(substr(sel_features, 1, 1) == "t", 
                       sub("^.", "time", sel_features), 
                       ifelse(substr(sel_features, 1, 1) == "f",
                              sub("^.", "freq", sel_features),
                              sel_features
                       )
                )
sel_features <- sub("-mean", "-Mean", sel_features)
sel_features <- sub("-std", "-Std", sel_features)
sel_features <- gsub("[^a-zA-Z0-9]", "", sel_features)

names(data)[-(1:2)] <- sel_features

### ------------------------------------------------------------------------
### (5) From the data set in step 4, creates a second, independent tidy data set with
### the average of each variable for each activity and each subject

tidy_dataset <- data %>% group_by(activity, subject) %>% summarize_all(funs(mean))

# write the result into a file
write.table(tidy_dataset, "tidy_dataset.txt", row.name=FALSE)


