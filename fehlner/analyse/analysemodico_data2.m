clear all
close all
%addpath('c:/spm12');
%addpath(genpath('e:\Andi\pipeline'));
%PROJ_DIR = 'Y:\stefanh\MRDATA\MODICOISMRM\3T\';

% myCluster = parcluster('local');
% myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
% saveProfile(myCluster); 

% addpath(genpath('/home/stefanh/HETZER/mrdata/Andi/pipeline'));
% addpath('/home/stefanh/HETZER/mrdata/Andi/analyse/');
% addpath(genpath('/home/stefanh/spm12/'));
% 
% if (strcmp(version('-release'),'2015a'))
% myCluster = parcluster('local');
% myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
% saveProfile(myCluster); 
% end

id = 'data3T';
%id = 'data7T';

if strcmp(id,'data7T')
    PROJ_DIR = '/store01_analysis/realtime/edin7T/';
end
if strcmp(id,'data3T')
    PROJ_DIR = '/store01_analysis/realtime/PERF3T/';
end

%% Subjects %%

% 3T
Asubject3T = {
    {'MREPERF-FD_20150513-133126',7,16,18,14,[30 40 50],40,30,3,4,5,'F. Dittmann',26} % dicom mprage korrupt (nutze nii!)
    {'SHi_MREPERF_20150622',26,9,11,3,[30 40 50],40,30,15,16,17,'S. Hirsch',31}
    {'MREPERF-LM_20150624-131215',14,5,7,3,[30 40 50],40,30,11,12,13,'L. Marz',20}
    {'MREPERF-SH_20150625-145714',14,5,7,3,[30 40 50],40,30,11,12,13,'S. Hetzer',38}
    {'MREPERF-AFAndi_20150625-140247',14,5,7,3,[30 40 50],40,30,11,12,13,'A. Fehlner',29}
    {'MREPERF-TS_20150626-090422',14,5,7,3,[30 40 50],40,30,11,12,13,'T. Scheuermann',28}
    {'MREPERF-JB_20150630-110303',14,5,7,3,[30 40 50],40,30,11,12,13,'J. Braun',54}
    {'MREPERF-IS_20150630-132315',6,19,21,17,[30 40 50],40,30,3,4,5,'I. Sack',45}
    {'MREPERF-HT_20150630-114822',6,19,21,17,[30 40 50],40,30,3,4,5,'H. Tzschaetzsch',30}
    {'MREPERF-AR_20150706-095001',15,5,7,3,[30 40 50],40,30,12,13,14,'A. Ratthey',48}
    {'MREPERF-DS_20150707-164535',15,5,7,3,[30 40 50],40,30,24,13,14,'D. Schubert',56}
    {'MREPERF-TC_20150707-155729',15,5,7,3,[30 40 50],40,30,12,13,14,'T. Christofel',32}
    {'MREPERF-VG_20150707-173412',15,5,7,3,[30 40 50],40,30,12,13,14,'V. Gruendel',28}
    {'MREPERF-DG_20150708-112321',15,5,7,3,[30 40 50],40,30,12,13,14,'D. Glass',53} % seg_epi2mni falsch registriert!
    };

% 7T
Asubject7T = {
    {'nd81-3188_20150114-103840',5,15,17,[7,13,19],[30,40,50],42,70}
    {'ql48-3194_20150115-122916',5,9,11,[7,13,19],[30,40,50],42,70}
    {'ls93-3191_20150115-095226',5,9,11,[7,13,19],[30,40,50],42,70}
    {'hr27-3184_20150113-103002',5,9,11,[7,13,19],[30,40,50],42,70}
    {'ko96-3193_20150115-113626',5,9,11,[7,13,19],[30,40,50],42,70}
    {'bh27-3203_20150121-133914',5,9,11,[7,13,19],[30,40,50],42,70}
    {'sc17-3187_20150113-141143',5,9,11,[7,13,19],[30,40,50],42,70}
    {'rk17-3190_20150114-125344',5,9,11,[7,13,19],[30,40,50],42,70}
    {'zr20-3195_20150115-135043',3,7,9,[5,11,17],[30,40,50],42,70}
    {'br01-3196_20150115-143917',5,9,11,[7,13,19],[30,40,50],42,70}
    {'va08-3199_20150116-101423',5,9,11,[7,13,19],[30,40,50],42,70}
    {'zi11-3182_20150112-113229',27,13,15,[11,17,23],[30,40,50],42,70}
    {'dn20-3186_20150113-130353',5,9,11,[7,13,19],[30,40,50],42,70}
    {'kw96-3189_20150114-115052',5,10,12,[8,14,20],[30,40,50],42,70}
    {'br72-3192_20150115-104047',5,9,11,[7,13,19],[30,40,50],42,70}
    {'vu57-3183_20150112-131410',5,9,11,[9,17,23],[30,40,50],42,70}
    {'kq53-3204_20150121-144103',5,9,11,[7,13,19],[30,40,50],42,70}
    {'mo64-3200_20150119-125505',5,9,11,[7,13,19],[30,40,50],42,70}
    };

if strcmp(id,'data7T')
    Asubject = Asubject7T;
end
if strcmp(id,'data3T')
    Asubject = Asubject3T;
end

%% GM/WM-Maske erstellen
% CreateMask(Asubject);


%% Mutual Information -> TODO: MI(Asubject, X,B) geht nur f�r Schichten (ganze Bilder)?
%[MIo, MIc] = MInf(Asubject);

af_parMI_mpragemean2(PROJ_DIR,Asubject,id,'MNI_');
af_combineMIdata(PROJ_DIR,id,'MNI_'); 
af_plotMIvsmeanmprageMNI(PROJ_DIR,id,'MNI_');

% 
% af_calc_corroverlap(PROJ_DIR,Asubject);
% af_plot_correlationMask_TPM(PROJ_DIR,id,'w');
% af_plot_normoverlap(PROJ_DIR,id,'w');



%% GM/WM Separation -> TODO: GMWM(Asubject, X,WM,GM,B)
[WM_m, GM_m] = GMWM(PROJ_DIR,Asubject);


%% Displacements Dxyz vs. B0
% [Dx, Dy, Dz] = Dxyz(Asubject);

%% Check Data !! #14
% X = CheckData(Asubject,50,'MNI_MPRAGE','wMAGm_orig','wABSG_orig','wMAGm_moco','wABSG_moco','wMAGm_dico','wABSG_dico','wMAGm_modico','wABSG_modico');
% figure; imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[0 2000])
% axis image, colormap(gray), axis off

% X = CheckData(Asubject,50,'MNI_MPRAGE','wMAGm_orig','wMAGm_moco','wMAGm_dico','wMAGm_modico','wANA_c2');
% figure; imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[0 2000])
% axis image, colormap(gray), axis off

