function [Mask] = CreateMask(PROJ_DIR,Asubject)

for subj = 1:numel(Asubject)
    
    SUBJ_DIR = Asubject{subj}{1};
    
    X1  = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_AMP_orig.nii')));
    X2  = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_AMP_moco.nii')));
    X3  = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_AMP_dico.nii')));
    X4  = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_AMP_modico.nii')));
    
    %X1 = spm_read_vols(spm_vol(['H:\HETZER\mrdata\MODICO\DATA\' SUBJ_DIR '\ANA\AMP_orig.nii']));
    %X2 = spm_read_vols(spm_vol(['H:\HETZER\mrdata\MODICO\DATA\' SUBJ_DIR '\ANA\AMP_moco.nii']));
    %X3 = spm_read_vols(spm_vol(['H:\HETZER\mrdata\MODICO\DATA\' SUBJ_DIR '\ANA\AMP_dico.nii']));
    %X4 = spm_read_vols(spm_vol(['H:\HETZER\mrdata\MODICO\DATA\' SUBJ_DIR '\ANA\AMP_modico.nii']));
    
    M(:,:,:,subj) = (0<(X1.*X2.*X3.*X4));
    
    M1(:,:,:,subj) = X1;
    M2(:,:,:,subj) = X2;
    M3(:,:,:,subj) = X3;
    M4(:,:,:,subj) = X4;
    
end

Mask = sum(M,4);
M1m = mean(M1,4);
M2m = mean(M2,4);
M3m = mean(M3,4);
M4m = mean(M4,4);
M1s = std(M1,[],4);
M2s = std(M2,[],4);
M3s = std(M3,[],4);
M4s = std(M4,[],4);

save('Mask.mat','Mask','M1m','M2m','M3m','M4m','M1s','M2s','M3s','M4s');

end