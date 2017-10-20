classdef class_analysemodico_05
    methods (Static)
        
        function GMWM_MNI_calc_sblock(PROJ_DIR,Asubject,id,eqname)
            if strcmp(id,'7T')
                MAGThres = 80;
            else
                MAGThres = 200;
            end           
                        
            kgm = 0;
            for kthres_gm = 0.5:0.05:0.70 %5:0.05:0.8
                kgm = kgm + 1;
                kwm = 0;
                for kthres_wm = 0.5:0.05:0.70 %5:0.05:0.7
                    kwm = kwm + 1;
                    disp([kthres_gm kthres_wm]);
                    
                    for subj = 1:numel(Asubject)
                        SUBJ_DIR = Asubject{subj}{1};
                        fprintf('s %d',subj);                        
                        cd(fullfile(PROJ_DIR,SUBJ_DIR,'ANA'));
                        
                        MAG_X(:,:,:,1) = spm_read_vols(spm_vol('MNI_MAGm_orig.nii'));
                        MAG_X(:,:,:,2) = spm_read_vols(spm_vol('MNI_MAGm_moco.nii'));
                        MAG_X(:,:,:,3) = spm_read_vols(spm_vol('MNI_MAGm_dico.nii'));
                        MAG_X(:,:,:,4) = spm_read_vols(spm_vol('MNI_MAGm_modico.nii'));
                        
                        ABSG_X(:,:,:,1) = spm_read_vols(spm_vol('MNI_ABSG_orig.nii'));
                        ABSG_X(:,:,:,2) = spm_read_vols(spm_vol('MNI_ABSG_moco.nii'));
                        ABSG_X(:,:,:,3) = spm_read_vols(spm_vol('MNI_ABSG_dico.nii'));
                        ABSG_X(:,:,:,4) = spm_read_vols(spm_vol('MNI_ABSG_modico.nii'));
                        
                        wTPM = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','wTPM.nii')),1);
                        
                        c1gm = wTPM(:,:,:,1);
                        c2wm = wTPM(:,:,:,2);
                        
                        TMP_BWgm = zeros(size(MAG_X));
                        TMP_BWwm = zeros(size(MAG_X));
                        
                        for kmod = 1:4
                            %fprintf('kmod %d',kmod);
                            
                            if strcmp(id,'3T')
                                sblock{1} = 29:31;
                                sblock{2} = 28:32;
                                sblock{3} = 27:33;
                                sblock{4} = 26:34;
                                sblock{5} = 25:35;
                                sblock{6} = 29;
                                sblock{7} = 30;
                                sblock{8} = 30:60;
                                sblock{9} = 25:65;
                                
                                for ktmpslice = 25:65
                                    sblock{ktmpslice} = ktmpslice;
                                end
                                
                            else
                                sblock{1} = 107:139;
                                sblock{2} = 107:120;
                                sblock{3} = 120:130;
                                sblock{4} = 130:140;
                                sblock{5} = 125:145;
                            end
                            
                            for kkslice = 1:length(sblock)
                                %fprintf('kk %d',kkslice);
                                %for kslice = 1:size(MAG_X,3)
                                
                                kslice = sblock{kkslice};
                                
                                BW_gm(:,:,kslice,kmod,subj) = MAG_X(:,:,kslice,kmod)>MAGThres & (kthres_gm<c1gm(:,:,kslice));
                                BW_wm(:,:,kslice,kmod,subj) = MAG_X(:,:,kslice,kmod)>MAGThres & (kthres_wm<c2wm(:,:,kslice));
                                
                                TMP_BWgm = logical(BW_gm(:,:,kslice,kmod,subj));
                                TMP_BWwm = logical(BW_wm(:,:,kslice,kmod,subj));
                                TMP_MAG  = MAG_X(:,:,kslice,kmod);
                                TMP_ABSG = ABSG_X(:,:,kslice,kmod);                                                              
                                
                                [res.hM(kkslice,kmod,subj),res.pM(kkslice,kmod,subj),tmpc,tmp_M] = ttest2(TMP_MAG(TMP_BWgm),TMP_MAG(TMP_BWwm),'Vartype',eqname);
                                [res.hA(kkslice,kmod,subj),res.pA(kkslice,kmod,subj),tmpc,tmp_A] = ttest2(TMP_ABSG(TMP_BWgm),TMP_ABSG(TMP_BWwm),'Vartype',eqname);
                                                                
                                res.tstat_A(kkslice,kmod,subj) = tmp_A.tstat;
                                res.tstat_M(kkslice,kmod,subj) = tmp_M.tstat;
                                
                                res.A_gm_val{kkslice,kmod,subj} = TMP_ABSG(TMP_BWgm);
                                res.A_wm_val{kkslice,kmod,subj} = TMP_ABSG(TMP_BWwm);
                                res.M_gm_val{kkslice,kmod,subj} = TMP_MAG(TMP_BWgm);
                                res.M_wm_val{kkslice,kmod,subj} = TMP_MAG(TMP_BWwm);
                                
                                res.GM_M_me(kkslice,kmod,subj) = mean(TMP_MAG(TMP_BWgm));
                                res.GM_M_md(kkslice,kmod,subj) = median(TMP_MAG(TMP_BWgm));
                                res.GM_M_s(kkslice,kmod,subj) = std(TMP_MAG(TMP_BWgm));
                                res.WM_M_me(kkslice,kmod,subj) = mean(TMP_MAG(TMP_BWwm));
                                res.WM_M_md(kkslice,kmod,subj) = median(TMP_MAG(TMP_BWwm));
                                res.WM_M_s(kkslice,kmod,subj) = std(TMP_MAG(TMP_BWwm));
                                res.GM_A_me(kkslice,kmod,subj) = mean(TMP_ABSG(TMP_BWgm));
                                res.GM_A_md(kkslice,kmod,subj) = median(TMP_ABSG(TMP_BWgm));
                                res.GM_A_s(kkslice,kmod,subj) = std(TMP_ABSG(TMP_BWgm));
                                res.WM_A_me(kkslice,kmod,subj) = mean(TMP_ABSG(TMP_BWwm));
                                res.WM_A_md(kkslice,kmod,subj) = median(TMP_ABSG(TMP_BWwm));
                                res.WM_A_s(kkslice,kmod,subj) = std(TMP_ABSG(TMP_BWwm));
                                
                                comb_ABSG.diffmean(kkslice,kmod,subj) = res.GM_A_me(kkslice,kmod,subj) - res.WM_A_me(kkslice,kmod,subj);
                                comb_ABSG.ratiomean(kkslice,kmod,subj) = res.GM_A_me(kkslice,kmod,subj) ./ res.WM_A_me(kkslice,kmod,subj);
                                comb_MAG.diffmean(kkslice,kmod,subj) = res.GM_M_me(kkslice,kmod,subj) - res.WM_M_me(kkslice,kmod,subj);
                                comb_MAG.ratiomean(kkslice,kmod,subj) = res.GM_M_me(kkslice,kmod,subj) ./ res.WM_M_me(kkslice,kmod,subj);
                                
                                res.dASH_M(kkslice,kmod,subj) = calc_ashmanbiomod(...
                                    res.GM_M_me(kkslice,kmod,subj),...
                                    res.WM_M_me(kkslice,kmod,subj),...
                                    res.GM_M_s(kkslice,kmod,subj),...
                                    res.WM_M_s(kkslice,kmod,subj));
                                
                                res.dASH_A(kkslice,kmod,subj) = calc_ashmanbiomod(...
                                    res.GM_A_me(kkslice,kmod,subj),...
                                    res.WM_A_me(kkslice,kmod,subj),...
                                    res.GM_A_s(kkslice,kmod,subj),...
                                    res.WM_A_s(kkslice,kmod,subj));
                                
                               
                            end
                        end
                    end
                    
                    save(fullfile(PROJ_DIR,['DATA_GMWM_MNI_sb_' id '_GM' int2str(kthres_gm*100) '_WM' int2str(kthres_wm*100) '_' eqname '.mat']),...
                        'comb_ABSG','comb_MAG','BW_gm','BW_wm','res');
                end
            end
            
        end       

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function GMWM_MNI_plot(PROJ_DIR,id,eqname)
            
            PIC_DIR = fullfile('/home/realtime/',['PICS_' id]);
            %PIC_DIR = fullfile(PROJ_DIR,'PICS');%
            mkdir(PIC_DIR);
            
            kgm = 0;
            for kthres_gm = 0.5:0.05:0.70 %0.5:0.05:0.8 %0.5:0.05:0.8
                kgm = kgm + 1;
                kwm = 0;
                for kthres_wm = 0.5:0.05:0.70 %0.5:0.05:0.7
                    kwm = kwm + 1;
                    disp([int2str(kgm) '_' int2str(kwm)]);
                    
                    %load(fullfile(PROJ_DIR,['DATA_GMWM_MNI_' id '_GM' int2str(kthres_gm*100) '_WM' int2str(kthres_wm*100) '.mat']),'res');
                    load(fullfile(PROJ_DIR,['DATA_GMWM_MNI_sb_' id '_GM' int2str(kthres_gm*100) '_WM' int2str(kthres_wm*100) '_' eqname '.mat']),'res');
                    iwm = kthres_wm *100;
                    igm = kthres_gm *100;
                    %res.GM_M_me(kslice,kmod,subj,kgm,kwm)
                    
                    if strcmp(id,'7T')
                        ksublist = 1:size(res.tstat_M,3);
                    else
                        ksublist = 1:size(res.tstat_M,3);
                        %ksublist = [1:2 4:14];
                    end
                    
                    %                     res.tM=res.tstat_M(:,:,ksublist);
                    %                     res.tA=res.tstat_A(:,:,ksublist);
                    %                     res.dASH_ASH_M=res.dASH_ASH_M(:,:,ksublist);
                    %                     res.dASH_A=res.dASH_ASH_A(:,:,ksublist);
                    
                    % Statistik über t-Werte über D-Abstandsmass
                    for kslice = 1:size(res.GM_M_me,1)
                        [res.h_dM14(kslice),res.p_dM14(kslice)]=ttest(squeeze(res.dASH_M(kslice,1,ksublist)),squeeze(res.dASH_M(kslice,4,ksublist)));
                        [res.h_dA14(kslice),res.p_dA14(kslice)]=ttest(squeeze(res.dASH_A(kslice,1,ksublist)),squeeze(res.dASH_A(kslice,4,ksublist)));
                        [res.h_dM13(kslice),res.p_dM13(kslice)]=ttest(squeeze(res.dASH_M(kslice,1,ksublist)),squeeze(res.dASH_M(kslice,3,ksublist)));
                        [res.h_dA13(kslice),res.p_dA13(kslice)]=ttest(squeeze(res.dASH_A(kslice,1,ksublist)),squeeze(res.dASH_A(kslice,3,ksublist)));
                        [res.h_dM12(kslice),res.p_dM12(kslice)]=ttest(squeeze(res.dASH_M(kslice,1,ksublist)),squeeze(res.dASH_M(kslice,2,ksublist)));
                        [res.h_dA12(kslice),res.p_dA12(kslice)]=ttest(squeeze(res.dASH_A(kslice,1,ksublist)),squeeze(res.dASH_A(kslice,2,ksublist)));
                        [res.h_dM24(kslice),res.p_dM24(kslice)]=ttest(squeeze(res.dASH_M(kslice,2,ksublist)),squeeze(res.dASH_M(kslice,4,ksublist)));
                        [res.h_dA24(kslice),res.p_dA24(kslice)]=ttest(squeeze(res.dASH_A(kslice,2,ksublist)),squeeze(res.dASH_A(kslice,4,ksublist)));
                        [res.h_dM34(kslice),res.p_dM34(kslice)]=ttest(squeeze(res.dASH_M(kslice,3,ksublist)),squeeze(res.dASH_M(kslice,4,ksublist)));
                        [res.h_dA34(kslice),res.p_dA34(kslice)]=ttest(squeeze(res.dASH_A(kslice,3,ksublist)),squeeze(res.dASH_A(kslice,4,ksublist)));
                        
                        [res.h_M14(kslice),res.p_M14(kslice)]=ttest(squeeze(res.tstat_M(kslice,1,ksublist)),squeeze(res.tstat_M(kslice,4,ksublist)));
                        [res.h_A14(kslice),res.p_A14(kslice)]=ttest(squeeze(res.tstat_A(kslice,1,ksublist)),squeeze(res.tstat_A(kslice,4,ksublist)));
                        [res.h_M13(kslice),res.p_M13(kslice)]=ttest(squeeze(res.tstat_M(kslice,1,ksublist)),squeeze(res.tstat_M(kslice,3,ksublist)));
                        [res.h_A13(kslice),res.p_A13(kslice)]=ttest(squeeze(res.tstat_A(kslice,1,ksublist)),squeeze(res.tstat_A(kslice,3,ksublist)));
                        [res.h_M12(kslice),res.p_M12(kslice)]=ttest(squeeze(res.tstat_M(kslice,1,ksublist)),squeeze(res.tstat_M(kslice,2,ksublist)));
                        [res.h_A12(kslice),res.p_A12(kslice)]=ttest(squeeze(res.tstat_A(kslice,1,ksublist)),squeeze(res.tstat_A(kslice,2,ksublist)));
                        [res.h_M24(kslice),res.p_M24(kslice)]=ttest(squeeze(res.tstat_M(kslice,2,ksublist)),squeeze(res.tstat_M(kslice,4,ksublist)));
                        [res.h_A24(kslice),res.p_A24(kslice)]=ttest(squeeze(res.tstat_A(kslice,2,ksublist)),squeeze(res.tstat_A(kslice,4,ksublist)));
                        [res.h_M34(kslice),res.p_M34(kslice)]=ttest(squeeze(res.tstat_M(kslice,3,ksublist)),squeeze(res.tstat_M(kslice,4,ksublist)));
                        [res.h_A34(kslice),res.p_A34(kslice)]=ttest(squeeze(res.tstat_A(kslice,3,ksublist)),squeeze(res.tstat_A(kslice,4,ksublist)));
                        
                    end
                    
                    
                    plotfig = 'no';
                    
                    for kmod = 1:4
                        DATA1 = squeeze(res.GM_A_md(:,kmod,ksublist));
                        DATA2 = squeeze(res.WM_A_md(:,kmod,ksublist));
                        res.sep_GMWM_Amd(:,kmod) = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_sep_GMAmdWMAmd_kgm' int2str(igm) '_kwm' int2str(iwm) '_kmode' int2str(kmod) '.png']));
                        
                        DATA1 = squeeze(res.GM_M_md(:,kmod,ksublist));
                        DATA2 = squeeze(res.WM_M_md(:,kmod,ksublist));
                        res.sep_GMWM_Mmd(:,kmod) = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_sep_GMMmdWMMmd_kgm' int2str(igm) '_kwm' int2str(iwm) '_kmode' int2str(kmod) '.png']));
                        
                        DATA1 = squeeze(res.GM_A_me(:,kmod,ksublist));
                        DATA2 = squeeze(res.WM_A_me(:,kmod,ksublist));
                        res.sep_GMWM_Ame(:,kmod) = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_sep_GMAmeWMAme_kgm' int2str(igm) '_kwm' int2str(iwm) '_kmode' int2str(kmod) '.png']));
                        
                        DATA1 = squeeze(res.GM_M_me(:,kmod,ksublist));
                        DATA2 = squeeze(res.WM_M_me(:,kmod,ksublist));
                        res.sep_GMWM_Mme(:,kmod) = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_sep_GMMmeWMMme_kgm' int2str(igm) '_kwm' int2str(iwm) '_kmode' int2str(kmod) '.png']));
                    end
                    
                    %% Ratio
                    %%
                    
                    DATA1 = squeeze(res.GM_M_md(:,1,ksublist)./res.WM_M_md(:,1,ksublist));
                    DATA2 = squeeze(res.GM_M_md(:,2,ksublist)./res.WM_M_md(:,2,ksublist));
                    res.ratio_M_md_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMMmed_WMMmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_me(:,1,ksublist)./res.WM_M_me(:,1,ksublist));
                    DATA2 = squeeze(res.GM_M_me(:,2,ksublist)./res.WM_M_me(:,2,ksublist));
                    res.ratio_M_me_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMMme_WMMme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_s(:,1,ksublist)./res.WM_M_s(:,1,ksublist));
                    DATA2 = squeeze(res.GM_M_s(:,2,ksublist)./res.WM_M_s(:,2,ksublist));
                    res.ratio_M_s_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMMs_WMMs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_md(:,2,ksublist)./res.WM_M_md(:,2,ksublist));
                    DATA2 = squeeze(res.GM_M_md(:,4,ksublist)./res.WM_M_md(:,4,ksublist));
                    res.ratio_M_md_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_2vs4_GMMmed_WMMmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_me(:,2,ksublist)./res.WM_M_me(:,2,ksublist));
                    DATA2 = squeeze(res.GM_M_me(:,4,ksublist)./res.WM_M_me(:,4,ksublist));
                    res.ratio_M_me_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_2vs4_GMMme_WMMme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_s(:,2,ksublist)./res.WM_M_s(:,2,ksublist));
                    DATA2 = squeeze(res.GM_M_s(:,4,ksublist)./res.WM_M_s(:,4,ksublist));
                    res.ratio_M_s_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_2vs4_GMMs_WMMs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                                                            
                    DATA1 = squeeze(res.GM_M_md(:,3,ksublist)./res.WM_M_md(:,3,ksublist));
                    DATA2 = squeeze(res.GM_M_md(:,4,ksublist)./res.WM_M_md(:,4,ksublist));
                    res.ratio_M_md_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMMmed_WMMmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_me(:,3,ksublist)./res.WM_M_me(:,3,ksublist));
                    DATA2 = squeeze(res.GM_M_me(:,4,ksublist)./res.WM_M_me(:,4,ksublist));
                    res.ratio_M_me_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMMme_WMMme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_s(:,3,ksublist)./res.WM_M_s(:,3,ksublist));
                    DATA2 = squeeze(res.GM_M_s(:,4,ksublist)./res.WM_M_s(:,4,ksublist));
                    res.ratio_M_s_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMMs_WMMs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    %%%%%%%%%% ABSG
                    
                    DATA1 = squeeze(res.GM_A_md(:,2,ksublist)./res.WM_A_md(:,2,ksublist));
                    DATA2 = squeeze(res.GM_A_md(:,4,ksublist)./res.WM_A_md(:,4,ksublist));
                    res.ratio_A_md_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_2vs4_GMAmed_WMAmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_me(:,2,ksublist)./res.WM_A_me(:,2,ksublist));
                    DATA2 = squeeze(res.GM_A_me(:,4,ksublist)./res.WM_A_me(:,4,ksublist));
                    res.ratio_A_me_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_2vs4_GMAme_WMAme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_s(:,2,ksublist)./res.WM_A_s(:,2,ksublist));
                    DATA2 = squeeze(res.GM_A_s(:,4,ksublist)./res.WM_A_s(:,4,ksublist));
                    res.ratio_A_s_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_2vs4_GMAs_WMAs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    
                    DATA1 = squeeze(res.GM_A_md(:,1,ksublist)./res.WM_A_md(:,1,ksublist));
                    DATA2 = squeeze(res.GM_A_md(:,2,ksublist)./res.WM_A_md(:,2,ksublist));
                    res.ratio_A_md_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMAmed_WMAmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_me(:,1,ksublist)./res.WM_A_me(:,1,ksublist));
                    DATA2 = squeeze(res.GM_A_me(:,2,ksublist)./res.WM_A_me(:,2,ksublist));
                    res.ratio_A_me_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMAme_WMAme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_s(:,1,ksublist)./res.WM_A_s(:,1,ksublist));
                    DATA2 = squeeze(res.GM_A_s(:,2,ksublist)./res.WM_A_s(:,2,ksublist));
                    res.ratio_A_s_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMAs_WMAs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    
                    
                    DATA1 = squeeze(res.GM_A_md(:,3,ksublist)./res.WM_A_md(:,3,ksublist));
                    DATA2 = squeeze(res.GM_A_md(:,4,ksublist)./res.WM_A_md(:,4,ksublist));
                    res.ratio_A_md_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMAmed_WMAmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_me(:,3,ksublist)./res.WM_A_me(:,3,ksublist));
                    DATA2 = squeeze(res.GM_A_me(:,4,ksublist)./res.WM_A_me(:,4,ksublist));
                    res.ratio_A_me_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMAme_WMAme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_s(:,3,ksublist)./res.WM_A_s(:,3,ksublist));
                    DATA2 = squeeze(res.GM_A_s(:,4,ksublist)./res.WM_A_s(:,4,ksublist));
                    res.ratio_A_s_34  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMAs_WMAs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    %%
                    %% DIFF
                    %%
                    
                    
                    DATA1 = squeeze(res.GM_M_md(:,1,ksublist)-res.WM_M_md(:,1,ksublist));
                    DATA2 = squeeze(res.GM_M_md(:,2,ksublist)-res.WM_M_md(:,2,ksublist));
                    res.diff_M_md_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMMmed_WMMmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_me(:,1,ksublist)-res.WM_M_me(:,1,ksublist));
                    DATA2 = squeeze(res.GM_M_me(:,2,ksublist)-res.WM_M_me(:,2,ksublist));
                    res.diff_M_me_12  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMMme_WMMme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_s(:,1,ksublist)-res.WM_M_s(:,1,ksublist));
                    DATA2 = squeeze(res.GM_M_s(:,2,ksublist)-res.WM_M_s(:,2,ksublist));
                    res.diff_M_s_12 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMMs_WMMs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    
                    DATA1 = squeeze(res.GM_M_md(:,2,ksublist)-res.WM_M_md(:,2,ksublist));
                    DATA2 = squeeze(res.GM_M_md(:,4,ksublist)-res.WM_M_md(:,4,ksublist));
                    res.diff_M_md_24 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMMmed_WMMmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_me(:,2,ksublist)-res.WM_M_me(:,2,ksublist));
                    DATA2 = squeeze(res.GM_M_me(:,4,ksublist)-res.WM_M_me(:,4,ksublist));
                    res.diff_M_me_24 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMMme_WMMme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_s(:,2,ksublist)-res.WM_M_s(:,2,ksublist));
                    DATA2 = squeeze(res.GM_M_s(:,4,ksublist)-res.WM_M_s(:,4,ksublist));
                    res.diff_M_s_24  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMMs_WMMs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    
                    
                    DATA1 = squeeze(res.GM_M_md(:,3,ksublist)-res.WM_M_md(:,3,ksublist));
                    DATA2 = squeeze(res.GM_M_md(:,4,ksublist)-res.WM_M_md(:,4,ksublist));
                    res.diff_M_md_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMMmed_WMMmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_me(:,3,ksublist)-res.WM_M_me(:,3,ksublist));
                    DATA2 = squeeze(res.GM_M_me(:,4,ksublist)-res.WM_M_me(:,4,ksublist));
                    res.diff_M_me_34  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMMme_WMMme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_M_s(:,3,ksublist)-res.WM_M_s(:,3,ksublist));
                    DATA2 = squeeze(res.GM_M_s(:,4,ksublist)-res.WM_M_s(:,4,ksublist));
                    res.diff_M_s_12  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMMs_WMMs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    %%%%%%%%%% ABSG
                    
                    DATA1 = squeeze(res.GM_A_md(:,1,ksublist)-res.WM_A_md(:,1,ksublist));
                    DATA2 = squeeze(res.GM_A_md(:,2,ksublist)-res.WM_A_md(:,2,ksublist));
                    res.diff_A_md_12  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMAmed_WMAmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_me(:,1,ksublist)-res.WM_A_me(:,1,ksublist));
                    DATA2 = squeeze(res.GM_A_me(:,2,ksublist)-res.WM_A_me(:,2,ksublist));
                    res.diff_A_me_12  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMAme_WMAme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_s(:,1,ksublist)-res.WM_A_s(:,1,ksublist));
                    DATA2 = squeeze(res.GM_A_s(:,2,ksublist)-res.WM_A_s(:,2,ksublist));
                    res.diff_A_s_12  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMAs_WMAs_' 'kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_md(:,2,ksublist)-res.WM_A_md(:,2,ksublist));
                    DATA2 = squeeze(res.GM_A_md(:,4,ksublist)-res.WM_A_md(:,4,ksublist));
                    res.diff_A_md_24 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMAmed_WMAmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_me(:,2,ksublist)-res.WM_A_me(:,2,ksublist));
                    DATA2 = squeeze(res.GM_A_me(:,4,ksublist)-res.WM_A_me(:,4,ksublist));
                    res.diff_A_me_24 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMAme_WMAme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_s(:,2,ksublist)-res.WM_A_s(:,2,ksublist));
                    DATA2 = squeeze(res.GM_A_s(:,4,ksublist)-res.WM_A_s(:,4,ksublist));
                    res.diff_A_s_24  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMAs_WMAs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_md(:,3,ksublist)-res.WM_A_md(:,3,ksublist));
                    DATA2 = squeeze(res.GM_A_md(:,4,ksublist)-res.WM_A_md(:,4,ksublist));
                    res.diff_A_md_34  = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMAmed_WMAmed_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_me(:,3,ksublist)-res.WM_A_me(:,3,ksublist));
                    DATA2 = squeeze(res.GM_A_me(:,4,ksublist)-res.WM_A_me(:,4,ksublist));
                    res.diff_A_me_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMAme_WMAme_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    DATA1 = squeeze(res.GM_A_s(:,3,ksublist)-res.WM_A_s(:,3,ksublist));
                    DATA2 = squeeze(res.GM_A_s(:,4,ksublist)-res.WM_A_s(:,4,ksublist));
                    res.diff_A_s_34 = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMAs_WMAs_kgm' int2str(igm) '_kwm' int2str(iwm) '.png']));
                    
                    
                    ABC_Ah(1,1:65) = res.diff_A_me_24.h_ttest;
                    ABC_Ah(2,1:65) = res.diff_A_me_34.h_ttest;
                    ABC_Ah(3,1:65) = res.h_A24;
                    ABC_Ah(4,1:65) = res.h_A34;                    
                    for k=1:4
                        sumABC_Ah(k,1:65) = sum(ABC_Ah(k,1:65),1);
                    end
                    
                    ABC_Mh(1,1:65) = res.diff_M_me_24.h_ttest;
                    ABC_Mh(2,1:65) = res.diff_M_me_34.h_ttest;
                    ABC_Mh(3,1:65) = res.h_M24;
                    ABC_Mh(4,1:65) = res.h_M34;
                    for k=1:4
                        sumABC_Mh(k,1:65) = sum(ABC_Mh(k),1);
                    end
                    
                    ABC_Ap(1,1:65) = res.diff_A_me_24.p_ttest;
                    ABC_Ap(2,1:65) = res.diff_A_me_34.p_ttest;
                    ABC_Ap(3,1:65) = res.p_A24;
                    ABC_Ap(4,1:65) = res.p_A34;
                    for k=1:5
                        sumABC_Ap(k,1:65) = sum(ABC_Ap(k,1:65),1);
                    end
                   

                    ABC_Mp(1,1:65) = res.diff_M_me_24.p_ttest;
                    ABC_Mp(2,1:65) = res.diff_M_me_34.p_ttest;
                    ABC_Mp(3,1:65) = res.p_M24;
                    ABC_Mp(4,1:65) = res.p_M34;
                    for k=1:4
                        sumABC_Mp(k,1:65) = sum(ABC_Mp(k),1);
                    end
                    
                    
                    for k = 1:7
                        COMP_STAT_Ah(kgm,kwm,1:length(sumABC_Mh),k) = sumABC_Ah(k,1:65);
                        COMP_STAT_Mh(kgm,kwm,1:length(sumABC_Mh),k) = sumABC_Mh(k,1:65);
                        COMP_STAT_Ap(kgm,kwm,1:length(sumABC_Mh),k) = sumABC_Ap(k,1:65);
                        COMP_STAT_Mp(kgm,kwm,1:length(sumABC_Mh),k) = sumABC_Mp(k,1:65);
                    end
                    
                    
                    save(fullfile(PROJ_DIR,['DATA_GMWM_resplot_kgm' int2str(igm) '_kwm' int2str(iwm) '_' eqname '.mat']),'res');
                end
            end
            
            save(['/home/realtime/COMP_STAT_' eqname '.mat'],'COMP_STAT_Ap','COMP_STAT_Ah','COMP_STAT_Mp','COMP_STAT_Mh');
            save(fullfile(PROJ_DIR,['COMP_STAT_' eqname '.mat']),'COMP_STAT_Ap','COMP_STAT_Ah','COMP_STAT_Mp','COMP_STAT_Mh');
            
            %             save(fullfile(PROJ_DIR,'res_WMGMdiff.mat'),'h34Ame','h34Amd','h12Ame','h12Amd');
            %
            %             plot2dwaves(cat(2,h12Amd,h12Ame,h34Amd,h34Ame));
            %             plot2dwaves(cat(2,h12Mmd,h12Mme,h34Mmd,h34Mme));
            %
            %             % Ratio
            %
            %             plot2dwaves(cat(2,hR12Amd,hR12Ame,hR34Amd,hR34Ame));
            %             plot2dwaves(cat(2,hR12Mmd,hR12Mme,hR34Mmd,hR34Mme));
            %
            %             plot2dwaves(cat(2,hR12Ms,hR34Ms,h12Ms,h34Ms));
            %             plot2dwaves(cat(2,hR12As,hR34As,h12As,h34As));
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function averagetissue(PROJ_DIR,Asubject)
            
            DATAstr={'MNI_MPRAGE','MNI_myfield','MNI_ABSG_orig','MNI_ABSG_moco','MNI_ABSG_dico','MNI_ABSG_modico','MNI_ABSG_orig_nc','MNI_ABSG_moco_nc',...
                'MNI_ABSG_dico_nc','MNI_ABSG_modico_nc','MNI_c1_epi2mni_1','MNI_c2_epi2mni_1','MNI_c3_epi2mni_1','MNI_c1_epi2mni_2','MNI_c2_epi2mni_2',...
                'MNI_c3_epi2mni_2','MNI_c1_epi2mni_3','MNI_c2_epi2mni_3','MNI_c3_epi2mni_3','MNI_c1_epi2mni_4','MNI_c2_epi2mni_4','MNI_c3_epi2mni_4',...
                'MNI_c1_epi2mni_orig','MNI_c2_epi2mni_orig','MNI_c3_epi2mni_orig','MNI_c1_epi2mni_dico','MNI_c2_epi2mni_dico','MNI_c3_epi2mni_dico'};
            
            for kdatastr=1:length(DATAstr)
                AVG(PROJ_DIR,Asubject,DATAstr{kdatastr});
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plotoverview_MNI(PROJ_DIR,Asubject)
            disp('plotoverview MNI...');
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            
            TMP_DATA = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{1}{1},'ANA','MNI_MAGf_orig.nii')));
            
            for kslice = 30:5:size(TMP_DATA,3)
                X = CheckData(PROJ_DIR,Asubject,kslice,'MNI_MPRAGE','MNI_ANA_c2',...
                    'MNI_MAGf_orig','MNI_MAGf_dico','MNI_MAGm_orig','MNI_MAGm_moco','MNI_MAGm_dico','MNI_MAGm_modico',...
                    'MNI_ABSG_modico','MNI_PHI_modico','MNI_myfield',...
                    'MNI_wx_Twarp_orig_epi2ana','MNI_wy_Twarp_orig_epi2ana','MNI_wz_Twarp_orig_epi2ana',...
                    'MNI_wx_Twarp_dico_epi2ana');
                figure;
                imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),...
                    X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[-1 1]);
                axis image, colormap(gray), axis off
                saveas(gcf,fullfile(PIC_DIR,['picoverview_MNI_' int2str(kslice) '.png']));
                saveas(gcf,fullfile(PIC_DIR,['picoverview_MNI_' int2str(kslice) '.fig']));
                close
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function plotoverview_EPI(PROJ_DIR,Asubject) %,subjectlist)
            disp('plotoverview EPI...');
            
            PIC_DIR = fullfile(PROJ_DIR,'PICS');
            
            TMP_DATA = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{1}{1},'ANA','EPI_MAGf_orig.nii')));
            
            for kslice = 2:5:size(TMP_DATA,3)
                X = CheckData(PROJ_DIR,Asubject,kslice,...
                    'EPI_segana_orig_MPRAGE',...
                    'EPI_c2_segana_orig_MPRAGE',...
                    'EPI_MAGf_orig','EPI_MAGf_dico',...
                    'EPI_MAGm_orig','EPI_MAGm_moco','EPI_MAGm_dico','EPI_MAGm_modico',...
                    'EPI_ABSG_modico','EPI_PHI_orig','EPI_myfield',...
                    'wx_Twarp_orig_epi2ana','wy_Twarp_orig_epi2ana','wz_Twarp_orig_epi2ana',...
                    'wx_Twarp_dico_epi2ana');
                figure;
                if size(X,3) == 14
                    imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6),X(:,:,7),...
                        X(:,:,8),X(:,:,9),X(:,:,10),X(:,:,11),X(:,:,12),X(:,:,13),X(:,:,14)),[-1 1]);
                end
                if size(X,3) == 6
                    imagesc(cat(1,X(:,:,1),X(:,:,2),X(:,:,3),X(:,:,4),X(:,:,5),X(:,:,6)),[-1 1]);
                end
                axis image, colormap(gray), axis off
                saveas(gcf,fullfile(PIC_DIR,['picoverview_EPI_' int2str(kslice) '.png']));
                saveas(gcf,fullfile(PIC_DIR,['picoverview_EPI_' int2str(kslice) '.fig']));
                close
            end
        end
        
        
        
        %             for ksub = subjectlist
        %                 disp(['Subnum: ' int2str(ksub)]);
        %
        %                 DATA_SUB = fullfile(PROJ_DIR,Asubject(ksub).name);
        %                 RAWN_SUB = fullfile(DATA_SUB,'RAWN');
        %
        %                 cd(SCRIPT_DIR);
        %                 disp(SCRIPT_DIR);
        %                 copyfile('topup_param.txt',fullfile(RAWN_SUB,'topup_param.txt'));
        %
        %             end
        %        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

