# Coursera - Getting And Cleaning Data

This project follows the final project assignment for Johns Hopkins University's Getting and Cleaning Data course on Coursera.org

It uses data from Samsung's Human Activity Recognition Using Smartphones study available <a target="_blank" href="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones">here</a>

During this study certain measurements were taken on 30 <b>subjects</b> (people) doing a set of 6 <b>activities</b> (walking, walking upstairs, walking downstairs, sitting, standing, laying).
Those measurements were subsequently processed into a set of 561 <b>features</b>.

The run_analysis.R script reads the raw data from the study and does the following manipulations:
- Combines the individual pieces (subject, activity and features) from two subsets (train and test) together into one data frame
- Subsets the set of features to only include those being means and standard deviations of measures taken during the study (features with "-mean()" or "-std()" at the end of their names)
- Replaces activity codes with meaningful labels
- Executes some cleaning on the features' names. The original features' names seem descriptive enough, given their relatively large lengths. During the course it was suggested that variable names should be put to lower case and that any abbreviations should be expanded. However in this particular case those two transformations would significantly decrease user experience: it would make variable names very long and illegible. This is why the decision has been made to skip those suggestions. Variable name cleaning has been thus limited only to:
	* getting rid of non-alphanumeric characters
	* expanding "t" and "f" at the beginning of each variable name into "time" and "freq" respectively for more clarity.
	* assuring camel case 
- Aggregates data by subject and activity

The output file is a dataset with averages of features for each activity and subject.

The script assumes that working directory is set to the "UCI HAR Dataset" folder. The analysis has been conducted on Windows OS.

For variable descriptions, please look into the Code Book.