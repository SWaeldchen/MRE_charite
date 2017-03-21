function importAllDicomsAndConvertToMatlab

inputRootPath = uigetdir('', 'pick INPUT dir');
if ~inputRootPath
    return
 
end


outputRootPath = uigetdir('', 'pick OUTPUT dir');
if ~outputRootPath
    return
end


dirs=dir(inputRootPath);
subdirs=dirs([dirs.isdir]);

for index=1:numel(subdirs)
    IN_DIR=fullfile(inputRootPath,subdirs(index).name);
    OUT_DIR=fullfile(outputRootPath,subdirs(index).name);
    if ~isempty(dir(fullfile(IN_DIR,'*.ima')))
        if exist(OUT_DIR,'dir')~= 7
            mkdir(OUT_DIR);
        end
        targetFileName=fullfile(OUT_DIR,'imported_data.mat');
        if ~(exist(targetFileName, 'file')== 2)
           display(['Importing "' subdirs(index).name '"...']);
           [mreCubes otherMagnitudeCubes otherComplexCubes]=standardImport(IN_DIR);
           save(targetFileName,'mreCubes','otherMagnitudeCubes',...
                'otherComplexCubes','IN_DIR','OUT_DIR');
        end
        
    end
end






end
