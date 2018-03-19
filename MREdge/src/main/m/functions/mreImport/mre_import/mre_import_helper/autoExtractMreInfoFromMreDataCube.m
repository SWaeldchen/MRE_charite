function [ complexCubeWithMreInfo ] = autoExtractMreInfoFromMreDataCube( complexCube )
%AUTOEXTRACTMREINFOFROMMREDATACUBE Summary of this function goes here
%   Detailed explanation goes here

mreInfo.nSlices=size(complexCube.cube,3);
mreInfo.nTimeSteps=size(complexCube.cube,4);
mreInfo.nDirs=size(complexCube.cube,5);
mreInfo.nFreqs=size(complexCube.cube,6);
mreInfo.nSess=size(complexCube.cube,7);

si=[mreInfo.nSlices mreInfo.nTimeSteps mreInfo.nDirs mreInfo.nFreqs mreInfo.nSess];


infos=complexCube.ImageInfo;

names=fieldnames(infos(1).mre);
for index=1:numel(infos)
    for fieldIndex=1:length(names)
        infos(index).(['mre_' names{fieldIndex}])=infos(index).mre.(names{fieldIndex});
    end
end

mreInfo.timeCorrectionForSlices_us=reshape([infos.mre_timeCorrectionForSlice_us],si);
mreInfo.timeCorrectionForSlices_us=reshape(mreInfo.timeCorrectionForSlices_us(:,1,:,:,:),si([1 3:5]));
mreInfo.megVectors=reshape([infos.mre_megVector],[3 si]);
mreInfo.megVectors=reshape(mreInfo.megVectors(:,1,1,:,:,:),[3 si(3:5)]);
mreInfo.mechCycleTimes_us=reshape([infos.mre_mechCycleTime_us],si);
mreInfo.mechCycleTimes_us=reshape(mreInfo.mechCycleTimes_us(1,1,1,:,:),si(4:5));
mreInfo.freqs_Hz=1e6./mreInfo.mechCycleTimes_us;
 



complexCubeWithMreInfo=complexCube;
complexCubeWithMreInfo.mreInfo=mreInfo;

end

