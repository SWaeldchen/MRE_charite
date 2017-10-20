function modico_import3(Asubject,modico,SCAN_SUB,RAWN_SUB)
disp('#### modico_import3 ####');
%% import mre data:
% input: raw dicom files @ SCAN
% output: 3D & 4D MRE nifti files

disp('Ser: dynma');
disp(Asubject.dynma);

Ndynma = Asubject.dynma;
Ndynph = Asubject.dynma +1;
Nmprage = Asubject.mprage;

if modico > 0
    NdicoRL = Asubject.refRL;
    NdicoLR = Asubject.refLR;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Distortion Correction

% Magnitude images for distortion correction
if (modico > 0)
    dRL_dico_ma = ['^' num2str(Asubject.refRL,'% 04.f') '_.*'];
    dLR_dico_ma = ['^' num2str(Asubject.refLR,'% 04.f') '_.*'];
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
    
    cd(RAWN_SUB);
    delete('f*');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
tmp=SER(:,1) == Ndynma(1) & SER(:,2) == 1;
w=dicomread(names(I(tmp)).name);
si=size(w);

% Werte
inf2 = dicominfo(names(I(tmp)).name);
pixelSpacing_and_SliceThickness = [inf2.PixelSpacing' inf2.SliceThickness];
xyPixelSpacing = inf2.PixelSpacing';
SliceThickness = inf2.SliceThickness;

%% Mprage
TMP1 = '';
TMP2 = '';
inc_ser=0;
for kser=Nmprage
    inc=0;
    for kf=1:sum(SER(:,1)==Nmprage(inc+1)) %Nf=number of freq.
        inc_ser=inc_ser+1;
        inc=inc+1;
        tmp=SER(:,1) == kser & SER(:,2) == inc;
        TMP2 = fullfile(SCAN_SUB,names(I(tmp)).name);
        TMP1 = strvcat(TMP1,TMP2);
    end
end
fmprage = TMP1;

%% Ndynma
TMP1 = '';
TMP2 = '';
inc_ser=0;
for kser=Ndynma
    inc=0;
    for kf=1:sum(SER(:,1)==Ndynma(inc+1)) %Nf=number of freq.
        inc_ser=inc_ser+1;
        inc=inc+1;
        tmp=SER(:,1) == kser & SER(:,2) == inc;
        TMP2 = fullfile(SCAN_SUB,names(I(tmp)).name);
        TMP1 = strvcat(TMP1,TMP2);
    end
end
fdRL_dyn_ma = TMP1;

%% Ndynph
TMP1 = '';
TMP2 = '';
inc_ser=0;
for kser=Ndynph
    inc=0;
    for kf=1:sum(SER(:,1)==Ndynph(inc+1)) %Nf=number of freq.
        inc_ser=inc_ser+1;
        inc=inc+1;
        tmp=SER(:,1) == kser & SER(:,2) == inc;
        TMP2 = fullfile(SCAN_SUB,names(I(tmp)).name);
        TMP1 = strvcat(TMP1,TMP2);
    end
end
fdRL_dyn_ph = TMP1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('number of dicom files: mag / phase');
disp([size(fdRL_dyn_ma,1) size(fdRL_dyn_ph,1)]);

disp('number of mprage files');
disp(size(fmprage,1));

%% Convert Dicom (*.ima) to 3D Nii and rename
if ~exist(fullfile(RAWN_SUB,'RL_dyn_ma0001.nii'),'file')
    
    cd(SCAN_SUB);
    hdr = spm_dicom_headers(fdRL_dyn_ma);
    fRL_dyn_ma = spm_dicom_convert(hdr,'all','flat','nii');
    hdr = spm_dicom_headers(fdRL_dyn_ph);
    fRL_dyn_ph = spm_dicom_convert(hdr,'all','flat','nii');
    
    fRL_dyn_ma.files = sort(fRL_dyn_ma.files); % probably unnecessary
    fRL_dyn_ph.files = sort(fRL_dyn_ph.files);
    
    disp('Converting MRE data from dicom to 3D nifti...');
    if ~exist(RAWN_SUB,'dir'), mkdir(RAWN_SUB), end
    
    cd(RAWN_SUB);
    for k = 1:length(fRL_dyn_ma.files)
        
        V = spm_vol(fRL_dyn_ma.files{k,1});
        Y = spm_read_vols(V);
        V.dt = [4 0];
        V.fname = fullfile(RAWN_SUB,['RL_dyn_ma' sprintf('%0*d',4,k) '.nii']);
        spm_write_vol(V,Y);
        
        if (k == 1)
            V.fname = fullfile(RAWN_SUB,'tmpfirstRL_dyn_ma.nii'); % Check ob bereits importiert??
            spm_write_vol(V,Y);
        end
        
        V = spm_vol(fRL_dyn_ph.files{k,1});
        Y = spm_read_vols(V);
        V.dt = [4 0];
        V.fname = fullfile(RAWN_SUB,['RL_dyn_ph' sprintf('%0*d',4,k) '.nii']);
        spm_write_vol(V,Y);
    end
    
    % Delete old niftis (@SCAN)
    for k = 1:length(fRL_dyn_ma.files)
        delete(fRL_dyn_ma.files{k,1});
    end
    cd(SCAN_SUB);
    delete('s*');
    delete('f*');
    
end
cd(RAWN_SUB);

if ~exist(fullfile(RAWN_SUB,'RL_dyn_m_4D.nii'),'file');
    disp('Converting 3D nifti to 4D...');
    clear listebatch liste_ma liste_ph
    spm('defaults','fmri');
    spm_jobman('initcfg');
    liste_ma = spm_select('FPList',RAWN_SUB,'^RL_dyn_ma.*\.nii$');
    liste_ph = spm_select('FPList',RAWN_SUB,'^RL_dyn_ph.*\.nii$');
    clear f_ma; for nf_ma = 1:size(liste_ma,1), f_ma{1,nf_ma} = liste_ma(nf_ma,:); end;
    clear f_ph; for nf_ph = 1:size(liste_ph,1), f_ph{1,nf_ph} = liste_ph(nf_ph,:); end;
    listebatch{1}.spm.util.cat.vols = f_ma';
    listebatch{1}.spm.util.cat.name = 'RL_dyn_m_4D.nii';
    listebatch{1}.spm.util.cat.dtype = 4;
    listebatch{2}.spm.util.cat.vols = f_ph';
    listebatch{2}.spm.util.cat.name = 'RL_dyn_p_4D.nii';
    listebatch{2}.spm.util.cat.dtype = 4;
    spm_jobman('run',listebatch);
end



end
