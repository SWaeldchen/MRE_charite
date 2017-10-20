function pipeline_modico_edin15T(subjectlist)

if (strcmp(version('-release'),'2015a'))
myCluster = parcluster('local');
myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
saveProfile(myCluster); 
end

if ~exist('subjectlist','var')        
    subjectlist = 1:18; 
end

%% Set Paths, Directories, Functions, Subjects and Fixed Parameters
% paths for spm, modico, infun and rician
if isunix
    addpath(genpath('/home/realtime/project_modico/spm12/'));
    addpath(genpath('/home/realtime/project_modico/pipeline'));    
    PROJ_DIR = '/store01_analysis/realtime/edin15T/';
else
    %addpath(genpath('H:\HETZER\mrdata\MODICO\script_modico_20151028/\'));
    addpath(genpath('e:\Andi\pipeline'));
    addpath(genpath('C:/spm12/'));
    %PROJ_DIR = 'H:/HETZER/mrdata/MODICO/DATA';
    PROJ_DIR = 'Y:\stefanh\MRDATA\MODICOISMRM\3T';
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

%subjectlist = 12;

Asubject_cell = {
{'MMRE-brain-Edin-AF-1-5T-2015-01-21_20150121-161216',2,4,8,10,[30,40,50],20,15}
{'MMRE-brainedin-AK-1-5T-20150427_20150427-140826',2,3,5,7,[30,40,50],20,15}
{'MMRE-brainedin-1-5T-AR-20150427_20150427-163927',2,3,	5,7,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-BG-20150515_20150515-134350',2,3,5,7,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-BS-20150722_20150722-112215',2,3,5,7,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-DS-2015-01-16_20150116-204027',2,4,8,10,[30,40,50],20,15}
{'MMRE-brain-edin-FS-1-5T-2015-03-03_20150303-173116',2,3,5,9,[30,40,50],20,15}
{'MMRE-brainedin-1-5T-HS-20150427_20150427-170204',2,3,5,7,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-HT-2015-01-16_20150116-104358',2,4,6,8,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-IS-2015-01-29_20150129-160033',3,8,10,12,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-JB-2015-01-29_20150129-153622',2,7,9,11,[30,40,50],20,15}
%{'MMRE-brain-edin-JD-2015-03-03_20150303-175444',2,3,5,	7,[30,40,50],20,15}
{'MMRE-brain-Edin-JG-1-5T-2015-01-21_20150121-154615',2,4,6,8,[30,40,50],20,15}
{'MMRE-brainedin-1-5T-JH-20150427_20150427-161707',2,3,	5,7,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-HaJ-20150205_20150205-160443',2,11,9,7,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-OB-20150205_20150205-172153',2,3,5,7,[30,40,50],20,15}
{'MMRE-brain-edin-RL-1-5T_20150907-182401',2,3,5,7,[30,40,50],20,15}
{'MMRE-brain-edin-1-5T-SH-2015-01-15_20150115-180610',2,5,7,9,[30,40,50],20,15}
{'MMRE-brain-edin-SS-1-5T-2015-03-03_20150303-170041',2,3,5,7,[30,40,50],20,15}
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

%class_processmodico.clean_data(PROJ_DIR,Asubject,subjectlist);
%wrapper_processmodico(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing,modicomod,[2 2 2]);

class_analysemodico.plotoverview_MNI(PROJ_DIR,Asubject_cell);
class_analysemodico.plotoverview_EPI(PROJ_DIR,Asubject_cell);

% class_modicoismrm.moveima2SCAN_SUB(PROJ_DIR,Asubject,subjectlist);
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


%class_modicoismrm.sub_norm_epi2mni(PROJ_DIR,Asubject,subjectlist,[2 2 2]);

%class_modico.combine_3D_PARA_segMRE(PROJ_DIR,Asubject_struct,subjectlist)
%class_modico.combine_3D_maskseg(PROJ_DIR,Asubject_struct,subjectlist);
%class_modico.plot_myfield_fieldMAGRL(PROJ_DIR,Asubject_struct,subjectlist);



end
