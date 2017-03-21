
IN_path='H:\data\kidney_lupus\';
OUT_conf='H:\data_analysis\kidney_lupus\';
cd(OUT_conf)
load([OUT_conf,'file_name.mat']);
direct=name(22:23,1)';
predict='kidney_';
postdict='\';
for ddd=1:length(direct)
    IN_DIR=[IN_path,name{ddd,2}];
    OUT_DIR= [OUT_conf,predict,direct{ddd},postdict];
    if (exist(OUT_DIR)~=7)
        mkdir(OUT_DIR);
    end
    [mreCubes otherMagnitudeCubes otherComplexCubes]=standardImport(IN_DIR);
    %save([OUT_DIR,['data_',direct{ddd}],'.mat'],'mreCubes','otherMagnitudeCubes','otherComplexCubes','OUT_DIR','IN_DIR','otherComplexCubes');
    save([OUT_DIR,'imported_data.mat'],'mreCubes','otherMagnitudeCubes','otherComplexCubes','OUT_DIR','IN_DIR','otherComplexCubes');
end

