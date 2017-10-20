clear all
addpath('/home/realtime/spm12');
addpath(genpath('/home/realtime/project_modico'));

% Save library paths
MatlabPath = getenv('LD_LIBRARY_PATH');
% Make Matlab use system libraries
setenv('LD_LIBRARY_PATH',getenv('PATH'))


t_id{1} = '3T'; % PERF
t_id{2} = '15T';
t_id{3} = '30T';
t_id{4} = '7T';

t_mod{1} = 'MAGm';
t_mod{2} = 'ABSG';

for kid = 4 %1:length(t_id)
    id = t_id{kid};
    
    
    
    
    %% Subjects %%
    
    Asubject3T = {
        {'MREPERF-FD_20150513-133126',7,16,18,14,[30 40 50],40,30,3,4,5,'F. Dittmann',26} % dicom mprage korrupt (nutze nii!)
        {'SHi_MREPERF_20150622',26,9,11,3,[30 40 50],40,30,15,16,17,'S. Hirsch',31}
        {'MREPERF-LM_20150624-131215',14,5,7,3,[30 40 50],40,30,11,12,13,'L. Marz',20}
        {'MREPERF-SH_20150625-145714',14,5,7,3,[30 40 50],40,30,11,12,13,'S. Hetzer',38}
        {'MREPERF-AFAndi_20150625-140247',14,5,7,3,[30 40 50],40,30,11,12,13,'A. Fehlner',29}
        {'MREPERF-TS_20150626-090422',14,5,7,3,[30 40 50],40,30,11,12,13,'T. Scheuermann',28}
        {'MREPERF-JB_20150630-110303',14,5,7,3,[30 40 50],40,30,11,12,13,'J. Braun',54}
        {'MREPERF-IS_20150630-132315',6,19,21,17,[30 40 50],40,30,3,4,5,'I. Sack',45}
        {'MREPERF-HT_20150630-114822',6,19,21,17,[30 40 50],40,30,3,4,5,'H. Tzschaetzsch',30}
        {'MREPERF-AR_20150706-095001',15,5,7,3,[30 40 50],40,30,12,13,14,'A. Ratthey',48} % seg_epi2mni falsch registriert!
        {'MREPERF-DS_20150707-164535',15,5,7,3,[30 40 50],40,30,24,13,14,'D. Schubert',56}
        {'MREPERF-TC_20150707-155729',15,5,7,3,[30 40 50],40,30,12,13,14,'T. Christofel',32}
        {'MREPERF-VG_20150707-173412',15,5,7,3,[30 40 50],40,30,12,13,14,'V. Gruendel',28}
        {'MREPERF-DG_20150708-112321',15,5,7,3,[30 40 50],40,30,12,13,14,'D. Glass',53} % seg_epi2mni falsch registriert!
        };
    
    % 7T
    Asubject7T = {
        {'nd81-3188_20150114-103840',5,15,17,[7,13,19],[30,40,50],42,70}
        {'ql48-3194_20150115-122916',5,9,11,[7,13,19],[30,40,50],42,70}
        {'ls93-3191_20150115-095226',5,9,11,[7,13,19],[30,40,50],42,70}
        {'hr27-3184_20150113-103002',5,9,11,[7,13,19],[30,40,50],42,70}
        {'ko96-3193_20150115-113626',5,9,11,[7,13,19],[30,40,50],42,70}
        {'bh27-3203_20150121-133914',5,9,11,[7,13,19],[30,40,50],42,70}
        {'sc17-3187_20150113-141143',5,9,11,[7,13,19],[30,40,50],42,70}
        {'rk17-3190_20150114-125344',5,9,11,[7,13,19],[30,40,50],42,70}
        {'zr20-3195_20150115-135043',3,7,9,[5,11,17],[30,40,50],42,70}
        {'br01-3196_20150115-143917',5,9,11,[7,13,19],[30,40,50],42,70}
        {'va08-3199_20150116-101423',5,9,11,[7,13,19],[30,40,50],42,70}
        {'zi11-3182_20150112-113229',27,13,15,[11,17,23],[30,40,50],42,70}
        {'dn20-3186_20150113-130353',5,9,11,[7,13,19],[30,40,50],42,70}
        {'kw96-3189_20150114-115052',5,10,12,[8,14,20],[30,40,50],42,70}
        {'br72-3192_20150115-104047',5,9,11,[7,13,19],[30,40,50],42,70}
        {'vu57-3183_20150112-131410',5,9,11,[9,17,23],[30,40,50],42,70}
        {'kq53-3204_20150121-144103',5,9,11,[7,13,19],[30,40,50],42,70}
        {'mo64-3200_20150119-125505',5,9,11,[7,13,19],[30,40,50],42,70}
        };
    
    Asubject15T = {
        {'MMRE-brain-Edin-AF-1-5T-2015-01-21_20150121-161216',2,4,8,10,[30,40,50],20,15}
        {'MMRE-brainedin-AK-1-5T-20150427_20150427-140826',2,3,5,7,[30,40,50],20,15}
        {'MMRE-brainedin-1-5T-AR-20150427_20150427-163927',2,3,	5,7,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-BG-20150515_20150515-134350',2,3,5,7,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-BS-20150722_20150722-112215',2,3,5,7,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-DS-2015-01-16_20150116-204027',2,4,8,10,[30,40,50],20,15}
        {'MMRE-brain-edin-FS-1-5T-2015-03-03_20150303-173116',2,3,5,9,[30,40,50],20,15}
        {'MMRE-brainedin-1-5T-HS-20150427_20150427-170204',2,3,5,7,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-HT-2015-01-16_20150116-104358',2,4,6,8,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-IS-2015-01-29_20150129-160033',3,8,10,12,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-JB-2015-01-29_20150129-153622',2,7,9,11,[30,40,50],20,15}
        %{'MMRE-brain-edin-JD-2015-03-03_20150303-175444',2,3,5,	7,[30,40,50],20,15}
        {'MMRE-brain-Edin-JG-1-5T-2015-01-21_20150121-154615',2,4,6,8,[30,40,50],20,15}
        {'MMRE-brainedin-1-5T-JH-20150427_20150427-161707',2,3,	5,7,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-HaJ-20150205_20150205-160443',2,11,9,7,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-OB-20150205_20150205-172153',2,3,5,7,[30,40,50],20,15}
        {'MMRE-brain-edin-RL-1-5T_20150907-182401',2,3,5,7,[30,40,50],20,15}
        {'MMRE-brain-edin-1-5T-SH-2015-01-15_20150115-180610',2,5,7,9,[30,40,50],20,15}
        {'MMRE-brain-edin-SS-1-5T-2015-03-03_20150303-170041',2,3,5,7,[30,40,50],20,15}
        };
    
    Asubject30T = {
        {'MMRE-brain-edin-3T-AF-2015-01-16_20150116-095142',2,7,9,11,[30,40,50],16,30}
        {'MMRE-brain-edin-3T-AK-2015-01-29_20150129-125926',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-3T-DS-2015-01-16_20150116-201002',2,4,6,8,[30,40,50],16,30} % Probleme, dauerte ewig
        {'MMRE-brain-edin3T-HT-2015-01-15_20150115-145827',2,5,7,3,[30,40,50],16,30}
        {'mmre-brain-edin-3T-IS-2015-01-29_20150129-124057',3,4,6,8,[30,40,50],16,30}
        {'mmre-brain-edin-3T-jb-2015-01-29_20150129-121857',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-3T-JHA-2015-02-05_20150205-151732',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-3T-SS-2015-03-03_20150303-182203',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-AR-3T-2015-03-09_20150309-155843',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-FS-3T-2015-03-03_20150303-184049',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-HS-3T-2015-03-03_20150309-164039',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-JD-3T-2015-03-03_20150303-185722',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-JH-3T-2015-03-09_20150309-162220',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-JG-3T-2015-01-26_20150126-120220',2,3,5,7,[30,40,50],16,30}
        {'MMRE-brain-edin-3T-SH-2015-01-26_20150126-113526',2,3,5,9,[30,40,50],16,30}
        {'MMRE-brain-edin-3T-SIU-2015-01-26_20150126-122207',2,3,5,7,[30,40,50],16,30}
        };
    
    if strcmp(id,'3T')
        Asubject = Asubject3T;
        PROJ_DIR = '/store01_analysis/realtime/PERF3T/';
    end
    
    
    if strcmp(id,'15T')
        Asubject = Asubject15T;
        PROJ_DIR = '/store01_analysis/realtime/edin15T/';
    end
    
    if strcmp(id,'30T')
        Asubject = Asubject30T;
        PROJ_DIR = '/store01_analysis/realtime/edin3T/';
    end
    
    if strcmp(id,'7T')
        Asubject = Asubject7T;
        PROJ_DIR = '/store01_analysis/realtime/edin7T/';
    end
    
    disp(PROJ_DIR);
    
    %% GM/WM-Maske erstellen
    %CreateMask(PROJ_DIR,Asubject);
    
    
    %% TPM2MNI
    TPM2MNI(PROJ_DIR,Asubject);
    
    %% Average Tissue Masks
    
    % AVG(PROJ_DIR,Asubject,'MNI_MPRAGE');
    % AVG(PROJ_DIR,Asubject,'MNI_myfield');
    %
    % AVG(PROJ_DIR,Asubject,'MNI_ABSG_orig');
    % AVG(PROJ_DIR,Asubject,'MNI_ABSG_moco');
    % AVG(PROJ_DIR,Asubject,'MNI_ABSG_dico');
    % AVG(PROJ_DIR,Asubject,'MNI_ABSG_modico');
    % AVG(PROJ_DIR,Asubject,'MNI_ABSG_orig_nc');
    % AVG(PROJ_DIR,Asubject,'MNI_ABSG_moco_nc');
    % AVG(PROJ_DIR,Asubject,'MNI_ABSG_dico_nc');
    % AVG(PROJ_DIR,Asubject,'MNI_ABSG_modico_nc');
    %
    % AVG(PROJ_DIR,Asubject,'MNI_c1_epi2mni_1')
    % AVG(PROJ_DIR,Asubject,'MNI_c2_epi2mni_1');
    % AVG(PROJ_DIR,Asubject,'MNI_c3_epi2mni_1');
    % AVG(PROJ_DIR,Asubject,'MNI_c1_epi2mni_2');
    % AVG(PROJ_DIR,Asubject,'MNI_c2_epi2mni_2');
    % AVG(PROJ_DIR,Asubject,'MNI_c3_epi2mni_2');
    % AVG(PROJ_DIR,Asubject,'MNI_c1_epi2mni_3');
    % AVG(PROJ_DIR,Asubject,'MNI_c2_epi2mni_3');
    % AVG(PROJ_DIR,Asubject,'MNI_c3_epi2mni_3');
    % AVG(PROJ_DIR,Asubject,'MNI_c1_epi2mni_4');
    % AVG(PROJ_DIR,Asubject,'MNI_c2_epi2mni_4');
    % AVG(PROJ_DIR,Asubject,'MNI_c3_epi2mni_4');
    % AVG(PROJ_DIR,Asubject,'MNI_c1_epi2mni_orig')
    % AVG(PROJ_DIR,Asubject,'MNI_c2_epi2mni_orig');
    % AVG(PROJ_DIR,Asubject,'MNI_c3_epi2mni_orig');
    % AVG(PROJ_DIR,Asubject,'MNI_c1_epi2mni_dico');
    % AVG(PROJ_DIR,Asubject,'MNI_c2_epi2mni_dico');
    % AVG(PROJ_DIR,Asubject,'MNI_c3_epi2mni_dico');
    
    
    %% Mutual Information -> TODO: MI(Asubject, X,B) geht nur f�r Schichten (ganze Bilder)?
    % [MIo, MIc] = MInf(Asubject);
    
    
    %% GM/WM Separation -> TODO: GMWM(Asubject, X,WM,GM,B)
    %[WM_m, GM_m] = GMWM(PROJ_DIR,Asubject);
    
    
    %% Displacements Dxyz vs. B0 via seg_epi2mprage in EPI-Space für Abbildung
    % [B0, M, D1x, D1y, D1z, D2x, D2y, D2z] = Dxyz(PROJ_DIR,Asubject);
    % s=6
    % for subj=1:14,
    % X1(:,:,:,subj) = cat(2, B0(:,:,s,subj)/20, -D1x(:,:,s,subj), -D1y(:,:,s,subj), -D1z(:,:,s,subj));
    % end
    % X = squeeze(X1);
    % figure; imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[-3 3])
    % axis image, colormap(gray), axis off
    %
    % %% getLargestCc(mD1x>1,4,1)
    %
    % who = [1 2 3];%[1 2 3 4 5 6 7 8 9 12 13];
    % MASK = imfill(getLargestCc(mean(M(:,:,s,5),4)>220,4,1),'holes');
    %
    % mD1x=squeeze(mean(D1x(:,:,s,who),4) .* MASK);
    % mD1y=squeeze(mean(D1y(:,:,s,who),4) .* MASK);
    % mD1z=squeeze(mean(D1z(:,:,s,who),4) .* MASK);
    % mD2x=squeeze(mean(D2x(:,:,s,who),4) .* MASK);
    % mD2y=squeeze(mean(D2y(:,:,s,who),4) .* MASK);
    % mD2z=squeeze(mean(D2z(:,:,s,who),4) .* MASK);
    %
    % figure
    % subplot(231)
    % imagesc(fliplr(rot90(mean(B0(:,:,s,who),4) .* MASK)),[-50 50]) ,axis image, colormap(gray), axis off
    %
    % subplot(232)  
    % imagesc(fliplr(rot90(-mD1x)),[-1.5 1.5]),axis image, colormap(gray), axis off
    % subplot(233)
    % imagesc(fliplr(rot90((-mD1z-mD1y).* MASK)),[-1.5 1.5]),axis image, colormap(gray), axis off
    %
    % subplot(235)
    % imagesc(fliplr(rot90(-mD2x)),[-1.5 1.5]),axis image, colormap(gray), axis off
    % subplot(236)
    % imagesc(fliplr(rot90((-mD2z-mD2y).* MASK)),[-1.5 1.5]),axis image, colormap(gray), axis off
    
    
    
    %% Motion
    [mFD] = calc_SFD(PROJ_DIR,Asubject);
    
    
    %% PSF
    
    % (A) CREATE MASKS
    % create_mask(PROJ_DIR,Asubject,'MAGm_orig',200) %3T:200 / 7T:80
    % create_mask(PROJ_DIR,Asubject,'MAGm_moco',200)
    % create_mask(PROJ_DIR,Asubject,'MAGm_dico',200)
    % create_mask(PROJ_DIR,Asubject,'MAGm_modico',200)
    
    res_WMGM = af_GMWM(PROJ_DIR,Asubject);
    res_WMGM = af_GMWM_MNI(PROJ_DIR,Asubject);
    
    %res1 = calc_res_rer(PROJ_DIR,Asubject);
    res2 = calc_res_psf(PROJ_DIR,Asubject);
    res3 = calc_res_entropy(PROJ_DIR,Asubject);
    
    C = res2.psf_MAG;
    plot_improve_corrmotion(C,mFD,id,'psf_MAG');
    
    C = res2.psf_ABSG;
    plot_improve_corrmotion(C,mFD,id,'psf_ABSG');

    C = res3.entropy_MAG;
    plot_improve_corrmotion(C,mFD,id,'entropy_MAG');

    C = res3.entropy_ABSG;
    plot_improve_corrmotion(C,mFD,id,'entropy_ABSG');

    % DATA_save.meanD(kid,kmodc) = mean(D);
    % DATA_save.stdD(kid,kmodc) = std(D);
    % DATA_save.meanmFD(kid,kmodc) = mean(mFD);
    % DATA_save.stdmFD(kid,kmodc) = std(mFD);
    % DATA_save.posvarvspsdecrease_r(kid,kmodc) = R(2);
    % DATA_save.posvarvspsdecrease_p(kid,kmodc) = P(2);
    %
    % DATA_save.ttest_psf_origmoco(kid,kmodc) = p_ttest_12;
    % DATA_save.ttest_psf_dicomodico(kid,kmodc) = p_ttest_34;
    
    %% !! Check Data !!
    %PIC_DIR = '/store01_analysis/realtime/PERF3T/PICS/';
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    %saveas(gcf,fullfile('/store01_analysis/realtime/',['PSF_' kmod '_' id '.pdf']));
    close all
    
    % ### 3T MNI ###
    % for kslice = 30%30:5:50
    % X = CheckData(PROJ_DIR,Asubject,kslice,'MNI_MPRAGE','wANA_c2','wMAGf_orig','wMAGf_dico','wMAGm_orig','wMAGm_moco','wMAGm_dico','wMAGm_modico','wABSG_modico','MNI_y_epi2mni_orig','wmyfield','wwx_Twarp_orig','wwy_Twarp_orig','wwz_Twarp_orig','wwx_Twarp_dico');
    % figure; imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[-1 1])
    % axis image, colormap(gray), axis off
    % saveas(gcf,fullfile(PIC_DIR,['pic3T_MNI_' int2str(kslice) '.png']));
    % saveas(gcf,fullfile(PIC_DIR,['pic3T_MNI_' int2str(kslice) '.fig']));
    % close
    % end
    
    % ### 3T EPI ###
    % for kslice = 2%1:6:40
    % X = CheckData(PROJ_DIR,Asubject,kslice,'EPI_orig_MPRAGE','EPI_c2_orig','MAGf_orig','MAGf_dico','MAGm_orig','MAGm_moco','MAGm_dico','MAGm_modico','ABSG_modico','EPI_iy_orig','myfield','wx_Twarp_orig','wy_Twarp_orig','wz_Twarp_orig','wx_Twarp_dico');
    % figure; imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[-1 1])
    % axis image, colormap(gray), axis off
    % saveas(gcf,fullfile(PIC_DIR,['pic3T_EPI_' int2str(kslice) '.png']));
    % saveas(gcf,fullfile(PIC_DIR,['pic3T_EPI_' int2str(kslice) '.fig']));
    % close
    % end
    
    % ### 7T MNI ###
    % for kslice = 120%100:10:130
    % X = CheckData(PROJ_DIR,Asubject,kslice,'MNI_MPRAGE','wANA_c2','wMAGf_orig','wMAGf_dico','wMAGm_orig','wMAGm_moco','wMAGm_dico','wMAGm_modico','wABSG_modico','wEPI_iy_orig','wmyfield','wwx_Twarp_orig','wwy_Twarp_orig','wwz_Twarp_orig','wwx_Twarp_dico');
    % figure; imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14),X(:,:,15),X(:,:,16),X(:,:,17),X(:,:,18)),[-1 1])
    % axis image, colormap(gray), axis off
    % saveas(gcf,fullfile(PIC_DIR,['pic7T_MNI_' int2str(kslice) '.png']));
    % saveas(gcf,fullfile(PIC_DIR,['pic7T_MNI_' int2str(kslice) '.fig']));
    % close
    % end
    
    % ### 7T EPI ###
    % for kslice = 9%1:8:42
    % X = CheckData(PROJ_DIR,Asubject,kslice,'EPI_orig_MPRAGE','EPI_c2_orig','MAGf_orig','MAGf_dico','MAGm_orig','MAGm_moco','MAGm_dico','MAGm_modico','ABSG_modico','EPI_iy_orig','myfield','wx_Twarp_orig','wy_Twarp_orig','wz_Twarp_orig','wx_Twarp_dico');
    % figure; imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14),X(:,:,15),X(:,:,16),X(:,:,17),X(:,:,18)),[-1 1])
    % axis image, colormap(gray), axis off
    % saveas(gcf,fullfile(PIC_DIR,['pic7T_EPI_' int2str(kslice) '.png']));
    % saveas(gcf,fullfile(PIC_DIR,['pic7T_EPI_' int2str(kslice) '.fig']));
    % close
    % end
    
    % Reassign old library paths
    
    save(fullfile('/store01_analysis/realtime/',['resdata_' id '.mat']),'res1','res2','res3');
end


save('/store01_analysis/realtime/DATA_comb.mat','DATA_save');

setenv('LD_LIBRARY_PATH',MatlabPath);
