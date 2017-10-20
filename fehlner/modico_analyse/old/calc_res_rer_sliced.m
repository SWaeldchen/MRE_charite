function res = calc_res_rer_sliced(PROJ_DIR,Asubject,BWthres,prestr)
disp('calc_res_rer_sliced');
parfor subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    MAG_X1 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_MAGm_orig.nii'])));
    MAG_X2 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_MAGm_moco.nii'])));
    MAG_X3 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_MAGm_dico.nii'])));
    MAG_X4 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_MAGm_modico.nii'])));
    

%    plot2dwaves(spm_read_vols(spm_vol('EPI_c2_epi2ana_1.nii')))
     
    if ~exist(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_rer.mat']),'file')
        
        ABSG_X1 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_ABSG_orig.nii'])));
        ABSG_X2 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_ABSG_moco.nii'])));
        ABSG_X3 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_ABSG_dico.nii'])));
        ABSG_X4 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_ABSG_modico.nii'])));     
        
        [rer_M_orig2,~] = rer_3d_2(MAG_X1); % orig
        [rer_M_moco2,~] = rer_3d_2(MAG_X2); % moco
        [rer_M_dico2,~] = rer_3d_2(MAG_X3); % dico
        [rer_M_modico2,~] = rer_3d_2(MAG_X4); % modico
        
        [rer_A_orig2,~] = rer_3d_2(ABSG_X1); % orig
        [rer_A_moco2,~] = rer_3d_2(ABSG_X2); % moco
        [rer_A_dico2,~] = rer_3d_2(ABSG_X3); % dico
        [rer_A_modico2,~] = rer_3d_2(ABSG_X4); % modico
        
        parsave_rer(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_rer.mat']),...
            rer_M_orig2,rer_M_moco2,rer_M_dico2,rer_M_modico2,...
            rer_A_orig2,rer_A_moco2,rer_A_dico2,rer_A_modico2);
    else        
        dat = load(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr '_rer.mat']));
        rer_M_orig2 = dat.rer_M_orig2;
        rer_M_moco2 = dat.rer_M_moco2;
        rer_M_dico2 = dat.rer_M_dico2;
        rer_M_modico2 = dat.rer_M_modico2;
        
        rer_A_orig2 = dat.rer_A_orig2;
        rer_A_moco2 = dat.rer_A_moco2;
        rer_A_dico2 = dat.rer_A_dico2;
        rer_A_modico2 = dat.rer_A_modico2;
    end
    
    
    BW1 = MAG_X1>BWthres;
    BW2 = MAG_X2>BWthres;
    BW12 = logical(BW1.*BW2);
    
    BW3 = MAG_X3>BWthres;
    BW4 = MAG_X4>BWthres;
    BW34 = logical(BW3.*BW4);    
    BW14 = logical(BW1.*BW4);
    
    if strcmp(prestr,'MNI')
        AAA = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','wTPM.nii')));
        BWallTPM = ~(AAA(:,:,:,6)>0.8);    
        BW12 = logical(BWallTPM.*BW12);
        BW34 = logical(BWallTPM.*BW34);        
        BW14 = logical(BWallTPM.*BW14);
    else        
    end
    
    BW12 = largestBW(BW12);
    BW34 = largestBW(BW34);
    BW14 = largestBW(BW14);    

%    plot2dwaves(MAG_X3);
%    contour_bw(BW34);
%    saveas(gcf,fullfile(PROJ_DIR,SUBJ_DIR,['pic_' prestr '_MAGX3BW34.png']));
%    close
    
    rer_MAG1_1(subj) = mean(rer_M_orig2(BW12));
    rer_MAG1_2(subj) = mean(rer_M_moco2(BW12));
    rer_MAG1_3(subj) = mean(rer_M_dico2(BW34));
    rer_MAG1_4(subj) = mean(rer_M_modico2(BW34));
    rer_MAG1_5(subj) = mean(rer_M_orig2(BW14));
    rer_MAG1_6(subj) = mean(rer_M_modico2(BW14));
    
    rer_ABSG1_1(subj) = mean(rer_A_orig2(BW12));
    rer_ABSG1_2(subj) = mean(rer_A_moco2(BW12));
    rer_ABSG1_3(subj) = mean(rer_A_dico2(BW34));
    rer_ABSG1_4(subj) = mean(rer_A_modico2(BW34));
    rer_ABSG1_5(subj) = mean(rer_A_orig2(BW14));
    rer_ABSG1_6(subj) = mean(rer_A_modico2(BW14));    
    
    rer_MAG2_1(subj) = median(rer_M_orig2(BW12));
    rer_MAG2_2(subj) = median(rer_M_moco2(BW12));
    rer_MAG2_3(subj) = median(rer_M_dico2(BW34));
    rer_MAG2_4(subj) = median(rer_M_modico2(BW34));
    rer_MAG2_5(subj) = median(rer_M_orig2(BW14));
    rer_MAG2_6(subj) = median(rer_M_modico2(BW14));    
    
    rer_ABSG2_1(subj) = median(rer_A_orig2(BW12));
    rer_ABSG2_2(subj) = median(rer_A_moco2(BW12));
    rer_ABSG2_3(subj) = median(rer_A_dico2(BW34));
    rer_ABSG2_4(subj) = median(rer_A_modico2(BW34));
    rer_ABSG2_5(subj) = median(rer_A_orig2(BW14));
    rer_ABSG2_6(subj) = median(rer_A_modico2(BW14));

end

% mean
res.rer_MAG1(1,:) = rer_MAG1_1;
res.rer_MAG1(2,:) = rer_MAG1_2;
res.rer_MAG1(3,:) = rer_MAG1_3;
res.rer_MAG1(4,:) = rer_MAG1_4;
res.rer_MAG1(5,:) = rer_MAG1_5;
res.rer_MAG1(6,:) = rer_MAG1_6;
res.rer_ABSG1(1,:) = rer_ABSG1_1;
res.rer_ABSG1(2,:) = rer_ABSG1_2;
res.rer_ABSG1(3,:) = rer_ABSG1_3;
res.rer_ABSG1(4,:) = rer_ABSG1_4;
res.rer_ABSG1(5,:) = rer_ABSG1_5;
res.rer_ABSG1(6,:) = rer_ABSG1_6;

% median
res.rer_MAG2(1,:) = rer_MAG2_1;
res.rer_MAG2(2,:) = rer_MAG2_2;
res.rer_MAG2(3,:) = rer_MAG2_3;
res.rer_MAG2(4,:) = rer_MAG2_4;
res.rer_MAG2(5,:) = rer_MAG2_5;
res.rer_MAG2(6,:) = rer_MAG2_6;

res.rer_ABSG2(1,:) = rer_ABSG2_1;
res.rer_ABSG2(2,:) = rer_ABSG2_2;
res.rer_ABSG2(3,:) = rer_ABSG2_3;
res.rer_ABSG2(4,:) = rer_ABSG2_4;
res.rer_ABSG2(5,:) = rer_ABSG2_5;
res.rer_ABSG2(6,:) = rer_ABSG2_6;

end