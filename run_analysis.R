# Script to prepare a tidy data set from the data in 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
# See https://github.com/pszjmb1/Human-Activity-Recognition-Using-Smartphones for more details.

tidyData <- function(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dir, name) {
  # This function does the following:
  # 0. Download and extract the zip file.
  # 1. Merge the training and the test sets from the given url into one data set.
  # 2. Extract only the measurements on the mean and standard deviation for each measurement. 
  # 3. Use descriptive activity names to name the activities in the data set
  # 4. Label the data set with descriptive variable names.   
  # 5. Create a tidy data set From the data set in step 4, with the average of each variable for each activity and each subject.  
  #
  # Args:
  #   url: Location of downloadable zip file
  #   dir: Base directory to download data to
  #   name: Name of local version of downloaded file
  #
  # Returns:
  #   A tidy data set with the average of each variable 
  #   from the Human-Activity-Recognition-Using-Smartphones dataset (both training and testing data)
  #   for each activity and each subject. Note that the file "harus.txt" is also written to dir/data.
    
  # Download and extract the zip file.
  aDir <- getData(url, dir, name)
  # Set downloaded extracted directory as the working directory
  setwd(aDir)
  # Merge the training and the test sets from the given url into one data set with labelled with descriptive variable names
  # Note this is step 1 and 4.
  measurements <- mergeTestAndTrainDatasets()
  # Extract only the measurements on the mean and standard deviation for each measurement. 
  timeprint("Extracting data...")
  measurements<-cbind(measurements$subjects,measurements$activities,measurements[grepl("mean|std", names(measurements), ignore.case = TRUE)])
  colnames(measurements)[1] <- 'subjects' # Fix cbind's weird namechange
  colnames(measurements)[2] <- 'activities'   # Fix cbind's weird namechange
  # Use descriptive activity names to name the activities in the data set
  codes <- c(walking=1, walking_upstairs=2, walking_downstairs=3, 
                       sitting=4,  standing=5, laying=6)
  measurements$activities <- names(codes)[match(measurements$activities, codes)]
  # Create a tidy data set From the data set in step 4, with the average of each variable for each activity and each subject.  
  library(dplyr)
  res <- ddply(tidy, .(labels, subjects), numcolwise(mean))
  timeprint("Writing output to file...")
  setwd('../../')
  write.table(tidy,paste(getwd(),"harus.txt",sep="/"),row.name=FALSE)
  timeprint("Data analysis complete.")
  tidy
}
  
getData <- function(fileURL, dir, name) {
  # This function downloads and extracts a zip file corresponding to the given url. 
  # Note that this routine only downloads and extracts the zip file if it has not already been
  # downloaded. To re-download please delete the local copy of the file.
  #
  # Args:
  #   fileURL: Location of downloadable zip file
  #   name: name of local file
  #
  # Returns:
  #   Folder location of extracted dataset
  
  ## Set the data directoy
  setwd(dir)
  if(!file.exists("data")){dir.create("data")}
  
  ## Download data
  if(!file.exists(paste("./data/",name,sep=""))){
    timeprint("Downloading data...")
    download.file(fileURL, destfile = paste("./data/",name,sep=""), method="curl")
    write(paste("Raw data downloaded from:", fileURL,"\n", date()), file = paste("./data/", name, ".download.info.md", sep=""))
    
    ## Extract data
    timeprint("Unzipping data...")
    unzip(paste("./data/",name,sep=""),exdir="./data/extract")       
  } else{
    timeprint("Using existing data.")
  }
  paste("./data/extract/",list.files("./data/extract"),sep="")
}

mergeTestAndTrainDatasets <- function(){
  # Merges testing and training datasets
  #
  # Returns:
  #   The merged dataset
  
  timeprint('Loading test data...')
  testSubject <- read.table('./test/subject_test.txt')
  names(testSubject) <- "subjects"
  yTest <- read.table('./test/y_test.txt')
  names(yTest) <- "activities"
  xTest <- read.table('./test/x_test.txt')
  featureLabels <- read.table('./features.txt')  
  names(xTest) <- featureLabels$V2
  test<-cbind(testSubject,yTest,xTest)
  
  timeprint('Loading train data...')
  trainSubject <- read.table('./train/subject_train.txt')
  names(trainSubject) <- "subjects"
  yTrain <- read.table('./train/y_train.txt')
  names(yTrain) <- "activities"
  xTrain <- read.table('./train/x_train.txt')
  featureLabels <- read.table('./features.txt')  
  names(xTrain) <- featureLabels$V2
  train<-cbind(trainSubject,yTrain,xTrain)
  
  timeprint('Merging datasets...')
  rbind(test,train)  
}

timeprint <- function(s){
  # Prints out the given string with a datestamp
  #
  # args:
  #  s: The string to print
  s <- paste(format(Sys.time(), "%a %b %d %H:%M:%S %Y"),s,sep="> ")
  print(s)
}