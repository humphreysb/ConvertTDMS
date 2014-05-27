ConvertTDMS
============

Repo of submissions to MATLAB File Exchange

ConvertTDMS - Function to load LabView TDMS data file(s) into variables in the MATLAB workspace. An *.MAT file can also be created.

simpleConvertTDMS - Function to convert .tdms files to .mat files. the .mat files can then be easily loaded into MATLAB when needed.


Import or convert a LabView TDMS file (version 1.0 through 2.0).  Interleaved and Non-Interleaved tdms files are supported.

These functions also work with tdms files that contain channels using the DAQmxRaw data typr (raw ADC data written by LV), if the files are translated first using the information found at: https://decibel.ni.com/content/docs/DOC-32817

Adding another submission so that Robert Seltzer who has provided a great deal of support for several years and is no longer actively working with TDMS files can hand back off development.

It was written in MATLAB 2010b. The original function was based on the work by Brad Humphreys of ZIN Technologies and Grant Lohsen & Jeff Sitterle of GTRI (versions 1 through 4 of this function). The Version 9 function (written by Philip Top), in addition to incorporating the various updates that were added to previous versions, can process files that have been "optimized" by LabView. Robert Seltzer of Borg Warner has provided a great deal of support and input.  this version is the first using FileEx's new GitHub interface (thanks Mathworks!).

This function has been tested with a limited number of diverse TDMS files.
