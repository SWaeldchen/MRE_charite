% 
% xDim = N;
% yDim = N;
% zDim = N;
% 
% useGPU = 0;
% directionalFilter = modulate2(dfilters('cd','d')./sqrt(2),'c')
% shearletSystem = SLgetShearletSystem3D(useGPU, xDim, yDim, zDim, 1, 1);

%brain = load('~/Documents/matlab/data_for_SW/BRAIN.mat');
dataStruct = load_untouch_nii('~/Documents/matlab/Magnitude/c1Avg_Magnitude.nii');
greyMatter = dataStruct.img;
dataStruct = load_untouch_nii('~/Documents/matlab/Magnitude/c2Avg_Magnitude.nii');
whiteMatter = dataStruct.img;
dataStruct = load_untouch_nii('~/Documents/matlab/Magnitude/c3Avg_Magnitude.nii');
fluid = dataStruct.img;

comb = greyMatter + whiteMatter + fluid

comb(20:60, 30:70,:) = 255;


MIJ = Miji;
openImage(comb, MIJ, 'title');