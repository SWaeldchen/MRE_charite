function [ sortFields ] = getIceDimSortFieldsFromImageInfos( infos )
%GETSORTFIELDSFROMIMAGEINFOS Summary of this function goes here
%   Detailed explanation goes here


names=fieldnames(infos(1).IceDims);
for index=1:numel(infos)
    for fieldIndex=1:length(names)
        infos(index).(['IceDims_' names{fieldIndex}])=infos(index).IceDims.(names{fieldIndex});
    end
end




sortFields=struct();
sortFields.SliceLocation=[infos.SliceLocation];
for fieldIndex=1:length(names)
    sortFields.(names{fieldIndex})=[infos(:).(['IceDims_' names{fieldIndex}])];
end

%% Default case: whole cube was created from one measurement


% sortFields.channel=[infos.IceDim_channel];
% sortFields.echo=[infos.IceDim_channel];
% sortFields.freqIndex=[infos.mre_freqIndex];
sortFields.sessIndex=zeros(1,numel(infos));

sortFields.SeriesInstanceUID={infos.SeriesInstanceUID};
% [b1, m1, n1] = unique(sortFields.SeriesInstanceUID, 'first');
% sortFields.sessIndex=n1;

% sortFields.cycle=[infos.mre_mechCycleTime_us];




end

