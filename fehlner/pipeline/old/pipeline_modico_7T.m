function pipeline_modico_afsh_7Tedin(subjectlist)

myCluster = parcluster('local');
myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
saveProfile(myCluster);

if ~exist('subjectlist','var')
    subjectlist = 1:18;
end

%% Set Paths, Directories, Functions, Subjects and Fixed Parameters
% paths for spm, modico, infun and rician
if isunix
    addpath(genpath('/home/stefanh/spm12/'));
    addpath(genpath('/home/stefanh/HETZER/mrdata/Andi/pipeline/'));
    PROJ_DIR = '/store01_analysis/stefanh/MRDATA/MODICOISMRM/7T/';
else
    %addpath(genpath('H:\HETZER\mrdata\MODICO\script_modico_20151028/\'));
    addpath(genpath('e:\Andi\pipeline'));
    addpath(genpath('C:/spm12/'));
    %PROJ_DIR = 'H:/HETZER/mrdata/MODICO/DATA';
    PROJ_DIR = 'e:\Andi';
end

% if (strcmp(version('-release'),'2015b'))
%     addpath(genpath('/home/andi/work/mretools/project_modico/'));
%     addpath(genpath('/opt/MATLAB/R2009a/toolbox/spm12/'));
%     addpath('/home/andi/in_fun/');
%     load('/home/andi/work/mretools/project_modico/script_modico/cmp_uh.mat');
%     PROJ_DIR = fullfile('/media','afdata','project_modico');
% end

PIC_DIR = fullfile(PROJ_DIR,'PICS');
if ~exist(PIC_DIR,'dir'), mkdir(PIC_DIR); end

disp(path);

TPMdir = fullfile(spm('Dir'),'tpm');
modico = 2;
list_process = {'orig','moco','dico','modico'};
Asubject_cell = {
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

rowHeadings={'name','mprage','refRL','refLR','dynma','dynfreqs','nslices','tesla'};

for ksub = 1:size(Asubject_cell,1)
    TMP_c2s = cell2struct(Asubject_cell{ksub}',rowHeadings,1);
    Asubject1(ksub) = TMP_c2s;
    Asubject2(ksub).dynph = Asubject1(ksub).dynma + 1;
end
Asubject = catstruct(Asubject1,Asubject2);

freqs = [30 40 50];
pixel_spacing = [1 1]/1000;

% class_modicoismrm.mredata_import(PROJ_DIR,Asubject,subjectlist,2);
% 
% class_modicoismrm.mredata_calc(PROJ_DIR,Asubject,subjectlist,2);
% 
% class_modicoismrm.mredata_ri2pm_origmoco(PROJ_DIR,Asubject,subjectlist);
% class_modicoismrm.mredata_ri2pm_dicomodico(PROJ_DIR,Asubject,subjectlist);
% 
% class_modicoismrm.mredata_mdev(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing);
% class_modicoismrm.mpragedata_import(PROJ_DIR,Asubject,subjectlist);
% 
% class_modicoismrm.mredata_copyRAWN2ANA(PROJ_DIR,Asubject,subjectlist);

class_modicoismrm.sub_segment_ana2mni(PROJ_DIR,Asubject,subjectlist);
class_modicoismrm.sub_segment_epi2ana(PROJ_DIR,Asubject,subjectlist);

class_modicoismrm.sub_create_dmyfield(PROJ_DIR,Asubject,subjectlist);
class_modicoismrm.sub_deform_ana2epi(PROJ_DIR,Asubject,subjectlist);
class_modicoismrm.sub_deform_ana2mni(PROJ_DIR,Asubject,subjectlist);

class_modicoismrm.sub_deform_epi2mni(PROJ_DIR,Asubject,subjectlist,[1 1 1]);
%class_modico.prepare_data(PROJ_DIR,Asubject_struct,subjectlist);

%class_modico.prepare_spm_segmentnorm_MRE2MNI(PROJ_DIR,Asubject_struct,subjectlist);
%class_modico.combine_3D_PARA_segMRE(PROJ_DIR,Asubject_struct,subjectlist)
%class_modico.combine_3D_maskseg(PROJ_DIR,Asubject_struct,subjectlist);
%class_modico.plot_myfield_fieldMAGRL(PROJ_DIR,Asubject_struct,subjectlist);



end
