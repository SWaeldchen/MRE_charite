function pipeline_modico_edin30T(subjectlist)

if (strcmp(version('-release'),'2015a'))
myCluster = parcluster('local');
myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
saveProfile(myCluster); 
end

if ~exist('subjectlist','var')        
    subjectlist = 1:16; %1:14; 
end

%% Set Paths, Directories, Functions, Subjects and Fixed Parameters
% paths for spm, modico, infun and rician
if isunix
    addpath(genpath('/home/realtime/spm12/'));
    addpath(genpath('/home/realtime/project_modico/pipeline'));  
    SCRIPT_DIR = '/home/realtime/project_modico/pipeline/';
    PROJ_DIR = '/store01_analysis/realtime/edin3T/';
end

if (strcmp(version('-release'),'2015b'))
    addpath(genpath('/home/andi/work/mretools/project_modico/'));
    addpath(genpath('/opt/MATLAB/R2015b/toolbox/spm12/'));
    addpath('/home/andi/in_fun/');
    load('/home/andi/work/mretools/project_modico/script_modico/cmp_uh.mat');
    PROJ_DIR = fullfile('/media','afdata','project_modico');
end

PIC_DIR = fullfile(PROJ_DIR,'PICS');
if ~exist(PIC_DIR,'dir'), mkdir(PIC_DIR); end

disp(path);

TPMdir = fullfile(spm('Dir'),'tpm');
modicomod = 2;


Asubject_cell = {
    {'MMRE-brain-edin-3T-AF-2015-01-16_20150116-095142',2,7,9,11,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-AK-2015-01-29_20150129-125926',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-DS-2015-01-16_20150116-201002',2,4,6,8,[30,40,50],16,30} % Probleme, dauerte ewig
    {'MMRE-brain-edin3T-HT-2015-01-15_20150115-145827',2,5,7,3,[30,40,50],16,30}
    {'mmre-brain-edin-3T-IS-2015-01-29_20150129-124057',3,4,6,8,[30,40,50],16,30}
    {'mmre-brain-edin-3T-jb-2015-01-29_20150129-121857',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-JHA-2015-02-05_20150205-151732',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-SS-2015-03-03_20150303-182203',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-AR-3T-2015-03-09_20150309-155843',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-FS-3T-2015-03-03_20150303-184049',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-HS-3T-2015-03-03_20150309-164039',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-JD-3T-2015-03-03_20150303-185722',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-JH-3T-2015-03-09_20150309-162220',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-JG-3T-2015-01-26_20150126-120220',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-SH-2015-01-26_20150126-113526',2,3,5,9,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-SIU-2015-01-26_20150126-122207',2,3,5,7,[30,40,50],16,30}
    };




rowHeadings={'name','mprage','refRL','refLR','dynma','dynfreqs','nslices','tesla'};

for ksub = 1:size(Asubject_cell,1)
    TMP_c2s = cell2struct(Asubject_cell{ksub}',rowHeadings,1);
    Asubject1(ksub) = TMP_c2s;
    Asubject2(ksub).dynph = Asubject1(ksub).dynma + 1;
end
Asubject = catstruct(Asubject1,Asubject2);

freqs = [30 40 50];
pixel_spacing = [2 2]/1000;

%subjectlist = 1;

%wrapper_processmodico(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing,modicomod,[2 2 2]);

class_analysemodico.plotoverview_EPI(PROJ_DIR,Asubject_cell);
class_analysemodico.plotoverview_MNI(PROJ_DIR,Asubject_cell);

%class_modicoismrm.moveima2SCAN_SUB(PROJ_DIR,Asubject,subjectlist);
%class_modicoismrm.mredata_topup2RAWN(PROJ_DIR,SCRIPT_DIR,Asubject,subjectlist);
% 
% class_modicoismrm.moveima2SCAN_SUB(PROJ_DIR,Asubject,subjectlist);
% 
% %class_modicoismrm.mredata_plotpic(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.mredata_import(PROJ_DIR,Asubject,subjectlist,2);
% class_modicoismrm.mredata_copyRAWN2ANA(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.mredata_calc(PROJ_DIR,Asubject,subjectlist,2);
% class_modicoismrm.mredata_ri2pm_origmoco(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.mredata_ri2pm_dicomodico(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.mredata_mdev(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing);
% class_modicoismrm.mpragedata_import(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.mredata_copyRAWN2ANA(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.sub_segment_ana2mni(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.sub_segment_epi2ana(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.sub_segment_epi2mni(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.sub_create_dmyfield(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.sub_deform_epi2mni(PROJ_DIR,Asubject,subjectlist,[2 2 2]);
% class_modicoismrm.sub_deform_ana2epi(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.sub_deform_ana2mni(PROJ_DIR,Asubject,subjectlist);
% 
% 
% 
% %class_modicoismrm.sub_norm_epi2mni(PROJ_DIR,Asubject,subjectlist,[2 2 2]);
% 
% %class_modico.combine_3D_PARA_segMRE(PROJ_DIR,Asubject_struct,subjectlist)
% %class_modico.combine_3D_maskseg(PROJ_DIR,Asubject_struct,subjectlist);
% %class_modico.plot_myfield_fieldMAGRL(PROJ_DIR,Asubject_struct,subjectlist);
% 


end
