function modico_calc(PROJ_DIR,RAWN_SUB,MODICO_SUB,modico,SUB_NAME,RESMOD)
disp('#### modico_calc ####');
%% Collect files ...
tic
cd(RAWN_SUB);
if ~isunix
    copyfile(fullfile(PROJ_DIR,'topup_param.txt'),RAWN_SUB);
else
    
    !cp ../../topup_param.txt .
    %copyfile('/home/andi/work/mretools/project_modico/script_modico/topup_param.txt',RAWN_SUB);
end

% Collect MRE files after import
fRL_dyn_ma  = spm_select('FPList',RAWN_SUB,'^RL_dyn_ma.*\.nii$');
fRL_dyn_ph  = spm_select('FPList',RAWN_SUB,'^RL_dyn_ph.*\.nii$');

% Collect DICO files (RL and LR for distortion correction, taken from separate 10-seconds scan)
if modico > 0
    fRL_dico_ma = spm_select('FPList',RAWN_SUB,'^RL_dico_ma.nii$'); % Add ^ in order to prevent for mean, rRL, urRL
    fLR_dico_ma = spm_select('FPList',RAWN_SUB,'^LR_dico_ma.nii$');
end

% Research-mode => Modico-Study 
% => first image for orig, moco, modico in myfield(topupfield)-space
if nargin > 5
    ff = cat(1,[fRL_dico_ma '   '],fRL_dyn_ma);
    changenii_first_header = 'yes';
end

% Create IM / RE 4D before realigment-Estimate
convert_pm2ri(RAWN_SUB,'RL',changenii_first_header); % needed for uRL
% => Distortion correction without realignment
% => erzeugt RL_dyn_i_4D und RL_dyn_r_4D
% => gerade nicht verwendet

%% LR / RL filename  must have the same number of strings
if modico > 0
    disp('fRL_dico_ma fLR_dico_ma fRL_dyn_ma'); % Size of filenamearray
    disp([size(fRL_dico_ma) size(fLR_dico_ma) size(fRL_dyn_ma)]);
else
    disp(['size array (fRL_dyn_ma): ' int2str(size(fRL_dyn_ma))]);
end

% Standard
% Falls Entzerrungkorrektur Datei vor Zeitreihe hängen
% Ziel: Daten im Raum der aufgenommenen Fieldmap korrigieren
if modico > 0,
    ff = cat(1,[fRL_dico_ma '   '],fRL_dyn_ma);
else
    ff = fRL_dyn_ma;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estimate of realignment parameter
%% => Changes Header-Information in 3D-files
disp(['Number of Magnitude (dyn series) files: ' int2str(size(ff,1))]);

