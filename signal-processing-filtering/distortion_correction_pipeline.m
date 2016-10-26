function [magm_orig, phase_orig_vol, magm_moco, phase_moco_vol] = distortion_correction_pipeline(acq_info)
% environment

PROJ_DIR = acq_info.path
TOPUP_PARAM_PATH = ('/home/ericbarnhill/Documents/MATLAB/MATLABMRE/project_modico/pipeline/topup_param.txt');

DATA_SUB = fullfile(PROJ_DIR);
SCAN_SUB = fullfile(DATA_SUB,'SCAN');
ANA_SUB  = fullfile(DATA_SUB,'ANA');
NII_SUB  = fullfile(DATA_SUB,'NII');
RAWN_SUB = fullfile(DATA_SUB,'RAWN');
MOCO_SUB = fullfile(DATA_SUB,'MODICO');
ORIG_SUB = fullfile(DATA_SUB, 'ORIG');

if ~exist(SCAN_SUB,'dir'), mkdir(SCAN_SUB); end
if ~exist(NII_SUB,'dir'), mkdir(NII_SUB); end
if ~exist(ANA_SUB,'dir'), mkdir(ANA_SUB); end
if ~exist(RAWN_SUB,'dir'), mkdir(RAWN_SUB); end
if ~exist(MOCO_SUB,'dir'), mkdir(MOCO_SUB); end
if ~exist(ORIG_SUB,'dir'), mkdir(ORIG_SUB); end

mag_series = acq_info.magnitude;
phase_series = acq_info.phase;
mprage_series = acq_info.t1;

cd(PROJ_DIR)
if exist('*.ima')
	movefile(['*',acq_info.file_extension], SCAN_SUB);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% distortion correction
 NdicoRL = acq_info.fieldmap(1);
 NdicoLR = acq_info.fieldmap(2);

dRL_dico_ma = ['^' num2str(NdicoRL,'% 04.f') '_.*'];
dLR_dico_ma = ['^' num2str(NdicoLR,'% 04.f') '_.*'];
% filename with path => 2 magnitude files
fdRL_dico_ma = spm_select('FPList',SCAN_SUB,dRL_dico_ma);
fdLR_dico_ma = spm_select('FPList',SCAN_SUB,dLR_dico_ma);

cd(RAWN_SUB);

% Select DICOM files, convert and rename
% Files for Distortion correction (taken from separate 10-seconds scan)

hdr = spm_dicom_headers(fdRL_dico_ma);
fRL_dico_ma = spm_dicom_convert(hdr,'all','flat','nii');
V = spm_vol(fRL_dico_ma.files{1,1});
Y = spm_read_vols(V);
V.dt = [4 0];
V.fname = fullfile(RAWN_SUB,'RL_dico_ma.nii');
spm_write_vol(V,Y);

hdr = spm_dicom_headers(fdLR_dico_ma);
fLR_dico_ma = spm_dicom_convert(hdr,'all','flat','nii');
V = spm_vol(fLR_dico_ma.files{1,1});
Y = spm_read_vols(V);
V.dt = [4 0];
V.fname = fullfile(RAWN_SUB,'LR_dico_ma.nii');
spm_write_vol(V,Y);

delete('f*');

% from modico_topup

disp('Preparing data for distortion correction via TOPUP ...');
!gunzip -f *.gz
system('fsl5.0-fslmerge -t RLLR RL_dico_ma.nii LR_dico_ma.nii');
!gunzip -f *.gz
tic	
if ~exist('my_field.nii','file')
    system(['fsl5.0-topup --imain=RLLR --datain=', TOPUP_PARAM_PATH, ' --config=b02b0.cnf --out=my_topup_results --fout=my_field --iout=uRLLR']);
    !gunzip -f *.gz
end
toc
disp('dico prep finished');

% end DICO
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Smarttrigger richtig, aktuell MEG
cd(SCAN_SUB);
names = dir('*.ima');
SER = zeros(size(names,1),2);
inc=0;
for k=1:length(names)
    %         disp('*');
    inc=inc+1;
    if isdicom(names(k).name)
        inf=dicominfo(deblank(names(k).name));
        SER(inc,1)=inf.SeriesNumber;
        SER(inc,2)=inf.InstanceNumber;
    end
end

[SER,I]=sortrows(SER,[1 2]);
tmp=SER(:,1) == mag_series(1) & SER(:,2) == 1;
w=dicomread(names(I(tmp)).name);
si=size(w);

