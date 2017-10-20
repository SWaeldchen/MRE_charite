function allfiles=list(wo)
%
% lists of all files and directories
%

if nargin ~= 1
   wo='.';
end

all=dir(wo);
bis=size(all,1);

allfiles=[];

for k=1:bis 
   b=str2mat(all(k).name);
   c(k)=all(k).datenum;
   allfiles=str2mat(allfiles,b);
end

if ~isempty(allfiles) allfiles(1,:)=[]; c(1)=[];
if strcmp(deblank(allfiles(1,:)),'.') allfiles(1,:)=[]; c(1)=[]; end
if strcmp(deblank(allfiles(1,:)),'..') allfiles(1,:)=[]; c(1)=[]; end
end

% [tmp ind]=sort(c);
% 
% allfiles=allfiles(ind,:);