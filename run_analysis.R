run_analysis <- function(data.dir = "./data") {
    if(!file.exists(data.dir)) {
        dir.create("data")
    }
    
    dataset.file <- paste(data.dir, "dataset.zip", sep="/")
    dataset.dir <- paste(data.dir, "UCI HAR Dataset", sep="/")
    
    if(!file.exists(dataset.file)) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destfile=dataset.file, method="curl")
    }
    if (!file.exists(dataset.dir)) {
        unzip(dataset.file, exdir=data.dir)
    }

    # prettify names
    # remove () characters
    # return names seperated by underscores
    # 
    # @param array names
    # @return array
    prettify_names <- function(names) {
        names <- gsub("[()]", "", names)
        names <- gsub("-", "_", names)

        names
    }


    # load datafiles in provided directory
    # We expect three files, starting with either: subject_, y_, x_
    #
    # For the X data, only return the columns provided by meanCols and stdCols
    #
    # @param string type
    # @paraam string directory
    # @param array meanCols
    # @param array stdCols
    # @return data.frame
    load_data <- function(type, directory, meanCols, stdCols) {
        subject <- read.table(sprintf("%s/%s/subject_%2$s.txt", directory, type))
        names(subject) <- "subject"
        activity <- read.table(sprintf("%s/%s/y_%2$s.txt", directory, type))
        names(activity) <- "activity"
        tempdata <- read.table(sprintf("%s/%s/X_%2$s.txt", directory, type))
        
        meanData <- tempdata[,meanCols[,1]]
        names(meanData) <- meanCols[,2]
        
        stdData <- tempdata[,stdCols[,1]]
        names(stdData) <- stdCols[,2]
        
        data.frame(subject, activity, meanData, stdData)
    }

    # load features definition and find the column numbers that correspond to `mean` and `std`
    features <- read.table(paste(dataset.dir, "features.txt", sep="/"))
    features[,2] <- prettify_names(features[,2])

    meanColumns <- features[grep("mean", features[,2], ignore.case = TRUE),]
    stdColumns <- features[grep("std", features[,2], ignore.case = TRUE),]

    # load activity definition
    activity <- read.table(paste(dataset.dir, "activity_labels.txt", sep="/"))

    # load test data and traing data.
    testData <- load_data("test", dataset.dir, meanColumns, stdColumns)
    trainData <- load_data("train", dataset.dir, meanColumns, stdColumns)

    combinedData <- rbind(testData, trainData)

    # replace activity id by activity name
    combinedData$activity <- activity[match(combinedData$activity, activity[,1]), 2]

    # return tidy aggregate
    # for every activity and subject, aggregate the mean for every column
    aggregate(. ~ activity + subject, data = combinedData, mean)
}
