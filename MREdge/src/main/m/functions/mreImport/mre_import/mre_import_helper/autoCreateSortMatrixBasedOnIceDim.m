function [ sortMatrix isValid ] = autoCreateSortMatrixBasedOnIceDim( complexCube )
%AUTOEXTRACTSORTMATRIXBASEDONIMAGEINFO Summary of this function goes here
%   Detailed explanation goes here


import mre_import.mre_import_helper.*;

infos=complexCube.ImageInfo;

[ sortFields ] = getIceDimSortFieldsFromImageInfos( infos );


createSortMatrixFromSortFields();
isValid=sortMatrixIsValid();

% 
% 
% if ~isValid()
%     [b1, m1, n1] = unique(sortFields.imageSessUID, 'first');
%     for seriesIndex=1:numel(b1)
% %         currInfos=infos(n1==seriesIndex);
%         selector=(n1==seriesIndex);
%         seriesInfo(seriesIndex).uid=b1(seriesIndex);
%         seriesInfo(seriesIndex).nTimeSteps=1+max(sortFields.timeStepIndex(selector));
%         seriesInfo(seriesIndex).nDirs=1+max(sortFields.dirIndex(selector));
%         seriesInfo(seriesIndex).nFreqs=1+max(sortFields.freqIndex(selector));
%         
%         
%     end
% end
% 
% mreInfo.nSlices=numel(unique(sortFields.SliceLocation));
% mreInfo.nTimeSteps=numel(unique(sortFields.timeStepIndex));
% mreInfo.nDirs=numel(unique(sortFields.dir));

%% helper functions

    function createSortMatrixFromSortFields()
        sortMatrix=[sortFields.sessIndex;...
            sortFields.repetition;...
            sortFields.echo;...
            sortFields.channel;...
            sortFields.SliceLocation]';
    end

    function isValid=sortMatrixIsValid()
        uniqueMatrix=unique(sortMatrix,'rows');
        isValid=isequal(size(uniqueMatrix),size(sortMatrix));
    end



end

