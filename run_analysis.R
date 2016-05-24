
#download zip file. Unzip them and copy into the /data directory.  

URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "./UCI HAR Dataset.zip")

# You are now ready to load these files into R.
# Load the files into are

# Load the features and activity labels in the main directory

act <- read.table("./activity_labels.txt")
feat <- read.table("./features.txt")

# Load the files in the test directory
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subj_test <- read.table("./test/subject_test.txt")

# Load the files in the train directory
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subj_train <- read.table("./train/subject_train.txt")

# Bind the datasets from test and train directories
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subj <- rbind(subj_test, subj_train)
feat1 <- grep("-(mean|-std)\\(\\)",feat[,2])

# Header label for subj
colnames(subj) <- "Subject_ID"

# Merging process
library(plyr)
act1 <- join(y, act)
act2 <- act1[,2]
act2 <- data.frame(act2)

#Header label for act2
colnames(act2) <- "Activity"

# Labels for data 
x <- x[,feat1]
names(x) <- gsub("\\(\\)","",feat$V2[feat1])

#complete the data set here
comb_data <- cbind(subj, x, act2)
write.table(comb_data, "combined_data.txt")

#calculate the mean and the standard deviation
library(data.table)
tidydata <- data.table(comb_data)
MeanStdDev <- tidydata[,lapply(.SD, mean), by = c("Subject_ID", "Activity")]
write.table(MeanStdDev, "tidydata.txt", row.name = FALSE)



