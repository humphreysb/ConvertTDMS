ConvertTDMS
============

Repo of submissions to MATLAB File Exchange (http://www.mathworks.com/matlabcentral/fileexchange/44206-converttdms--v10-)

Import or convert a LabView TDMS file (version 1.0 through 2.0).  Interleaved and Non-Interleaved tdms files are supported.

These functions also work with tdms files that contain channels using the DAQmxRaw data type (raw ADC data written by LV), if the files are translated first using the information found at: https://decibel.ni.com/content/docs/DOC-32817


Files
============
ConvertTDMS - Function to load LabView TDMS data file(s) into variables in the MATLAB workspace. An *.MAT file can also be created.

simpleConvertTDMS - Function to convert .tdms files to .mat files. the .mat files can then be easily loaded into MATLAB when needed.


Test Files
============

The exampleFiles directory contains some simple files to test and troubleshoot with.    Please update the testFileInventoryList.txt to describe your file and any issues with it.  (Note that GitHub limits file uploads to 100MB). 


TDMS Best Practices
============

Most issues with converting TDMS files comes from  how the were orginally written.  This is much more true with older (v1.0) files which wrote a meta data header each time the write vi was executed in LabView.  With that said, please note the following about LV programming best practices:

1) We have used these functions to translate files up to 3GB. In general it's not a good practice to write TDMS files over a ~1GB. Typically in Labview, we code for a new tdms file to be "auto-started" every ~500MB. This has saved me several times when a file becomes corrupted (by file handling or LV itself) and we don't loose the whole large data set. 

2) When writing data in LV, use a que/FIFO to build up numerous samples of data and then write the data.  Don't use the TDMS write VI at every sample. 


Working with Files Containg a Large Number of Channels
============

What to do if you have a large file with a lot of channels and you don't want to read in all of the chhanels into MATLAB:

1) Convert the .tdms file to a .mat file using simpleConvertTDMS. 
2) If you want to work with just a particular channel, use the "load" command to only load the channel from the .mat file: load('FileName.mat','NameOfYourChannel'); 
3) You can then access the data using: yourData=NameOfYourChannel.Data;

If you need a way to see what channels are in the file without loading whole file, use the "whos" function.


History
============

It was written in MATLAB 2010b. The original function was based on the work by Brad Humphreys of ZIN Technologies and Grant Lohsen & Jeff Sitterle of GTRI (versions 1 through 4 of this function). The Version 9 function (written by Philip Top), in addition to incorporating the various updates that were added to previous versions, can process files that have been "optimized" by LabView. Robert Seltzer of Borg Warner has provided a great deal of support and input.  This version is the first using FileEx's new GitHub interface (thanks Mathworks!).

This function has been tested with a limited number of diverse TDMS files.
