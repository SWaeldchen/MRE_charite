function modico_mdev(MODICO_SUB,ANA_SUB,freqs,pixel_spacing,dataset)
disp('#### modico_mdev ####');
tic
% dataset = RL, rRL, urRL, uRL

cd(MODICO_SUB);
if exist([MODICO_SUB '/*.gz'],'file')
    gunzip('*.gz');
end

RL_dyn_m  = spm_select('FPList',fullfile(MODICO_SUB),['^' dataset '_dyn_m_4D.nii$']); % Dateiliste mit Pfad
RL_dyn_p  = spm_select('FPList',fullfile(MODICO_SUB),['^' dataset '_dyn_p_4D.nii$']);

disp(['string size (RL_dyn_m): ' int2str(size(RL_dyn_m))]);
V_ma = spm_vol(RL_dyn_m(1,:));    % mag header realigned to first, 4D-Struct
%NIIHEADER2 = V_ma(1);  % 3D-Struct

%f exist(fullfile(ANA_SUB,'RL_dico_ma.nii'),'file')
%    NIIHEADER = spm_vol(fullfile(ANA_SUB,'RL_dico_ma.nii'));
%else
%    NIIHEADER = spm_vol(fullfile(ANA_SUB,'tmpfirstRL_dyn_ma.nii'));
%end

%% display dataset choice
switch dataset
    case 'RL'
        dataname = 'orig';
    case 'rRL'
        dataname = 'moco';
    case 'urRL'
        dataname = 'modico';
    case 'uRL'
        dataname = 'dico';
    case 'rrRL'
        dataname = 'mocor';
end;
disp(['MRE calculations of ' dataname '...']);

%% collect and evaluate
mag = spm_read_vols(spm_vol(RL_dyn_m));
pha = spm_read_vols(spm_vol(RL_dyn_p));

disp('size: mag/phase-block');
disp(size(mag));

magm = mean(mag,4);
pha  = pha/4096*pi;

disp(['[min max] (phase) after scaling: [' num2str(min(pha(:)),3) ' ' num2str(max(pha(:)),3) ']']);

disp([size(pha,1),size(pha,2),size(pha,3),size(pha,4),size(pha,4),size(pha,4)/length(freqs)/8]);

W_wrap = reshape(pha,...
    [size(pha,1),size(pha,2),size(pha,3),8,size(pha,4)/length(freqs)/8,length(freqs)]);

[ABSG,PHI,ABSG_o,PHI_o,AMP_o] = evalmmref(W_wrap,freqs,pixel_spacing);

% save MAG
%data_save_MAG_nii(ANA_SUB,dataname,NIIHEADER,magm);

% Output: orig
%data_save_nii(ANA_SUB,dataname,NIIHEADER,ABSG_o,PHI_o,AMP_o);

% Output: _nc : noise corrected
%noisecorrected = [dataname '_nc'];
%data_save_nii(ANA_SUB,noisecorrected,NIIHEADER,ABSG,PHI,AMP_o);

data_save_Wrap(MODICO_SUB,dataset,W_wrap);

clear pha mag pha_reorder ABSG_o PHI_o ABSG PHI AMP_o magm
t=toc;
disp(['time (ap_modico_mdev): ' int2str(t)]);
end

function data_save_MAG_nii(ANA_SUB,dataname,NIIHEADER,MAG)

V_MAG = NIIHEADER;
V_MAG.fname = fullfile(ANA_SUB,['EPI_MAGm_' dataname '.nii']);
V_MAG.dt = [4 0];
spm_write_vol(V_MAG,MAG);
MAG = imrotate(MAG,90);
save(fullfile(ANA_SUB,['EPI_MAGm_' dataname '.mat']),'MAG');

end

function data_save_nii(ANA_SUB,dataname,NIIHEADER,ABSG,PHI,AMP)

V_ABSG = NIIHEADER;
V_ABSG.fname = fullfile(ANA_SUB,['EPI_ABSG_' dataname '.nii']);
V_ABSG.dt = [4 0];
spm_write_vol(V_ABSG,ABSG); % orig mean no noise correction

V_PHI = NIIHEADER;
V_PHI.fname = fullfile(ANA_SUB,['EPI_PHI_' dataname '.nii']);
V_PHI.dt = [16 0];
spm_write_vol(V_PHI,PHI);

V_AMP = NIIHEADER;
V_AMP.fname = fullfile(ANA_SUB,['EPI_AMP_' dataname '.nii']);
V_AMP.dt = [4 0];
spm_write_vol(V_AMP,AMP);

ABSG = imrotate(ABSG,90);
PHI = imrotate(PHI,90);
AMP = imrotate(AMP,90);

save(fullfile(ANA_SUB,['EPI_ABSG_' dataname '.mat']),'ABSG');
save(fullfile(ANA_SUB,['EPI_PHI_' dataname '.mat']),'PHI');
save(fullfile(ANA_SUB,['EPI_AMP_' dataname '.mat']),'AMP');
end


function data_save_Wrap(PROJ_DIR,dataname,W_wrap)
save(fullfile(PROJ_DIR,['W_wrap_' dataname '.mat']),'W_wrap');
end
