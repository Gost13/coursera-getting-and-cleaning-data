CodeBook
========

The script file `run_analysis.R` contains a function `run_analysis` that accepts an optional `data.dir` parameter.

When excecuting the function, it performs the following tasks:
*  it checks if the [Human Activity Recognition Using Smartphones Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) dataset is available. If not, it will download and unzip it.
*  it loads the following files:
    -  features.txt
    -  activity_labels.txt
    -  test/subject_test.txt
    -  test/y_test.txt
    -  test/X_test.txt
    -  train/subject_train.txt
    -  train/y_train.txt
    -  train/X_train.txt
*  for the `X_test` and `X_train` data set, it will filter only the columns that have `mean` or `std` in the column name
*  the test and train data will be merged together
*  all the activity label numbers provided by `y_test` and `y_train` will be replaced by the activity name provided by `activity_labels.txt`
*  cleaned up column names will be provided by data from `features.txt`
*  an aggregated table will be returned containing the mean for every variable per subject and activity

Variables
---------

The function `run_analysis` contains several variables. Below is explained what they are for.
*  `data.dir`: string, contains the name of the directory where the data is stored
*  `dataset.file`: string, name of downloaded dataset file
*  `dataset.dir`: string, name of directory where dataset is unzipped
*  `features`: vector, contains all the column names in dataset
*  `meanColumns`: data.frame, contains column numbers and names of columns that contain the string `mean`
*  `stdColumns`: data.frame, contains column numbers and names of columns that contain the string `std`
*  `activity`: data.frame, contains id and name of activities
*  `testData`: data.frame, contains all cleaned up data for test set
*  `trainData`: data.frame, contains all cleaned up data for train set
*  `combinedData`: data.frame, contains combined data from test and train set

Functions
---------
*  `prettify_names`: removes `()` and makes names underscore seperated
*  `load_data`: loads train or test data set and creates data.frame out of `subject`, `label` and `X` data.
