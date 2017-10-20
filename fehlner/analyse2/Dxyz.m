function [B0s, Ms, D1x, D1y, D1z, D2x, D2y, D2z] = Dxyz(PROJ_DATA,Asubject)

for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    B0 = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','myfield.nii')));
    M =  spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','EPI_MAGm_dico.nii')));
    
    % EPI_iy_orig / wx_Twarp_orig
    Y1x = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','wx_Twarp_orig_epi2ana.nii,1,1')));
    Y1y = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','wy_Twarp_orig_epi2ana.nii,1,1')));
    Y1z = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','wz_Twarp_orig_epi2ana.nii,1,1')));
    
    Y2x = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','wx_Twarp_dico_epi2ana.nii,1,1')));
    Y2y = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','wy_Twarp_dico_epi2ana.nii,1,1')));
    Y2z = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA','wz_Twarp_dico_epi2ana.nii,1,1')));
    
    B0s(:,:,:,subj) = B0;
    
%     Dxs(:,:,:,subj) = Y1x-Y2x;
%     Dys(:,:,:,subj) = Y1y-Y2y;
%     Dzs(:,:,:,subj) = Y1z-Y2z;
    
    D1x(:,:,:,subj) = Y1x;
    D1y(:,:,:,subj) = Y1y;
    D1z(:,:,:,subj) = Y1z;
    
    D2x(:,:,:,subj) = Y2x;
    D2y(:,:,:,subj) = Y2y;
    D2z(:,:,:,subj) = Y2z;
    
    Ms(:,:,:,subj)  = M;
    
end

% B0 = mean(B0s,4);
% Dx = mean(Dxs,4);
% Dy = mean(Dys,4);
% Dz = mean(Dzs,4);
% 
% figure;for s=1:size(Dx,3), imagesc(cat(2, B0(:,:,s), Dx(:,:,s), Dy(:,:,s), Dz(:,:,s))), colormap(gray), truesize, pause(0.2), end

% figure;for s=1:40, imagesc(cat(2, B0(:,:,s)/15, dDx(:,:,s), dDy(:,:,s), dDz(:,:,s)), [-10 10]), colormap(gray), truesize, pause(0.2), end
% 
% figure; 
% for k=2:14, s=5,
%     imagesc(cat(2, B0s(:,:,s,k)/15, dDxs(:,:,s,k), dDys(:,:,s,k), dDzs(:,:,s,k)), [-10 10])
%     colormap(gray)
%     truesize
%     pause(1.2)
% end
