% corr2(TPM1,average(C1)) slice-wise and B0-wise
addpath('/home/realtime/spm12');

Asubject = {
    {'MREPERF-FD_20150513-133126',7,16,18,14,[30 40 50],40,30,3,4,5,'F. Dittmann',26} % dicom mprage korrupt (nutze nii!)
    {'SHi_MREPERF_20150622',26,9,11,3,[30 40 50],40,30,15,16,17,'S. Hirsch',31}
    {'MREPERF-LM_20150624-131215',14,5,7,3,[30 40 50],40,30,11,12,13,'L. Marz',20}
    {'MREPERF-SH_20150625-145714',14,5,7,3,[30 40 50],40,30,11,12,13,'S. Hetzer',38}
    {'MREPERF-AFAndi_20150625-140247',14,5,7,3,[30 40 50],40,30,11,12,13,'A. Fehlner',29}
    {'MREPERF-TS_20150626-090422',14,5,7,3,[30 40 50],40,30,11,12,13,'T. Scheuermann',28}
    {'MREPERF-JB_20150630-110303',14,5,7,3,[30 40 50],40,30,11,12,13,'J. Braun',54}
    {'MREPERF-IS_20150630-132315',6,19,21,17,[30 40 50],40,30,3,4,5,'I. Sack',45}
    {'MREPERF-HT_20150630-114822',6,19,21,17,[30 40 50],40,30,3,4,5,'H. Tzschaetzsch',30}
    {'MREPERF-AR_20150706-095001',15,5,7,3,[30 40 50],40,30,12,13,14,'A. Ratthey',48} % seg_epi2mni falsch registriert!
    {'MREPERF-DS_20150707-164535',15,5,7,3,[30 40 50],40,30,24,13,14,'D. Schubert',56}
    {'MREPERF-TC_20150707-155729',15,5,7,3,[30 40 50],40,30,12,13,14,'T. Christofel',32}
    {'MREPERF-VG_20150707-173412',15,5,7,3,[30 40 50],40,30,12,13,14,'V. Gruendel',28}
    {'MREPERF-DG_20150708-112321',15,5,7,3,[30 40 50],40,30,12,13,14,'D. Glass',53} % seg_epi2mni falsch registriert!
    };

cd('/store01_analysis/realtime/PERF3T/');

load DATA_GMWM_MNI_sb_3T_GM60_WM60_equal.mat;
ksub=1:14;
figure; plot(mean(res.tstat_A(:,4,ksub)-res.tstat_A(:,2,ksub),3)) 
%=>
%individual
load mFD.mat;

PROJ_DATA = '/store01_analysis/realtime/PERF3T/';

for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    H = spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','MNI_myfield.nii'));
    B0_individuel(:,:,:,subj) = spm_read_vols(H);
    
end

H = spm_vol('MNI_myfield_mean.nii');
B0 = spm_read_vols(H);

% BRAIN MASK
H = spm_vol('wTPM.nii,1'); TP(:,:,:,1) = spm_read_vols(H);
H = spm_vol('wTPM.nii,2'); TP(:,:,:,2) = spm_read_vols(H);
H = spm_vol('wTPM.nii,3'); TP(:,:,:,3) = spm_read_vols(H);
BW = sum(TP,4);
BW = BW > 0.9;

for ksub = 1:size(B0_individuel,4)
for kslice = 1:size(B0_individuel,3)      
   B(kslice,ksub) = mean2(abs(squeeze(B0_individuel(:,:,kslice,ksub)).*BW(:,:,kslice)));
end
end

slc = 25:65;
figure;
for ksub = 1:size(B0_individuel,4)
    disp(['ksub' int2str(ksub)]);
    hold on
    %plot( B(slc,ksub),res.tstat_A(slc,4,ksub)-res.tstat_A(slc,1,ksub),'*');
    [tmp_r,tmp_p] = corrcoef( B(slc,ksub),res.tstat_A(slc,4,ksub)-res.tstat_A(slc,2,ksub)); % MODICO - MOCO
    %[tmp_r,tmp_p] = corrcoef( B(slc,ksub),res.tstat_A(slc,3,ksub)-res.tstat_A(slc,1,ksub)); % DICO - ORIG
    %[tmp_r,tmp_p] = corrcoef(
    %B(slc,ksub),res.dASH_A(slc,4,ksub)-res.dASH_A(slc,2,ksub));
    
    res.r(ksub) = tmp_r(1,2);
    res.p(ksub) = tmp_p(1,2);
end
[h,p,ci,stats] = ttest(atanh(res.r)); % "Fisher's z-transform of r" atanh(r) -> z-transformed r-values
%[h,p] = ttest(atanh(res.r),0,'Tail','right'); % "Fisher's z-transform of r" atanh(r) -> z-transformed r-values
disp('p-Wert');
disp(p);
disp('mean/sem von r');
disp([mean(res.r) std(res.r)/sqrt(length(res.r))]);