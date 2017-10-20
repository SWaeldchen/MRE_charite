function [res] = calc_res_rer(PROJ_DIR,Asubject,n1,n2)

for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    MAG_X(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_orig.nii')));
    MAG_X(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_moco.nii')));
    MAG_X(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_dico.nii')));
    MAG_X(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_modico.nii')));
    
    ABSG_X(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_orig.nii')));
    ABSG_X(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_moco.nii')));
    ABSG_X(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_dico.nii')));
    ABSG_X(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_modico.nii'))); 
    
    
    %% Entropy
    
    % Orig vs Moco
    BW1 = MAG_X(:,:,:,1)>200;
    BW2 = MAG_X(:,:,:,2)>200;
    BW3 = BW1.*BW2;    
    M1=MAG_X(:,:,:,1);
    TM1 = M1(M1>0);    
    NTM1 = TM1/norm(TM1);    
    M2=MAG_X(:,:,:,2).*BW3;
    TM2 = M2(M2>0);
    NTM2 = TM2/norm(TM2);    
    ENTM1 = entropy(NTM1);
    ENTM2 = entropy(NTM2);       
    M1=ABSG_X(:,:,:,1);
    TM1 = M1(M1>0);
    NTM1A = TM1/norm(TM1);
    M2=ABSG_X(:,:,:,2).*BW3;
    TM2 = M2(M2>0);
    NTM2A = TM2/norm(TM2);
    ENTM1A = entropy(NTM1A);
    ENTM2A = entropy(NTM2A);
    
    res.entropy_MAG(subj,1)=ENTM1;
    res.entropy_MAG(subj,2)=ENTM2;
    res.entropy_ABSG(subj,1)=ENTM1A;
    res.entropy_ABSG(subj,2)=ENTM2A;
    
    % Dico vs Modico
    BW1 = MAG_X(:,:,:,3)>200;
    BW2 = MAG_X(:,:,:,4)>200;
    BW3 = BW1.*BW2;    
    M3=MAG_X(:,:,:,3);
    TM3 = M3(M3>0);    
    NTM3 = TM3/norm(TM3);    
    M4=MAG_X(:,:,:,4).*BW3;
    TM4 = M4(M4>0);
    NTM4 = TM4/norm(TM4);    
    ENTM3 = entropy(NTM3);
    ENTM4 = entropy(NTM4);
    
    M3=ABSG_X(:,:,:,3);
    TM4 = M4(M4>0);
    NTM3A = TM4/norm(TM4);
    M4=ABSG_X(:,:,:,4).*BW3;
    TM4 = M4(M4>0);
    NTM4A = TM4/norm(TM4);
    ENTM3A = entropy(NTM3A);
    ENTM4A = entropy(NTM4A);
    
    res.entropy_MAG(subj,3)=ENTM3;
    res.entropy_MAG(subj,4)=ENTM4;
    res.entropy_ABSG(subj,3)=ENTM3A;
    res.entropy_ABSG(subj,4)=ENTM3A;
    
    
    
    [rer_M_orig, er_M_orig] = rer_3d(MAG_X(:,:,:,1)); % orig
    [rer_M_moco, er_M_moco] = rer_3d(MAG_X(:,:,:,2)); % moco
    [rer_M_dico, er_M_dico] = rer_3d(MAG_X(:,:,:,3)); % dico
    [rer_M_modico, er_M_modico] = rer_3d(MAG_X(:,:,:,4)); % modico
    
    [rer_A_orig2, er_A_orig2] = rer_3d_2(ABSG_X(:,:,:,1)); % orig
    [rer_A_moco2, er_A_moco2] = rer_3d_2(ABSG_X(:,:,:,2)); % moco
    [rer_A_dico2, er_A_dico2] = rer_3d_2(ABSG_X(:,:,:,3)); % dico
    [rer_A_modico2, er_A_modico2] = rer_3d_2(ABSG_X(:,:,:,4)); % modico
    
    [rer_M_orig, er_M_orig] = rer_3d(MAG_X(:,:,:,1)); % orig
    [rer_M_moco, er_M_moco] = rer_3d(MAG_X(:,:,:,2)); % moco
    [rer_M_dico, er_M_dico] = rer_3d(MAG_X(:,:,:,3)); % dico
    [rer_M_modico, er_M_modico] = rer_3d(MAG_X(:,:,:,4)); % modico
    
    [rer_A_orig2, er_A_orig2] = rer_3d_2(ABSG_X(:,:,:,1)); % orig
    [rer_A_moco2, er_A_moco2] = rer_3d_2(ABSG_X(:,:,:,2)); % moco
    [rer_A_dico2, er_A_dico2] = rer_3d_2(ABSG_X(:,:,:,3)); % dico
    [rer_A_modico2, er_A_modico2] = rer_3d_2(ABSG_X(:,:,:,4)); % modico
    
    BW1 = MAG_X(:,:,:,1)>200;
    BW2 = MAG_X(:,:,:,2)>200;
    BW12 = BW1.*BW2;    
    
    
    BW3 = MAG_X(:,:,:,3)>200;
    BW4 = MAG_X(:,:,:,4)>200;
    BW34 = BW1.*BW4;    
    
    
    res.rer_MAG1(subj,1)=median(rer_M_orig(BW12));
    res.rer_MAG1(subj,2)=median(rer_M_moco(BW12));
    res.rer_MAG1(subj,3)=median(rer_M_dico(BW12));
    res.rer_MAG1(subj,4)=median(rer_M_modico(BW12));
    res.rer_ABSG1(subj,1)=median(rer_A_orig(BW12));
    res.rer_ABSG1(subj,2)=median(rer_A_moco(BW12));
    res.rer_ABSG1(subj,3)=median(rer_A_dico(BW12));
    res.rer_ABSG1(subj,4)=median(rer_A_modico(BW12));
    
    res.rer_MAG2(subj,1)=median(rer_orig2(BW12));
    res.rer_MAG2(subj,2)=median(rer_moco2(BW12));
    res.rer_MAG2(subj,3)=median(rer_dico2(BW12));
    res.rer_MAG2(subj,4)=median(rer_modico2(BW12));
    res.rer_ABSG2(subj,1)=median(rer_A_orig2(BW12));
    res.rer_ABSG2(subj,2)=median(rer_A_moco2(BW12));
    res.rer_ABSG2(subj,3)=median(rer_A_dico2(BW12));
    res.rer_ABSG2(subj,4)=median(rer_A_modico2(BW12));
    
  
    
    
    %[rer, er] = rer_3d_2(X1_TMP);
    
    
    %plot2waves(MAG_X(:,:,:,1)>200);
    
    
   % X(:,subj) = G;
end

end