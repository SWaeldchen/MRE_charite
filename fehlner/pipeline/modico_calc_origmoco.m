function modico_calc_origmoco(PROJ_DIR,RAWN_SUB,MODICO_SUB,modico,SUB_NAME,RESMOD)
disp('#### modico_calc_origmoco ####');
%% Collect files ...
tic
cd(RAWN_SUB);

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
else
    ff = fRL_dyn_ma;    
    changenii_first_header = 'no';
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

disp(size(ff));
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

delete('RL_dyn_ma*.nii');

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

t = toc;
disp(['time (modico_calc): ' int2str(t)]);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