clear f; for nf = 1:size(ff,1), f{nf} = ff(nf,:); end;
clear matlabbatch
spm('defaults','fmri');
spm_jobman('initcfg');
matlabbatch{1}.spm.spatial.realign.estimate.data = {f'};
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;   % Register to first
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [1 0 0];
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
spm_jobman('run',matlabbatch);

disp('f');
disp(size(f));
disp('ff');
disp(size(ff));

clear f nf ff matlabbatch

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Write realignment parameters from mag-header to Re+Im
disp('Creating Re + Im images...');
disp(['Number of dyn files: ' int2str(size(fRL_dyn_ma,1))]);

% Loop over 3D-dynseries (?? first pictures static reference scan...)
for k = 1:size(fRL_dyn_ma,1)
    
    V_ma = spm_vol(fRL_dyn_ma(k,:));    % mag header realigned to first
    Y_ma = spm_read_vols(V_ma);
    
    if k == 1 % unchanged mag header (used later for writing ABSG.nii and M for correg)
        if modico > 0
            % dico: first scan from fRL_dico_ma
            V_ma_orig = spm_vol(fRL_dico_ma(1,:));
        else
            % moco only: first scan from fRL_dyn_ma
            V_ma_orig = V_ma;
        end
        V_ma1 = V_ma_orig;
        V_ma1.fname = 'MA_first.nii';
        Y_ma1 = spm_read_vols(V_ma_orig);
        spm_write_vol(V_ma1,Y_ma1);
    end
    
    V_ph = spm_vol(fRL_dyn_ph(k,:)); % unchanged pha header
    V_ph.mat = V_ma.mat;             % use realignment from Magnitude for Phase (Real + Imag)
    Y_ph = spm_read_vols(V_ph);
    
    Y_complex = Y_ma .* exp(1i.*Y_ph*2*pi/(4096*2));
    
    V_re = V_ph;
    Y_re = real(Y_complex);
    V_im = V_ph;
    Y_im = imag(Y_complex);
    
    outname_dyn_re = fullfile(RAWN_SUB,['RL_dyn_re' sprintf('%0*d',4,k) '.nii']);
    V_re.fname = outname_dyn_re; % allow max 9999 images
    V_re.dt = [4 0];
    spm_write_vol(V_re,Y_re);   % use Ph header (-4096..+4096) but realignment from Ma header
    
    outname_dyn_im = fullfile(RAWN_SUB,['RL_dyn_im' sprintf('%0*d',4,k) '.nii']);
    V_im.fname = outname_dyn_im;
    V_im.dt = [4 0];
    spm_write_vol(V_im,Y_im);   % use Ph header (-4096..+4096) but realignment from Ma header
end

%% Reslice/Write Re, Im relative to Ma for Realigned
fRL_dyn_re = spm_select('FPList',RAWN_SUB,'^RL_dyn_re.*\.nii$');
fRL_dyn_im = spm_select('FPList',RAWN_SUB,'^RL_dyn_im.*\.nii$');
if modico > 0,
    ff_re = cat(1,[fRL_dico_ma '   '],fRL_dyn_re);
    ff_im = cat(1,[fRL_dico_ma '   '],fRL_dyn_im);
else
    ff_re = fRL_dyn_re;
    ff_im = fRL_dyn_im;
end
clear f_re; for nf_re = 1:size(ff_re,1), f_re{nf_re} = ff_re(nf_re,:); end; f_re=f_re';
clear f_im; for nf_im = 1:size(ff_im,1), f_im{nf_im} = ff_im(nf_im,:); end; f_im=f_im';

clear matlabbatch
spm('defaults','fmri');
spm_jobman('initcfg');
matlabbatch{1}.spm.spatial.realign.write.data = f_re;
matlabbatch{1}.spm.spatial.realign.write.roptions.which = [2 1];
matlabbatch{1}.spm.spatial.realign.write.roptions.interp = 4;
matlabbatch{1}.spm.spatial.realign.write.roptions.wrap = [1 0 0];
matlabbatch{1}.spm.spatial.realign.write.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.write.roptions.prefix = 'r';
matlabbatch{2}.spm.spatial.realign.write.data = f_im;
matlabbatch{2}.spm.spatial.realign.write.roptions.which = [2 1];
matlabbatch{2}.spm.spatial.realign.write.roptions.interp = 4;
matlabbatch{2}.spm.spatial.realign.write.roptions.wrap = [1 0 0];
matlabbatch{2}.spm.spatial.realign.write.roptions.mask = 1;
matlabbatch{2}.spm.spatial.realign.write.roptions.prefix = 'r';
spm_jobman('run',matlabbatch);


%% Zusammenfassen der Bewegungskorrigierten Im, RE
% Ausgangsdateien: 2 x 72 x '^rRL_dyn_im.*\.nii$' bzw '^rRL_dyn_re.*\.nii$'
% Zieldateien: 2 x 'rRL_dyn_i_4D.nii' bzw 'rRL_dyn_r_4D.nii'
merge_reim(RAWN_SUB,'rRL')
delete('RL_dyn_im*.nii'); % header changed (estimation)
delete('RL_dyn_re*.nii'); % header changed (estimation)
delete('rRL_dyn_im*.nii');
delete('rRL_dyn_re*.nii');


if modico > 0
    % Topup => for rRL
    do_topup(RAWN_SUB,'rRL',SUB_NAME); % => modico 4
    % Topup => for RL
    if modico == 2
        do_topup(RAWN_SUB,'RL',SUB_NAME); % => dico 2
    end
end

cd(RAWN_SUB);

tmpA = dir('*.gz');
if ~isempty(tmpA)
    tmpdat = gunzip('*.gz');
    if ~isempty(tmpdat)
        for k = 1:length(tmpdat)
            delete([tmpdat{k} '.gz']);
        end
    end
end


% Convert Re + Im to Ph + Ma and copy to MODICO
disp('Converting Re + Im images to Ph + Ma...');
convert_ri2pm(RAWN_SUB,MODICO_SUB,'RL');
convert_ri2pm(RAWN_SUB,MODICO_SUB,'rRL');

if modico > 0
    convert_ri2pm(RAWN_SUB,MODICO_SUB,'urRL');
end

if modico > 1, 
    convert_ri2pm(RAWN_SUB,MODICO_SUB,'uRL');
end

t = toc;
disp(['time (modico_calc): ' int2str(t)]);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function convert_ri2pm(RAWN_SUB,MODICO_SUB,DATstr)
% convert to pm and copy to MODICO_SUB
cd(RAWN_SUB);

list_dyn_re = spm_select('FPList',RAWN_SUB,['^' DATstr '_dyn_r_4D.nii$']);
list_dyn_im = spm_select('FPList',RAWN_SUB,['^' DATstr '_dyn_i_4D.nii$']);

DATA_re = spm_read_vols(spm_vol(list_dyn_re));
DATA_im = spm_read_vols(spm_vol(list_dyn_im));
DATA_ma = abs(DATA_re + 1i*DATA_im);
DATA_ph = angle(DATA_re + 1i*DATA_im)/pi*4096;

for k = 1:size(DATA_ph,4)
    V_ma_tmp = spm_vol(list_dyn_re);
    V_ma = V_ma_tmp(1);
    V_ma.fname = [DATstr '_dyn_ma' sprintf('%0*d',4,k) '.nii'];
    spm_write_vol(V_ma,DATA_ma(:,:,:,k));
    
    V_ph_tmp = spm_vol(list_dyn_re);
    V_ph = V_ph_tmp(1);
    V_ph.fname = [DATstr '_dyn_ph' sprintf('%0*d',4,k) '.nii'];
    spm_write_vol(V_ph,DATA_ph(:,:,:,k));
end

%% Merge corrected Ma + Ph niftis...;
merge_maph(RAWN_SUB,DATstr);
cd(RAWN_SUB);

tmpA = dir('*.gz');
if ~isempty(tmpA)
    tmpdat = gunzip('*.gz');
    disp(tmpdat);
    if ~isempty(tmpdat)
        for k = 1:length(tmpdat)
            delete([tmpdat{k} '.gz']);
        end
    end
end

if strcmp(DATstr,'rRL') || strcmp(DATstr,'urRL') || strcmp(DATstr,'uRL')
    delete([DATstr '_dyn_ma*.nii']);
    delete([DATstr '_dyn_ph*.nii']);
end

movefile(fullfile(RAWN_SUB,[DATstr '_dyn_m_4D.nii']),MODICO_SUB);
movefile(fullfile(RAWN_SUB,[DATstr '_dyn_p_4D.nii']),MODICO_SUB);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function do_topup(RAWN_SUB,DATstr,SUB_NAME)
%% Distortion Correction via TOPUP
disp('Executing TOPUP distortion correction...');
if ~isunix
    cd('C:\Users\win7admin\Desktop\MREPERF');
    fid = fopen('topupscript.sh','w');
    %Send Linux to DATA_SUB\RAWN
    topupline1 = ['cd ../../mnt/hgfs/MREPERF/' SUB_NAME '/RAWN'];
    fprintf(fid, '%s\n', topupline1);
    %Set FSL Path
    topupline2 = 'export FSLDIR=/usr/local/fsl';
    fprintf(fid, '%s\n', topupline2);
    topupline3 = '. ${FSLDIR}/etc/fslconf/fsl.sh';
    fprintf(fid, '%s\n', topupline3);
    topupline4 = 'PATH=$PATH:/usr/local/fsl/bin/';
    fprintf(fid, '%s\n', topupline4);
    topupline5 = 'export $PATH';
    fprintf(fid, '%s\n', topupline5);
    %Preparing data for distortion correction via TOPUP
    topupline6 = 'fslmerge -t RLLR RL_dico_ma.nii LR_dico_ma.nii';
    fprintf(fid, '%s\n', topupline6);
    %Estimating distortion matrix
    topupline7 = 'topup --imain=RLLR --datain=topup_param.txt --config=b02b0.cnf --out=my_topup_results --fout=my_field --iout=uRLLR';
    fprintf(fid, '%s\n', topupline7);
    %Correcting distortions
    topupline8 = ['applytopup --imain=' DATstr '_dyn_r_4D --inindex=1 --datain=topup_param.txt --topup=my_topup_results --method=jac --interp=spline --out=u' DATstr '_dyn_r_4D'];
    fprintf(fid, '%s\n', topupline8);
    topupline9 = ['applytopup --imain=' DATstr '_dyn_i_4D --inindex=1 --datain=topup_param.txt --topup=my_topup_results --method=jac --interp=spline --out=u' DATstr '_dyn_i_4D'];
    fprintf(fid, '%s\n', topupline9);
    fclose(fid);
    
    [a1,a2]=system(['C:\Users\win7admin\Desktop\plink -v fsl@192.168.195.143 -i C:\Users\win7admin\Desktop\opensshkeys\privatekey.ppk bash /mnt/hgfs/MREPERF/topupscript.sh']);
    
else
    cd(RAWN_SUB);    
    disp('Preparing data for distortion correction via TOPUP ...');
    !gunzip -f *.gz
    system('fsl5.0-fslmerge -t RLLR RL_dico_ma.nii LR_dico_ma.nii');
    !gunzip -f *.gz
    if ~exist('my_field.nii','file')
        system('fsl5.0-topup --imain=RLLR --datain=topup_param.txt --config=b02b0.cnf --out=my_topup_results --fout=my_field --iout=uRLLR');
        !gunzip -f *.gz
    end
    
    disp('Correcting distortions...');
    system(['fsl5.0-applytopup --imain=' DATstr '_dyn_r_4D --inindex=1 --datain=topup_param.txt --topup=my_topup_results --method=jac --interp=spline --out=u' DATstr '_dyn_r_4D']);
    system(['fsl5.0-applytopup --imain=' DATstr '_dyn_i_4D --inindex=1 --datain=topup_param.txt --topup=my_topup_results --method=jac --interp=spline --out=u' DATstr '_dyn_i_4D']);
    
%     !cp my_field.nii my_field_head.nii
%     
%     disp('Distort myfield...');
%     !cp my_topup_results_fieldcoef.nii my_topup_results_fieldcoef_tmp.nii
%     head_distmy = spm_vol('my_topup_results_fieldcoef.nii');
%     Y = -spm_read_vols(head_distmy);    
%     spm_write_vol(head_distmy,Y);
%     pause(1)
%     system('fsl5.0-applytopup --imain=my_field --inindex=1 --datain=topup_param.txt --topup=my_topup_results --method=jac --interp=spline --out=dmy_field');
%     !gunzip -f *.gz
%     !mv my_topup_results_fieldcoef.nii my_topup_results_fieldcoef_inverted.nii 
%     !mv my_topup_results_fieldcoef_tmp.nii my_topup_results_fieldcoef.nii

end

end
