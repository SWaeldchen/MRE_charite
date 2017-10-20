function res = calc_res_rer(PROJ_DIR,Asubject)

for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    MAG_X1 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_orig.nii')));
    MAG_X2 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_moco.nii')));
    MAG_X3 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_dico.nii')));
    MAG_X4 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_modico.nii')));
    
    ABSG_X1 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_orig.nii')));
    ABSG_X2 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_moco.nii')));
    ABSG_X3 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_dico.nii')));
    ABSG_X4 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_modico.nii')));    
    
    [rer_M_orig, er_M_orig] = rer_3d(MAG_X1); % orig
    [rer_M_moco, er_M_moco] = rer_3d(MAG_X2); % moco
    [rer_M_dico, er_M_dico] = rer_3d(MAG_X3); % dico
    [rer_M_modico, er_M_modico] = rer_3d(MAG_X4); % modico
    
    [rer_A_orig, er_A_orig] = rer_3d(ABSG_X1); % orig
    [rer_A_moco, er_A_moco] = rer_3d(ABSG_X2); % moco
    [rer_A_dico, er_A_dico] = rer_3d(ABSG_X3); % dico
    [rer_A_modico, er_A_modico] = rer_3d(ABSG_X4); % modico
    
    [rer_M_orig2, er_M_orig2] = rer_3d_2(MAG_X1); % orig
    [rer_M_moco2, er_M_moco2] = rer_3d_2(MAG_X2); % moco
    [rer_M_dico2, er_M_dico2] = rer_3d_2(MAG_X3); % dico
    [rer_M_modico2, er_M_modico2] = rer_3d_2(MAG_X4); % modico
    
    [rer_A_orig2, er_A_orig2] = rer_3d_2(ABSG_X1); % orig
    [rer_A_moco2, er_A_moco2] = rer_3d_2(ABSG_X2); % moco
    [rer_A_dico2, er_A_dico2] = rer_3d_2(ABSG_X3); % dico
    [rer_A_modico2, er_A_modico2] = rer_3d_2(ABSG_X4); % modico
    
    BW1 = MAG_X1>200;
    BW2 = MAG_X2>200;
    BW12 = logical(BW1.*BW2);
    
    BW3 = MAG_X3>200;
    BW4 = MAG_X4>200;
    BW34 = logical(BW3.*BW4);
    
    res.rer_MAG1(subj,1)=median(rer_M_orig(BW12));
    res.rer_MAG1(subj,2)=median(rer_M_moco(BW12));
    res.rer_MAG1(subj,3)=median(rer_M_dico(BW34));
    res.rer_MAG1(subj,4)=median(rer_M_modico(BW34));
    res.rer_ABSG1(subj,1)=median(rer_A_orig(BW12));
    res.rer_ABSG1(subj,2)=median(rer_A_moco(BW12));
    res.rer_ABSG1(subj,3)=median(rer_A_dico(BW34));
    res.rer_ABSG1(subj,4)=median(rer_A_modico(BW34));
    
    res.rer_MAG2(subj,1)=median(rer_M_orig2(BW12));
    res.rer_MAG2(subj,2)=median(rer_M_moco2(BW12));
    res.rer_MAG2(subj,3)=median(rer_M_dico2(BW34));
    res.rer_MAG2(subj,4)=median(rer_M_modico2(BW34));
    res.rer_ABSG2(subj,1)=median(rer_A_orig2(BW12));
    res.rer_ABSG2(subj,2)=median(rer_A_moco2(BW12));
    res.rer_ABSG2(subj,3)=median(rer_A_dico2(BW34));
    res.rer_ABSG2(subj,4)=median(rer_A_modico2(BW34));  

end

end