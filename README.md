# Human Activity Recognition Using Smartphones
Note: This document is in Markdown format. See <http://daringfireball.net/projects/markdown/syntax> for format details.

## Purpose of git repo
To provide a script and code book for data cleaning routines for accelerometers from Samsung Galaxy S smartphones. The original data set was available from: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

## Repository Description
This repository contains a script to clean up the above dataset, and a code book (CodeBook.md) in markdown format describing the variables, data, and transformations performed. 

## Data cleaning script
The script (run_analysis.R) is used to download the dataset zip file, extract it, and generate a tidy dataset based on it that contains the averages of the columns containing mean and sd, grouped by activity and subject.

Note that running the script will download a 61MB file from the Internet (so make sure that you have a connection), and subsequent analysis takes some time to complete (dependent on your computer of course). The script has been tested on a 64-bit 1.6 GHz machine and completes in under 50 seconds. 

Also note that re-running the script with the same dir value will not re-download the zip file. See [DIR]/data/harus.zip.download.info.md for download information.

Finally note that the script relies on the plyr library which must be package installed prior to running the script.

###To run the script
1. Source the R file run_analysis.R.
2. Create a directory [DIR] to download data to 
3. Run the following in R: tidyData(dir="[DIR]",name="harus.zip")
- Note that the name value (harus.zip) can be changed to whatever you wish.

Upon doing so, the script will output the text file "harus.txt" to [DIR]/data containing a tidy dataset with 180 rows and 81 columns of data as described in the Variable section of the codebook.