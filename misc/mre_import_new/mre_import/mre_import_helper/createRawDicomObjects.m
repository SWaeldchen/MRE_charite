function [ raw_dicom_objects ] = createRawDicomObjects( path,varargin )
%CREATERAWDICOMOBJECTSFROMDICOMFILES Summary of this function goes here
%   Detailed explanation goes here

defaultPath=pwd;
defaultWildCard='.ima';

if nargin<2
    wildcard=defaultWildCard;
    if nargin < 1
        path=defaultPath;
    end
else
    wildcard=varargin{1};
end



if isempty(path)
   path=defaultPath;
end

if ~exist(path,'dir')
    error(['Path does not exist: ' path]);
end



r=dir(path);
isFile=~[r.isdir];
fileList=r(isFile);

matching=false(1,length(fileList));
for index=1:length(fileList)
    matching(index)=~isempty(regexp(fileList(index).name,wildcard,'match'));
end
fileList=fileList(matching);

wb=waitbar(0,'Reading Dicom files...',...
                                        'Name',path);
raw_dicom_objects=[];
n=length(fileList);
for index=1:n
    waitbar(index/n,wb,['Reading dicom files: ('  int2str(index) '/' int2str(n) ')']);
    newDicomObject=struct();
    fullPath=fullfile(path,fileList(index).name);
    newDicomObject.fullPath=fullPath;
    newDicomObject.info=dicominfo(fullPath,'dictionary','Mre_dicom-dict.txt');
    newDicomObject.info.CSASeriesHeaderInfo=char(newDicomObject.info.CSASeriesHeaderInfo');
    newDicomObject.info.CSAImageHeaderInfo=char(newDicomObject.info.CSAImageHeaderInfo');
    
    
    newDicomObject.img=dicomread(fullPath);
    raw_dicom_objects=[raw_dicom_objects newDicomObject];
end
    
delete(wb);



end

