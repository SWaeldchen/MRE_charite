function res = calc_res_entropy(PROJ_DIR,Asubject,BWthres,prestr)

for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    MAG_X1 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_MAGm_orig.nii'])));
    MAG_X2 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_MAGm_moco.nii'])));
    MAG_X3 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_MAGm_dico.nii'])));
    MAG_X4 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_MAGm_modico.nii'])));
    
    ABSG_X1 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_ABSG_orig.nii'])));
    ABSG_X2 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_ABSG_moco.nii'])));
    ABSG_X3 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_ABSG_dico.nii'])));
    ABSG_X4 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_ABSG_modico.nii'])));     
    
    %% Entropy
    
    % Orig vs Moco
    BW1 = MAG_X1>BWthres;
    BW2 = MAG_X2>BWthres;
    BW12 = BW1.*BW2;
    BW3 = MAG_X3>BWthres;
    BW4 = MAG_X4>BWthres;
    BW34 = BW3.*BW4;
    
    [ENTM1M, ENTM2M]=calc_ent(MAG_X1,MAG_X2,BW12);
    [ENTM3M, ENTM4M]=calc_ent(MAG_X3,MAG_X4,BW34);
    [ENTM1A, ENTM2A]=calc_ent(ABSG_X1,ABSG_X2,BW12);
    [ENTM3A, ENTM4A]=calc_ent(ABSG_X3,ABSG_X4,BW34);
    
    
%     [ENTSM1M, ENTSM2M]=calc_specent(MAG_X1,MAG_X2,BW12);
%     [ENTSM3M, ENTSM4M]=calc_specent(MAG_X3,MAG_X4,BW34);
%     [ENTSM1A, ENTSM2A]=calc_specent(ABSG_X1,ABSG_X2,BW12);
%     [ENTSM3A, ENTSM4A]=calc_specent(ABSG_X3,ABSG_X4,BW34);
    
    
    res.entropy_MAG(1,subj)=ENTM1M;
    res.entropy_MAG(2,subj)=ENTM2M;
    res.entropy_MAG(3,subj)=ENTM3M;
    res.entropy_MAG(4,subj)=ENTM4M;
    res.entropy_ABSG(1,subj)=ENTM1A;
    res.entropy_ABSG(2,subj)=ENTM2A;
    res.entropy_ABSG(3,subj)=ENTM3A;
    res.entropy_ABSG(4,subj)=ENTM4A;    
    
%     res.specentropy_MAG(1,subj)=ENTSM1M;
%     res.specentropy_MAG(2,subj)=ENTSM2M;
%     res.specentropy_MAG(3,subj)=ENTSM3M;
%     res.specentropy_MAG(4,subj)=ENTSM4M;
%     res.specentropy_ABSG(1,subj)=ENTSM1A;
%     res.specentropy_ABSG(2,subj)=ENTSM2A;
%     res.specentropy_ABSG(3,subj)=ENTSM3A;
%     res.specentropy_ABSG(4,subj)=ENTSM4A;
    
end

end

function [E1,E2]=calc_ent(VOL1,VOL2,BW12)
    M1=VOL1.*BW12;
    TM1 = M1(M1>0);
    NTM1 = (TM1 - min(TM1(:))) / (max(TM1(:)) - min(TM1(:))); 
    
    M2=VOL2.*BW12;
    TM2 = M2(M2>0);
    NTM2 = (TM2 - min(TM2(:))) / (max(TM2(:)) - min(TM2(:)));
    
    E1 = entropy(NTM1);
    E2 = entropy(NTM2);

end

function [E1,E2]=calc_specent(VOL1,VOL2,BW12)
    
    M1=VOL1.*BW12;
    TM1 = M1(M1>0);
    TM1 = log(abs(fftn(TM1)));
    NTM1 = (TM1 - min(TM1(:))) / (max(TM1(:)) - min(TM1(:))); 
    
    M2=VOL2.*BW12;
    TM2 = M2(M2>0);
    TM2 = log(abs(fftn(TM2)));
    NTM2 = (TM2 - min(TM2(:))) / (max(TM2(:)) - min(TM2(:)));
    
    E1 = entropy(NTM1);
    E2 = entropy(NTM2);

end

