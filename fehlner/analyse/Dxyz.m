function [B0, Dx, Dy, Dz] = Dxyz(Asubject)

for subj = 1:numel(Asubject)
    
    SUBJ_DIR = Asubject{subj}{1}
    
    B0 = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\my_field.nii']));
    
    % EPI_iy_orig / wx_Twarp_orig
%     Y1x = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\EPI_iy_orig.nii,1,1']));
%     Y1y = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\EPI_iy_orig.nii,1,2']));
%     Y1z = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\EPI_iy_orig.nii,1,3']));
%     
%     Y2x = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\EPI_iy_dico.nii,1,1']));
%     Y2y = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\EPI_iy_dico.nii,1,2']));
%     Y2z = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\EPI_iy_dico.nii,1,3']));
    Y1x = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wx_Twarp_orig.nii,1,1']));
    Y1y = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wy_Twarp_orig.nii,1,1']));
    Y1z = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wz_Twarp_orig.nii,1,1']));
    
    Y2x = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wx_Twarp_dico.nii,1,1']));
    Y2y = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wy_Twarp_dico.nii,1,1']));
    Y2z = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wz_Twarp_dico.nii,1,1']));
    
    B0s(:,:,:,subj) = B0;
    
    Dxs(:,:,:,subj) = Y1x-Y2x;
    Dys(:,:,:,subj) = Y1y-Y2y;
    Dzs(:,:,:,subj) = Y1z-Y2z;
    
end

B0 = mean(B0s,4);
Dx = mean(Dxs,4);
Dy = mean(Dys,4);
Dz = mean(Dzs,4);

figure;for s=1:size(Dx,3), imagesc(cat(2, B0(:,:,s), Dx(:,:,s), Dy(:,:,s), Dz(:,:,s))), colormap(gray), truesize, pause(0.2), end

% figure;for s=1:40, imagesc(cat(2, B0(:,:,s)/15, dDx(:,:,s), dDy(:,:,s), dDz(:,:,s)), [-10 10]), colormap(gray), truesize, pause(0.2), end
% 
% figure; 
% for k=2:14, s=5,
%     imagesc(cat(2, B0s(:,:,s,k)/15, dDxs(:,:,s,k), dDys(:,:,s,k), dDzs(:,:,s,k)), [-10 10])
%     colormap(gray)
%     truesize
%     pause(1.2)
% end
