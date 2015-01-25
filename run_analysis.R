# Step 1 - Merges the training and the test sets to create one data set

train_x <- read.table("C:\\Users\\Wu\\Desktop\\UCI HAR Dataset\\train\\X_train.txt", sep = "", header = F)
train_y <- read.table("C:\\Users\\Wu\\Desktop\\UCI HAR Dataset\\train\\y_train.txt", sep = "", header = F)
train_sub <- read.table("C:\\Users\\Wu\\Desktop\\UCI HAR Dataset\\train\\subject_train.txt", sep = "", header = F)

test_x <- read.table("C:\\Users\\Wu\\Desktop\\UCI HAR Dataset\\test\\X_test.txt", sep = "", header = F)
test_y <- read.table("C:\\Users\\Wu\\Desktop\\UCI HAR Dataset\\test\\y_test.txt", sep = "", header = F)
test_sub <- read.table("C:\\Users\\Wu\\Desktop\\UCI HAR Dataset\\test\\subject_test.txt", sep = "", header = F)

train_all <- cbind(train_x, train_y, train_sub)
test_all <- cbind(test_x, test_y, test_sub)

combined_all <- rbind(train_all, test_all)

# Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement

library(dplyr)
features <- read.table("C:\\Users\\Wu\\Desktop\\UCI HAR Dataset\\features.txt", sep = "", header = F, stringsAsFactors=FALSE)
feature_df <- tbl_df(features)
feature_sel <- filter(feature_df, (grepl("mean()", V2) & !grepl("meanFreq()", V2)) | grepl("std()", V2))

measure_sel <- c(feature_sel$V1, dim(train_x)[2]+1, dim(train_x)[2]+2)

# Step 4 - Appropriately labels the data set with descriptive variable names

names_sel <- c(feature_sel$V2, "ActivityID", "SubjectID")
combined_selected <- combined_all[, measure_sel]

# Step 3 - Uses descriptive activity names to name the activities in the data set

activities <- read.table("C:\\Users\\Wu\\Desktop\\UCI HAR Dataset\\activity_labels.txt", sep = "", header = F, stringsAsFactors=FALSE)
names(activities) <- c("ActivityID", "Activity")
combined_updated <- merge(combined_selected, activities, by.x = "ActivityID", by.y = "ActivityID")

# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

df_combined <- tbl_df(combined_updated[2:69])
combined_final <- summarise_each(group_by(df_combined, Activity, SubjectID), funs(mean))

write.table(combined_final, file = "DataCleaningFinal.txt", row.name = FALSE)