% Werte
inf2 = dicominfo(names(I(tmp)).name);
%pixelSpacing_and_SliceThickness = [inf2.PixelSpacing' inf2.SliceThickness];
%xyPixelSpacing = inf2.PixelSpacing';
%SliceThickness = inf2.SliceThickness;

%% Mprage
TMP1 = '';
TMP2 = '';
inc_ser=0;
for kser=mprage_series
    inc=0;
    for kf=1:sum(SER(:,1)==mprage_series(inc+1)) %Nf=number of freq.
        inc_ser=inc_ser+1;
        inc=inc+1;
        tmp=SER(:,1) == kser & SER(:,2) == inc;
        TMP2 = fullfile(SCAN_SUB,names(I(tmp)).name);
        TMP1 = strvcat(TMP1,TMP2);
    end
end
fmprage = TMP1;

%% mag_series
TMP1 = '';
TMP2 = '';
inc_ser=0;
for kser=mag_series
    inc=0;
    for kf=1:sum(SER(:,1)==mag_series(inc+1)) %Nf=number of freq.
        inc_ser=inc_ser+1;
        inc=inc+1;
        tmp=SER(:,1) == kser & SER(:,2) == inc;
        TMP2 = fullfile(SCAN_SUB,names(I(tmp)).name);
        TMP1 = strvcat(TMP1,TMP2);
    end
end
fdmag_origa = TMP1;

%% phase_series
TMP1 = '';
TMP2 = '';
inc_ser=0;
for kser=phase_series
    inc=0;
    for kf=1:sum(SER(:,1)==phase_series(inc+1)) %Nf=number of freq.
        inc_ser=inc_ser+1;
        inc=inc+1;
        tmp=SER(:,1) == kser & SER(:,2) == inc;
        TMP2 = fullfile(SCAN_SUB,names(I(tmp)).name);
        TMP1 = strvcat(TMP1,TMP2);
    end
end
fdphase_origh = TMP1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
if ~exist(fullfile(RAWN_SUB,'MPRAGE.nii'),'file')
    %% Convert Dicom (*.ima) to 3D Nii and rename
    disp('converting MPRAGE dicom to nifti...')
    hdr = spm_dicom_headers(fmprage);
    ffmprage = spm_dicom_convert(hdr,'all','flat','nii');
    ffmprage.files = sort(ffmprage.files);
    
    for k = 1:length(ffmprage.files)
        V = spm_vol(ffmprage.files{k,1});
        Y = spm_read_vols(V);
        V.fname = fullfile(RAWN_SUB,'MPRAGE.nii');
        spm_write_vol(V,Y);
    end
    
    for k = 1:length(ffmprage.files)
        delete(ffmprage.files{k,1});
    end
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('number of dicom files: mag / phase');
disp([size(fdmag_origa,1) size(fdphase_origh,1)]);

disp('number of mprage files');
disp(size(fmprage,1));

%% Convert Dicom (*.ima) to 3D Nii and rename
if ~exist(fullfile(RAWN_SUB,'mag_origa0001.nii'),'file')
    
    cd(SCAN_SUB);
    hdr = spm_dicom_headers(fdmag_origa);
    fmag_origa = spm_dicom_convert(hdr,'all','flat','nii');
    hdr = spm_dicom_headers(fdphase_origh);
    fphase_origh = spm_dicom_convert(hdr,'all','flat','nii');
    
    fmag_origa.files = sort(fmag_origa.files); % probably unnecessary
    fphase_origh.files = sort(fphase_origh.files);
    
    disp('Converting MRE data from dicom to 3D nifti...');
    if ~exist(RAWN_SUB,'dir'), mkdir(RAWN_SUB), end
    
    cd(RAWN_SUB);
    for k = 1:length(fmag_origa.files)
        
        V = spm_vol(fmag_origa.files{k,1});
        Y = spm_read_vols(V);
        V.dt = [4 0];
        V.fname = fullfile(RAWN_SUB,['mag_origa' sprintf('%0*d',4,k) '.nii']);
        spm_write_vol(V,Y);
        
        if (k == 1)
            V.fname = fullfile(RAWN_SUB,'tmpfirstmag_origa.nii'); % Check ob bereits importiert??
            spm_write_vol(V,Y);
        end
        
        V = spm_vol(fphase_origh.files{k,1});
        Y = spm_read_vols(V);
        V.dt = [4 0];
        V.fname = fullfile(RAWN_SUB,['phase_origh' sprintf('%0*d',4,k) '.nii']);
        spm_write_vol(V,Y);
    end
    
    % Delete old niftis (@SCAN)
    for k = 1:length(fmag_origa.files)
        delete(fmag_origa.files{k,1});
    end
    cd(SCAN_SUB);
    delete('s*');
    delete('f*');
    
end
cd(RAWN_SUB);

if ~exist(fullfile(RAWN_SUB,'mag_orig_4D.nii'),'file');
    disp('Converting 3D nifti to 4D...');
    clear listebatch liste_ma liste_ph
    spm('defaults','fmri');
    spm_jobman('initcfg');
    liste_ma = spm_select('FPList',RAWN_SUB,'^mag_origa.*\.nii$');
    liste_ph = spm_select('FPList',RAWN_SUB,'^phase_origh.*\.nii$');
    clear f_ma; for nf_ma = 1:size(liste_ma,1), f_ma{1,nf_ma} = liste_ma(nf_ma,:); end;
    clear f_ph; for nf_ph = 1:size(liste_ph,1), f_ph{1,nf_ph} = liste_ph(nf_ph,:); end;
    listebatch{1}.spm.util.cat.vols = f_ma';
    listebatch{1}.spm.util.cat.name = 'mag_orig_4D.nii';
    listebatch{1}.spm.util.cat.dtype = 4;
    listebatch{2}.spm.util.cat.vols = f_ph';
    listebatch{2}.spm.util.cat.name = 'phase_orig_4D.nii';
    listebatch{2}.spm.util.cat.dtype = 4;
    spm_jobman('run',listebatch);
end


% modico_calc_origmoco

cd(RAWN_SUB);
modico =0;

% Collect MRE files after import
fmag_origa  = spm_select('FPList',RAWN_SUB,'^mag_origa.*\.nii$');
fphase_origh  = spm_select('FPList',RAWN_SUB,'^phase_origh.*\.nii$');

%% LR / RL filename  must have the same number of strings

    disp(['size array (fmag_origa): ' int2str(size(fmag_origa))]);


ff = fmag_origa;


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
disp(['Number of dyn files: ' int2str(size(fmag_origa,1))]);

% Loop over 3D-dynseries (?? first pictures static reference scan...)
for k = 1:size(fmag_origa,1)
    
    V_ma = spm_vol(fmag_origa(k,:));    % mag header realigned to first
    Y_ma = spm_read_vols(V_ma);
    
    if k == 1 % unchanged mag header (used later for writing ABSG.nii and M for correg)
        if modico > 0
            % dico: first scan from fRL_dico_ma
            V_ma_orig = spm_vol(fRL_dico_ma(1,:));
        else
            % moco only: first scan from fmag_origa
            V_ma_orig = V_ma;
        end
        V_ma1 = V_ma_orig;
        V_ma1.fname = 'MA_first.nii';
        Y_ma1 = spm_read_vols(V_ma_orig);
        spm_write_vol(V_ma1,Y_ma1);
    end
    
    V_ph = spm_vol(fphase_origh(k,:)); % unchanged pha header
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
merge_reim(RAWN_SUB,'RL')

disp('dico start');
tic
modico_calc_dicomodico(RAWN_SUB,TOPUP_PARAM_PATH )
toc
disp('dico finished');


% delete 3d nifti
delete('RL_dyn_im*.nii'); % header changed (estimation)
delete('RL_dyn_re*.nii'); % header changed (estimation)
delete('rRL_dyn_im*.nii');
delete('rRL_dyn_re*.nii');

delete('mag_origa*.nii');


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

% mredata

disp('mdev MRE data...');

    cd(DATA_SUB);
     
    % Convert Re + Im to Ph + Ma and copy to MODICO
    disp('Converting Re + Im images to Ph + Ma...');
    if ~exist(fullfile(MOCO_SUB,'rmag_orig_4D.nii'),'file')
        convert_ri2pm(RAWN_SUB,MOCO_SUB,'urRL');
        convert_ri2pm(RAWN_SUB,ORIG_SUB,'uRL');
    end
    
  
orig_prefix = 'uRL';
moco_prefix = 'urRL';

mag_orig  = spm_select('FPList',fullfile(ORIG_SUB),['^' orig_prefix '_dyn_m_4D.nii$']); % Dateiliste mit Pfad
phase_orig  = spm_select('FPList',fullfile(ORIG_SUB),['^' orig_prefix '_dyn_p_4D.nii$']);

mag_moco  = spm_select('FPList',fullfile(MOCO_SUB),['^' moco_prefix '_dyn_m_4D.nii$']); % Dateiliste mit Pfad
phase_moco  = spm_select('FPList',fullfile(MOCO_SUB),['^' moco_prefix '_dyn_p_4D.nii$']);

%% collect and evaluate
mag_orig_vol = spm_read_vols(spm_vol(mag_orig));
phase_orig_vol = spm_read_vols(spm_vol(phase_orig));

mag_moco_vol = spm_read_vols(spm_vol(mag_moco));
phase_moco_vol = spm_read_vols(spm_vol(phase_moco));

disp('size: mag/phase-block');
disp(size(mag_moco_vol));

magm_orig = mean(mag_orig_vol,4);
phase_orig_vol  = phase_orig_vol/4096*pi;

magm_moco = mean(mag_moco_vol,4);
phase_moco_vol  = phase_moco_vol/4096*pi;

disp(['[min max] (phase) after scaling: [' num2str(min(phase_moco_vol(:)),3) ' ' num2str(max(phase_moco_vol(:)),3) ']']);

