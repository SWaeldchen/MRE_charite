function ap_spm_import_mprage(SCAN_SUB,ANA_SUB,Asubject)
%% IMPORT MPRAGE
% INPUT: .ima MPRAGE files @ SCAN_SUB
% OUTPUT: mprage.nii @ ANA_SUB

% Asubject{1} Name
% Asubject(2) Seriennummer mprage

% select mprage dicom files
dat_mprage = ['^' num2str(Asubject.mprage,'% 04.f') '_.*'];
%dat_mprage = ['^' num2str(Asubject.mprage) '_.*'];
dicom_mprage = spm_select('FPList',SCAN_SUB,dat_mprage);

cd(SCAN_SUB);

%% Convert Dicom (*.ima) to 3D Nii and rename
disp('converting MPRAGE dicom to nifti...')
hdr = spm_dicom_headers(dicom_mprage);
fRL_dyn_ma = spm_dicom_convert(hdr,'all','flat','nii');
fRL_dyn_ma.files = sort(fRL_dyn_ma.files);

for k = 1:length(fRL_dyn_ma.files)
    V = spm_vol(fRL_dyn_ma.files{k,1});
    Y = spm_read_vols(V);
    V.fname = fullfile(ANA_SUB,'MPRAGE.nii');
    spm_write_vol(V,Y);
end

% delete temporary files
for k = 1:length(fRL_dyn_ma.files)
    delete(fRL_dyn_ma.files{k,1});
end

end
