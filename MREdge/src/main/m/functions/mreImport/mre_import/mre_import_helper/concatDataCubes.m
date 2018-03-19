function [ concatCube ] = concatDataCubes( dataCubes )
%CONCATdataCubes Summary of this function goes here
%   Detailed explanation goes here

concatCube=dataCubes(1);
for index=2:length(dataCubes)
    currCube=dataCubes(index);
    concatCellArrays('fullPath','magn');
    concatCellArrays('fullPath','phase');
    concatCellArrays('info','magn');
    concatCellArrays('info','phase');
    concatCube.cube=cat(3,concatCube.cube(:,:,:),currCube.cube(:,:,:));
end

% [ concatCube ] = autoExtractMetaInformationFromDicomHeaders( concatCube );

    function concatCellArrays(part1,part2)
        concatCube.(part1).(part2)=[concatCube.(part1).(part2) ...
            currCube.(part1).(part2)];
    end

end

