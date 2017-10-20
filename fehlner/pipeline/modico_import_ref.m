function modico_import_ref(Asubject,modico,SCAN_SUB,RAWN_SUB)
disp('#### modico_import ####');

% Magnitude images for distortion correction
if (modico > 0)
    dRL_dico_ma = ['^' num2str(Asubject.refRL,'% 04.f') '_.*'];
    dLR_dico_ma = ['^' num2str(Asubject.refLR,'% 04.f') '_.*'];
    % filename with path => 2 magnitude files
    fdRL_dico_ma = spm_select('FPList',SCAN_SUB,dRL_dico_ma);
    fdLR_dico_ma = spm_select('FPList',SCAN_SUB,dLR_dico_ma);
end

if (modico > 0)
    
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
    %delete('f*');
end




end