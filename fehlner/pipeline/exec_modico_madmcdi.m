function exec_modico_madmci

%% Set Paths, Directories, Functions, Subjects and Fixed Parameters
% paths for spm, modico, infun and rician
addpath(genpath('/opt/matlab/toolbox/spm12/'))
%addpath(genpath('/home/andi/work/mretools/project_modico/'));
addpath('/home/andi/work/mretools/script_madmci/');

MODE_copyima2scan = 'yes';

% assign directories
PROJ_DIR = fullfile('/media','afdata','project_madmci');

IN_DIR = '/media/andi/mnt_data2/';
PIC_DIR = '/media/afdata/project_madmci/PICS/';

% default values
pixel_spacing = [1.9 1.9]/1000;
freqs = [60 30 50 40 45 35 55];

% PROBID,MPRAGE,RLmag,LRmag,dynseriesmag,freqseries,slices,

Asubject={
    {'MRE-IGT-061_20150121-120005',2,5,7,3,freqs,16,30,2015}
    {'MRE-IGT-063_20150527-130230',0,6,8,4,freqs,16,30,2015}
    {'MRE-IGT-075_20150526-140312',0,5,7,3,freqs,16,30,2015}
    {'MRE-MAD012_20150311-125205',0,4,6,2,freqs,16,30,2015}
    {'MRE-MAD-016_20150128-121210',0,25,27,23,freqs,16,30,2015}
    {'MRE-MAD-019_20150318-123702',0,4,6,2,freqs,16,30,2015}
    {'MRE-MAD-022_20150506-135028',0,4,6,2,freqs,16,30,2015}
    {'MRE-MAD-023_20150527-123100',0,4,6,2,freqs,16,30,2015}
    {'MRE-MAD-025_20151007-124911',0,7,9,5,freqs,16,30,2015}
    {'MRE-MAD-901_20150828-103644',0,4,6,2,freqs,16,30,2015}
    {'MRE-MAD-902_20150828-103644',0,4,6,2,freqs,16,30,2015}
    {'MRE-MAD-902_20150812-124050',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-014_20150326-185125',0,6,8,4,freqs,16,30,2015}
    {'MRE-SAI-017_20150401-134211',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-018_20150526-150944',0,4,6,2,freqs,16,30,2015}
    {'SAI-019_20150807-105448',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-028_20150807-095458',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-029_20150828-092526',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-030_20150504-123954',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-031_20150603-113843',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-033_20150604-094413',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-034_20150527-144413',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-035_20150617-133946',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-036_20150617-113841',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-037_20150624-143820',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-038_20150729-123552',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-039_20150629-113748',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-040_20150716-094210',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-041_20151014-115410',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-042_20150708-110927',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-044_20150831-143240',0,4,6,2,freqs,16,30,2015}
    {'SAI-047_20150928-150426',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-051_20150814-112248',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-054_20150812-133717',0,4,6,2,freqs,16,30,2015}
    {'MRE-SAI-055_20150821-115315',0,4,6,2,freqs,16,30,2015}
    {'MRE-LOC-A-011_20150527-132949',0,5,7,3,freqs,16,30,2015}
    {'MRE-LOC-A-010_20150603-131312',0,5,7,3,freqs,16,30,2015}
    {'MRE-LOC-A-022_20150603-121124',2,5,7,3,freqs,16,30,2015}
    {'MRE-LOC-A-042_20150918-154246',0,4,6,2,freqs,16,30,2015}
    {'MRE-LOC-A-045_20150504-154132',0,4,6,2,freqs,16,30,2015}
    {'MRE-LOC-A-053_20150826-123733',0,4,6,2,freqs,16,30,2015}
    {'MRE-LOC-A-054_20150504-164136',0,4,6,2,freqs,16,30,2015}
    {'MRE-LOC-A-046_20150731-093945',0,4,6,2,freqs,16,30,2015}
    {'MRE-LOC-A-056_20150814-095708',0,5,6,3,freqs,16,30,2015}
    {'NAP-M-010_20150209-153611',13,18,20,16,freqs,16,30,2015}
    };




%% Subject Loop
for ksub = 1:size(Asubject,1)
    tic
    disp('----------------------------------');
    disp(['STARTING EVALUATION OF SUBJECT #' num2str(ksub) '...']);
    
    SUB_NAME = Asubject{ksub}{1};
    % Directories per Subject
    DATA_SUB = fullfile(PROJ_DIR,Asubject{ksub}{1});
    SCAN_SUB = fullfile(DATA_SUB,'SCAN');
    MODICO_SUB = fullfile(DATA_SUB,'MODICO');
    RAWN_SUB = fullfile(DATA_SUB,'RAWN');
    ANA_SUB = fullfile(DATA_SUB,'ANA');
    SEGNORM_SUB = fullfile(DATA_SUB,'SEGNORM');
    PERF_SUB = fullfile(DATA_SUB,'PERF');
    MOTIONANA_SUB = fullfile(DATA_SUB,'MOTIONANA');
    PICS_SUB = fullfile(DATA_SUB,'PICS');
    
    disp(SUB_NAME);
    
    % create additional directories
    if ~exist(MODICO_SUB,'dir'), mkdir(MODICO_SUB), end
    if ~exist(RAWN_SUB,'dir'), mkdir(RAWN_SUB), end
    if ~exist(ANA_SUB,'dir'), mkdir(ANA_SUB), end
    if ~exist(SCAN_SUB,'dir'), mkdir(SCAN_SUB), end
    %if ~exist(PERF_SUB,'dir'), mkdir(PERF_SUB), end
    if ~exist(SEGNORM_SUB,'dir'), mkdir(SEGNORM_SUB), end
    %if ~exist(MOTIONANA_SUB,'dir'), mkdir(MOTIONANA_SUB), end
    if ~exist(PICS_SUB,'dir'), mkdir(PICS_SUB), end
    
    ANA_O_SUB = fullfile(ANA_SUB,'orig');
    ANA_R_SUB = fullfile(ANA_SUB,'moco');
    ANA_U_SUB = fullfile(ANA_SUB,'dico');
    ANA_UR_SUB = fullfile(ANA_SUB,'modico');
    SEGNORM_O_SUB = fullfile(SEGNORM_SUB,'orig');
    SEGNORM_R_SUB = fullfile(SEGNORM_SUB,'moco');
    SEGNORM_U_SUB = fullfile(SEGNORM_SUB,'dico');
    SEGNORM_UR_SUB = fullfile(SEGNORM_SUB,'modico');
    
    if ~exist(SEGNORM_O_SUB,'dir'), mkdir(SEGNORM_O_SUB), end
    if ~exist(SEGNORM_R_SUB,'dir'), mkdir(SEGNORM_R_SUB), end
    if ~exist(SEGNORM_U_SUB,'dir'), mkdir(SEGNORM_U_SUB), end
    if ~exist(SEGNORM_UR_SUB,'dir'), mkdir(SEGNORM_UR_SUB), end
    if ~exist(ANA_O_SUB,'dir'), mkdir(ANA_O_SUB), end
    if ~exist(ANA_R_SUB,'dir'), mkdir(ANA_R_SUB), end
    if ~exist(ANA_U_SUB,'dir'), mkdir(ANA_U_SUB), end
    if ~exist(ANA_UR_SUB,'dir'), mkdir(ANA_UR_SUB), end
    
    % move scan images to /SCAN/
    if (strcmp(MODE_copyima2scan,'yes'))
        
        A_tmp = dir(SCAN_SUB);
        if length({A_tmp.name}) < 3
            DIR_IMPORT = fullfile(IN_DIR,['datenoutput_' int2str(Asubject{ksub}{9})],cell2str(Asubject{ksub}(1)));
            disp(DIR_IMPORT);
            cd(DIR_IMPORT);
            [a1,a2] = system('ls *.ima');
            [s,mess,messid] = copyfile('*.ima',SCAN_SUB);
        end
    end
    
    if (Asubject{ksub}{3} == 0)
        modico = 0;
    else
        modico = 2;
    end
    
    %% import mre data: raw dicom files -> 4D MRE nifti files
    
    disp('Importing MRE data...');
    if ~exist(fullfile(RAWN_SUB,'tmpfirstRL_dyn_ma.nii'),'file')
        ap_modico_import(Asubject{ksub,:},modico,SCAN_SUB,RAWN_SUB);
    else
        disp('...4D MRE data existed already.')
    end
    
    
    %% execute motion and distortion correction (modico)
    
    disp('Executing motion & distortion correction...');
    if ~exist(fullfile(MODICO_SUB,'rRL_dyn_m_4D.nii'),'file')
        ap_modico_calc(RAWN_SUB,MODICO_SUB,modico,SUB_NAME);
    else
        disp('...modico done already');
    end
    
    if modico > 0
        copyfile(fullfile(RAWN_SUB,'my_field.nii'),fullfile(ANA_SUB));
    end
    
    disp('Executing MRE calculations...');
    if ~exist(fullfile(ANA_SUB,'ABSG_moco.nii'),'file');
        % inversion, noise correction, W_Wrap, data saving
        dataset = 'RL';
        ap_modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset);
        dataset = 'rRL';
        ap_modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset);
    else
        disp('...MRE calculations done already');
    end
    
    if ~exist(fullfile(ANA_SUB,'ABSG_modico.nii'),'file');
        if modico > 0
            dataset = 'uRL';
            ap_modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset);
            dataset = 'urRL';
            ap_modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset);
        end
    else
        disp('...MRE calculations done already');
    end

    af_plot_APM_ommd(PIC_DIR,ANA_SUB,SUB_NAME);

    
    timeu(ksub) = toc;
    disp(timeu(ksub));
end
end

