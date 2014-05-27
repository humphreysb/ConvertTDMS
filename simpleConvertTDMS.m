function matFileName=simpleConvertTDMS(fileName,ignoreGroupNames)

%matFileName=simpleConvertTDMS(fileName)
%
%Function to convert .tdms files to .mat files.  This function calls
%convertTDMS and creates a .mat file for each .tdms file provided. It
%a more intuitive set of variables to the .mat file (which can then be
%loaded into the Matlab workspace with load command).
%
%   Inputs:
%               filename (optional) - Filename to be converted.
%                 If not supplied, the user is provided a 'File Open' dialog box
%                 to navigate to a file.  Can be a cell array of files for bulk
%                 conversion.
%               ignoreGroupNames (optional) - if 1, use only the channel
%                   names in creating the data variables. (See below)
%
%
%   Outputs:
%
%               matFileName - Structure array containing the names of the
%                   new mat files.
%
%   Example:  
%       To convert/load a single file:       
%               matFileName=simpleConvertTDMS('nameOfTDMS.tdms');
%               load(matFileName);
%
%       To get a list of the channels in matFileName, use whos:
%               whos -file matFileName
%
%       To get one channel from the .mat file, use whos and then load only
%           the channel:
%               load(matFileName,'nameOfChannelFromWhosOutput')
%
%   Comments:
%       ignoreGroupNames: This was added
%           because LV uses a ugly (timestamp) for the default
%           group name if groupname is not supplied by the LV programmer.
%           Caution should be excersised when setting to 1 as multiple
%           groups can be in a tdms file with the same channel names and 
%           this would cause cahnnels to be overwritten during conversion.
%
%   See also: convertTDMS

%-------------------------------------------------------------------------
%Brad Humphreys - v1.0 2013-11-16
%ZIN Technologies
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Brad Humphreys - v1.1 2014-1-13
%Added check to see if the group/channel name begins with an alpha
%char.  LV allows group and channel names to begin with  numeric char.
%If first char are numeric, a "d" is prepended to the group name
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Brad Humphreys - v1.2 2014-2-7
%Added example function call to help.
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Brad Humphreys - v1.3 2014-5-27
%Added ignoreGroupNames option and replace strsplit function to make more
%backwards compatible per suggestion from Randy82.
%-------------------------------------------------------------------------

if nargin==0
    %Prompt the user for the file
    [fileName,pathName]=uigetfile({'*.tdms','All Files (*.tdms)'},'Choose a TDMS File');
    if fileName==0
        return
    end
    fileName=fullfile(pathName,fileName);
end

if nargin<2 %Default to not ignoring groupnames
    ignoreGroupNames=0;
end

if iscell(fileName)
    %For a list of files
    inFileName=fileName;
else
    inFileName=cellstr(fileName);
end

for fnum=1:numel(inFileName)  % Loop through cells of filename
    
    tdmsFileName=inFileName{fnum};
    
    %Perform Conversion
    [convertedData,dataOb.convertVer,d.chanNames,d.groupNames,dataOb.ci]=convertTDMS(0,tdmsFileName);
    
    
    %Build more obvious struture of data form file
    dataOb.fileName=convertedData.FileName;
    dataOb.fileFolder=convertedData.FileFolder;
    channelNames={convertedData.Data.MeasuredData.Name};
    
    for cnum=1:numel(channelNames)
        
        if ignoreGroupNames      %Drop the group name
            if ~isempty(strfind(channelNames{cnum},'/'));
                %splitName=strsplit(channelNames{cnum},'/');
                splitName=regexp(channelNames{cnum}, '/', 'split');
                channelNames{cnum}=splitName{end};
            end
        end
        
        safeChannelName{cnum} = regexprep(channelNames{cnum},'\W','');  %Remove charters not compatible for variable names
        chanNameTemp=safeChannelName{cnum};
        if ~isstrprop(chanNameTemp(1),'alpha');   %If the first character is not alpha, append a 'd' 
            safeChannelName{cnum}=['d' safeChannelName{cnum}];
        end
        
        
        dataOb.(safeChannelName{cnum}).Data=convertedData.Data.MeasuredData(cnum).Data;
        dataOb.(safeChannelName{cnum}).Total_Samples=convertedData.Data.MeasuredData(cnum).Total_Samples;
        
        %Convert the properties
        prop=convertedData.Data.MeasuredData(cnum).Property;
        
        for pcnt=1:numel(prop)
            pName=prop(pcnt).Name;
            safePropName= regexprep(pName,'\W','');
            pValue=prop(pcnt).Value;
            dataOb.(safeChannelName{cnum}).Property.(safePropName)=pValue;
        end
        
    end
    
    %Write the file
    [pathstr,name,ext]=fileparts(tdmsFileName);
    matFileName{fnum}=fullfile(pathstr,[name '.mat']);
    save(matFileName{fnum},'-struct','dataOb');
    fprintf('Saved File ''%s''\n',matFileName{fnum})
end
