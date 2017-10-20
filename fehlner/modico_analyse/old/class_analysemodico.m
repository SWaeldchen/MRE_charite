classdef class_analysemodico
    methods (Static)        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function GMWM_MNI_calc(PROJ_DIR,Asubject,id)
            if strcmp(id,'7T')
                MAGThres = 80;
            else
                MAGThres = 200;
            end

            kgm = 0;
            for kthres_gm = 0.5:0.05:0.8
                kgm = kgm + 1;
                kwm = 0;
                for kthres_wm = 0.5:0.05:0.8
                    kwm = kwm + 1;
                    
                    for subj = 1:numel(Asubject)
                        disp(subj);
                        SUBJ_DIR = Asubject{subj}{1};
                        disp([int2str(subj) '_' SUBJ_DIR]); 
                        cd(fullfile(PROJ_DIR,SUBJ_DIR,'ANA'));
                                                
                        MAG_X(:,:,:,1) = spm_read_vols(spm_vol('MNI_MAGm_orig.nii'));
                        MAG_X(:,:,:,2) = spm_read_vols(spm_vol('MNI_MAGm_moco.nii'));
                        MAG_X(:,:,:,3) = spm_read_vols(spm_vol('MNI_MAGm_dico.nii'));
                        MAG_X(:,:,:,4) = spm_read_vols(spm_vol('MNI_MAGm_modico.nii'));                        
                        
                        %MAG_X(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MAGm_orig.nii')));
                        %MAG_X(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MAGm_moco.nii')));
                        %MAG_X(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MAGm_dico.nii')));
                        %MAG_X(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MAGm_modico.nii')));
                        
                        ABSG_X(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_ABSG_orig.nii')));
                        ABSG_X(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_ABSG_moco.nii')));
                        ABSG_X(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_ABSG_dico.nii')));
                        ABSG_X(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_ABSG_modico.nii')));
                        
                        wTPM = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','wTPM.nii')),1);
                        
                        c1gm = wTPM(:,:,:,1);
                        c2wm = wTPM(:,:,:,2);                        
   
                        TMP_BWgm = zeros(size(MAG_X));
                        TMP_BWwm = zeros(size(MAG_X));
                        
                        for kmod = 1:4
                            for kslice = 1:size(MAG_X,3)
                                
                                TMP_BWgm(:,:,kslice,kmod) = MAG_X(:,:,kslice,kmod)>MAGThres & (kthres_gm<c1gm(:,:,kslice));
                                TMP_BWwm(:,:,kslice,kmod) = MAG_X(:,:,kslice,kmod)>MAGThres & (kthres_wm<c2wm(:,:,kslice));
                                
                                TMP_BWgm_s = TMP_BWgm(:,:,kslice,kmod);
                                TMP_BWwm_s = TMP_BWwm(:,:,kslice,kmod);
                                
                                TMP_MAG = MAG_X(:,:,kslice,kmod); 
                                TMP_ABSG = ABSG_X(:,:,kslice,kmod);
                                
                                [hM(kslice,kmod,subj),pM(kslice,kmod,subj),tmpc,stats_M] = ttest2(TMP_MAG(TMP_BWgm_s),TMP_MAG(TMP_BWwm_s));
                                [hA(kslice,kmod,subj),pA(kslice,kmod,subj),tmpc,stats_A] = ttest2(TMP_ABSG(TMP_BWgm_s),TMP_ABSG(TMP_BWwm_s));                                                               
                                
                                meanMAG1 = mean(TMP_MAG(TMP_BWgm_s));
                                meanMAG2 = mean(TMP_MAG(TMP_BWwm_s));
                                stdMAG1 = std(TMP_MAG(TMP_BWgm_s));
                                stdMAG2 = std(TMP_MAG(TMP_BWwm_s));
                                
                                meanABSG1 = mean(TMP_ABSG(TMP_BWgm_s));
                                meanABSG2 = mean(TMP_ABSG(TMP_BWwm_s));                               
                                stdABSG1 = std(TMP_ABSG(TMP_BWgm_s));
                                stdABSG2 = std(TMP_ABSG(TMP_BWwm_s));
                                                                
                                res.GM_M_me(kslice,kmod,subj,kgm,kwm) = mean(TMP_MAG(TMP_BWgm_s));
                                res.GM_M_md(kslice,kmod,subj,kgm,kwm) = median(TMP_MAG(TMP_BWgm_s));
                                res.GM_M_s(kslice,kmod,subj,kgm,kwm) = std(TMP_MAG(TMP_BWgm_s));
                                res.WM_M_me(kslice,kmod,subj,kgm,kwm) = mean(TMP_MAG(TMP_BWwm_s));
                                res.WM_M_md(kslice,kmod,subj,kgm,kwm) = median(TMP_MAG(TMP_BWwm_s));
                                res.WM_M_s(kslice,kmod,subj,kgm,kwm) = std(TMP_MAG(TMP_BWwm_s));                                
                                res.GM_A_me(kslice,kmod,subj,kgm,kwm) = mean(TMP_ABSG(TMP_BWgm_s));
                                res.GM_A_md(kslice,kmod,subj,kgm,kwm) = median(TMP_ABSG(TMP_BWgm_s));
                                res.GM_A_s(kslice,kmod,subj,kgm,kwm) = std(TMP_ABSG(TMP_BWgm_s));
                                res.WM_A_me(kslice,kmod,subj,kgm,kwm) = mean(TMP_ABSG(TMP_BWwm_s));
                                res.WM_A_md(kslice,kmod,subj,kgm,kwm) = median(TMP_ABSG(TMP_BWwm_s));
                                res.WM_A_s(kslice,kmod,subj,kgm,kwm) = std(TMP_ABSG(TMP_BWwm_s));                                              
                                
                                comb_ABSG.diffmean(kslice,kmod,subj,kgm,kwm) = meanABSG1-meanABSG2;                                
                                comb_ABSG.ratiomean(kslice,kmod,subj,kgm,kwm) = meanABSG1./meanABSG2;                                
                                comb_MAG.diffmean(kslice,kmod,subj,kgm,kwm) = meanMAG1-meanMAG2;
                                comb_MAG.ratiomean(kslice,kmod,subj,kgm,kwm) = meanMAG1./meanMAG2;
                                
      
                                
                                dM_all(kslice,kmod,subj) = ashmanbiomod(meanMAG1,meanMAG2,stdMAG1,stdMAG2);
                                dA_all(kslice,kmod,subj) = ashmanbiomod(meanABSG1,meanABSG2,stdABSG1,stdABSG2);
                                
                                tM_all(kslice,kmod,subj) = stats_M.tstat;
                                tA_all(kslice,kmod,subj) = stats_A.tstat;
                                
                            end
                            
                            % plot2dwaves(MAG_X(:,:,20:40,k));
                            % plot2dwaves(ABSG_X(:,:,20:40,k));
                            % contour_bw(TMP_BW1(:,:,20:40),'r');
                            % contour_bw(TMP_BW2(:,:,20:40),'b');
                        end
                        
                    end                    
                    
                    if strcmp(id,'7T')
                        dM=dM_all;
                        dA=dA_all;
                        tM=tM_all;
                        tA=tA_all;
                    else
                        dM=dM_all(:,:,[1:2 4:14]);
                        dA=dA_all(:,:,[1:2 4:14]);
                        tM=tM_all(:,:,[1:2 4:14]);
                        tA=tA_all(:,:,[1:2 4:14]);
                    end                    
                    
                    for kslice = 1:size(MAG_X,3)
                        disp(kslice);
                        disp(size(dM));
                        [hdM14(kslice),pdM14(kslice)]=ttest(squeeze(dM(kslice,1,:)),squeeze(dM(kslice,4,:)));
                        [hdA14(kslice),pdA14(kslice)]=ttest(squeeze(dA(kslice,1,:)),squeeze(dA(kslice,4,:)));
                        [hdM13(kslice),pdM13(kslice)]=ttest(squeeze(dM(kslice,1,:)),squeeze(dM(kslice,3,:)));
                        [hdA13(kslice),pdA13(kslice)]=ttest(squeeze(dA(kslice,1,:)),squeeze(dA(kslice,3,:)));
                        [hdM12(kslice),pdM12(kslice)]=ttest(squeeze(dM(kslice,1,:)),squeeze(dM(kslice,2,:)));
                        [hdA12(kslice),pdA12(kslice)]=ttest(squeeze(dA(kslice,1,:)),squeeze(dA(kslice,2,:)));
                        [hdM24(kslice),pdM24(kslice)]=ttest(squeeze(dM(kslice,2,:)),squeeze(dM(kslice,4,:)));
                        [hdA24(kslice),pdA24(kslice)]=ttest(squeeze(dA(kslice,2,:)),squeeze(dA(kslice,4,:)));
                        [hdM34(kslice),pdM34(kslice)]=ttest(squeeze(dM(kslice,3,:)),squeeze(dM(kslice,4,:)));
                        [hdA34(kslice),pdA34(kslice)]=ttest(squeeze(dA(kslice,3,:)),squeeze(dA(kslice,4,:)));
                        
                        [hM14(kslice),pM14(kslice)]=ttest(squeeze(tM(kslice,1,:)),squeeze(tM(kslice,4,:)));
                        [hA14(kslice),pA14(kslice)]=ttest(squeeze(tA(kslice,1,:)),squeeze(tA(kslice,4,:)));
                        [hM13(kslice),pM13(kslice)]=ttest(squeeze(tM(kslice,1,:)),squeeze(tM(kslice,3,:)));
                        [hA13(kslice),pA13(kslice)]=ttest(squeeze(tA(kslice,1,:)),squeeze(tA(kslice,3,:)));
                        [hM12(kslice),pM12(kslice)]=ttest(squeeze(tM(kslice,1,:)),squeeze(tM(kslice,2,:)));
                        [hA12(kslice),pA12(kslice)]=ttest(squeeze(tA(kslice,1,:)),squeeze(tA(kslice,2,:)));
                        [hM24(kslice),pM24(kslice)]=ttest(squeeze(tM(kslice,2,:)),squeeze(tM(kslice,4,:)));
                        [hA24(kslice),pA24(kslice)]=ttest(squeeze(tA(kslice,2,:)),squeeze(tA(kslice,4,:)));
                        [hM34(kslice),pM34(kslice)]=ttest(squeeze(tM(kslice,3,:)),squeeze(tM(kslice,4,:)));
                        [hA34(kslice),pA34(kslice)]=ttest(squeeze(tA(kslice,3,:)),squeeze(tA(kslice,4,:)));
                        
                        %                 [pdM14_S(s),hdM14_S(s)]=signrank(squeeze(dM(s,1,:)),squeeze(dM(s,4,:)));
                        %                 [pdA14_S(s),hdA14_S(s)]=signrank(squeeze(dA(s,1,:)),squeeze(dA(s,4,:)));
                        %                 [pdM13_S(s),hdM13_S(s)]=signrank(squeeze(dM(s,1,:)),squeeze(dM(s,3,:)));
                        %                 [pdA13_S(s),hdA13_S(s)]=signrank(squeeze(dA(s,1,:)),squeeze(dA(s,3,:)));
                        %                 [pdM12_S(s),hdM12_S(s)]=signrank(squeeze(dM(s,1,:)),squeeze(dM(s,2,:)));
                        %                 [pdA12_S(s),hdA12_S(s)]=signrank(squeeze(dA(s,1,:)),squeeze(dA(s,2,:)));
                        %                 [pdM24_S(s),hdM24_S(s)]=signrank(squeeze(dM(s,2,:)),squeeze(dM(s,4,:)));
                        %                 [pdA24_S(s),hdA24_S(s)]=signrank(squeeze(dA(s,2,:)),squeeze(dA(s,4,:)));
                        %                 [pdM34_S(s),hdM34_S(s)]=signrank(squeeze(dM(s,3,:)),squeeze(dM(s,4,:)));
                        %                 [pdA34_S(s),hdA34_S(s)]=signrank(squeeze(dA(s,3,:)),squeeze(dA(s,4,:)));
                        %
                        %                 [pM14_S(s),hM14_S(s)]=signrank(squeeze(tM(s,1,:)),squeeze(tM(s,4,:)));
                        %                 [pA14_S(s),hA14_S(s)]=signrank(squeeze(tA(s,1,:)),squeeze(tA(s,4,:)));
                        %                 [pM13_S(s),hM13_S(s)]=signrank(squeeze(tM(s,1,:)),squeeze(tM(s,3,:)));
                        %                 [pA13_S(s),hA13_S(s)]=signrank(squeeze(tA(s,1,:)),squeeze(tA(s,3,:)));
                        %                 [pM12_S(s),hM12_S(s)]=signrank(squeeze(tM(s,1,:)),squeeze(tM(s,2,:)));
                        %                 [pA12_S(s),hA12_S(s)]=signrank(squeeze(tA(s,1,:)),squeeze(tA(s,2,:)));
                        %                 [pM24_S(s),hM24_S(s)]=signrank(squeeze(tM(s,2,:)),squeeze(tM(s,4,:)));
                        %                 [pA24_S(s),hA24_S(s)]=signrank(squeeze(tA(s,2,:)),squeeze(tA(s,4,:)));
                        %                 [pM34_S(s),hM34_S(s)]=signrank(squeeze(tM(s,3,:)),squeeze(tM(s,4,:)));
                        %                 [pA34_S(s),hA34_S(s)]=signrank(squeeze(tA(s,3,:)),squeeze(tA(s,4,:)));
                        
                    end
                    %
                    %             plot2dwaves(...
                    %                cat(1,cat(1,pM14,pA14,pM13,pA13,pM12,pA12,pM24,pA24,pM34,pA34),...
                    %                cat(1,pdM14,pdA14,pdM13,pdA13,pdM12,pdA12,pdM24,pdA24,pdM34,pdA34)));
                    %
                    %             plot2dwaves(cat(1,pdM14,pdA14,...
                    %                               pdM13,pdA13,...
                    %                               pdM12,pdA12,...
                    %                               pdM24,pdA24,...
                    %                               pdM34,pdA34));
                    
                    matrixpM = (cat(1,...
                        pM24,pA24,...
                        pM34,pA34));
                    save(['/home/realtime/DATAmatrixpM_' id '_GM' int2str(kthres_gm*100) '_WM' int2str(kthres_wm*100) '.mat'],'matrixpM','comb_ABSG','comb_MAG','TMP_BW1','TMP_BW2','res');
                end
            end
            
            %disp([mean(comb_ABSG.diffmeanABSG(29,2,:),3) std(comb_ABSG.diffmeanABSG(29,2,:),[],3)]);
            %disp([mean(comb_ABSG.diffmeanABSG(29,4,:),3) std(comb_ABSG.diffmeanABSG(29,4,:),[],3)]);
            
            %              plot2dwaves(...
            %                  cat(1,pM14,pA14,pM13,pA13,pM12,pA12,pM24,pA24,pM34,pA34)-...
            %                  cat(1,pdM14,pdA14,pdM13,pdA13,pdM12,pdA12,pdM24,pdA24,pdM34,pdA34));
            
        end      
       

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%          for kslice = 1:size(res.GM_A_me,1)
%              [h_ttest(kslice) p_ttest(kslice)] = ttest(squeeze(res.GM_A_me(kslice,2,:)),squeeze(res.WM_A_me(kslice,2,:)));
%          %[h_ttest(kslice) p_ttest(kslice)] = ttest(squeeze(res.GM_A_me(kslice,4,:)),squeeze(res.WM_A_me(kslice,4,:)));
%          end
        
        
        function GMWM_MNI_plot(PROJ_DIR,Asubject,id)
            
            %PIC_DIR = fullfile(PROJ_DIR,'PICS');
            PIC_DIR = fullfile('/home/realtime/',['PICS_' id]);
            mkdir(PIC_DIR);
            
            kgm=0;
            for kthres_gm = 0.7 %0.5:0.05:0.8
                kgm = kgm + 1;
                kwm = 0;
                for kthres_wm = 0.7 %0.5:0.05:0.7
                    kwm = kwm + 1;
            
                    load(['/home/realtime/DATAmatrixpM_' id '_GM' int2str(kthres_gm*100) '_WM' int2str(kthres_wm*100) '.mat'],'res');                       
            
                    %res.GM_M_me(kslice,kmod,subj,kgm,kwm) 
                    
                    for kmode = 1:4
                        DATA1 = res.GM_A_md(:,:,kmode);
                        DATA2 = res.WM_A_md(:,:,kmode);
                        res.sep_GMWM_Amd(:,kgm,kwm,kmode) = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_sep_GMAmdWMAmd_kgm' int2str(kgm) '_kwm' int2str(kwm) 'kval' int2str(kmode) '.png']));
                        
                        DATA1 = res.GM_M_md(:,:,kmode);
                        DATA2 = res.WM_M_md(:,:,kmode);
                        res.sep_GMWM_Mmd(:,kgm,kwm,kmode) = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_sep_GMMmdWMMmd_kgm' int2str(kgm) '_kwm' int2str(kwm) 'kval' int2str(kmode) '.png']));
                        
                        DATA1 = res.GM_A_me(:,:,kmode);
                        DATA2 = res.WM_A_me(:,:,kmode);
                        res.sep_GMWM_Ame(:,kgm,kwm,kmode) = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_sep_GMAmeWMAme_kgm' int2str(kgm) '_kwm' int2str(kwm) 'kval' int2str(kmode) '.png']));
                        
                        DATA1 = res.GM_M_me(:,:,kmode);
                        DATA2 = res.WM_M_me(:,:,kmode);
                        res.sep_GMWM_Mme(:,kgm,kwm,kmode) = plotmseb2(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_sep_GMMmeWMMme_kgm' int2str(kgm) '_kwm' int2str(kwm) 'kval' int2str(kmode) '.png']));
                    end
                    
            
            
                plotfig = 'yes';
                        
                %%
                %% Ratio
                %%
                
                DATA1 = squeeze(res.GM_M_md(:,:,1,kgm,kwm)./res.WM_M_md(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_M_md(:,:,2,kgm,kwm)./res.WM_M_md(:,:,2,kgm,kwm));
                hR12Mmd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMMmed_WMMmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_me(:,:,1,kgm,kwm)./res.WM_M_me(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_M_me(:,:,2,kgm,kwm)./res.WM_M_me(:,:,2,kgm,kwm));
                hR12Mme(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMMme_WMMme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_s(:,:,1,kgm,kwm)./res.WM_M_s(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_M_s(:,:,2,kgm,kwm)./res.WM_M_s(:,:,2,kgm,kwm));
                hR12Ms(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMMs_WMMs_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_md(:,:,3,kgm,kwm)./res.WM_M_md(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_M_md(:,:,4,kgm,kwm)./res.WM_M_md(:,:,4,kgm,kwm));
                hR34Mmd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMMmed_WMMmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_me(:,:,3,kgm,kwm)./res.WM_M_me(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_M_me(:,:,4,kgm,kwm)./res.WM_M_me(:,:,4,kgm,kwm));
                hR34Mme(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMMme_WMMme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_s(:,:,3,kgm,kwm)./res.WM_M_s(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_M_s(:,:,4,kgm,kwm)./res.WM_M_s(:,:,4,kgm,kwm));
                hR34Ms(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMMs_WMMs_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                %%%%%%%%%% ABSG
                
                DATA1 = squeeze(res.GM_A_md(:,:,1,kgm,kwm)./res.WM_A_md(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_A_md(:,:,2,kgm,kwm)./res.WM_A_md(:,:,2,kgm,kwm));
                hR12Amd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMAmed_WMAmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_me(:,:,1,kgm,kwm)./res.WM_A_me(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_A_me(:,:,2,kgm,kwm)./res.WM_A_me(:,:,2,kgm,kwm));
                hR12Ame(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMAme_WMAme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_s(:,:,1,kgm,kwm)./res.WM_A_s(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_A_s(:,:,2,kgm,kwm)./res.WM_A_s(:,:,2,kgm,kwm));
                hR12As(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_1vs2_GMAs_WMAs_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_md(:,:,3,kgm,kwm)./res.WM_A_md(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_A_md(:,:,4,kgm,kwm)./res.WM_A_md(:,:,4,kgm,kwm));
                hR34Amd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMAmed_WMAmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_me(:,:,3,kgm,kwm)./res.WM_A_me(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_A_me(:,:,4,kgm,kwm)./res.WM_A_me(:,:,4,kgm,kwm));
                hR34Ame(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMAme_WMAme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_s(:,:,3,kgm,kwm)./res.WM_A_s(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_A_s(:,:,4,kgm,kwm)./res.WM_A_s(:,:,4,kgm,kwm));
                hR34As(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_ratio_3vs4_GMAs_WMAs_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                %%
                %% DIFF
                %%
                
                
                DATA1 = squeeze(res.GM_M_md(:,:,1,kgm,kwm)-res.WM_M_md(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_M_md(:,:,2,kgm,kwm)-res.WM_M_md(:,:,2,kgm,kwm));
                h12Mmd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMMmed_WMMmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_me(:,:,1,kgm,kwm)-res.WM_M_me(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_M_me(:,:,2,kgm,kwm)-res.WM_M_me(:,:,2,kgm,kwm));
                h12Mme(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMMme_WMMme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_s(:,:,1,kgm,kwm)-res.WM_M_s(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_M_s(:,:,2,kgm,kwm)-res.WM_M_s(:,:,2,kgm,kwm));
                h12Ms(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMMs_WMMs_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_md(:,:,3,kgm,kwm)-res.WM_M_md(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_M_md(:,:,4,kgm,kwm)-res.WM_M_md(:,:,4,kgm,kwm));
                h34Mmd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMMmed_WMMmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_me(:,:,3,kgm,kwm)-res.WM_M_me(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_M_me(:,:,4,kgm,kwm)-res.WM_M_me(:,:,4,kgm,kwm));
                h34Mme(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMMme_WMMme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_M_s(:,:,3,kgm,kwm)-res.WM_M_s(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_M_s(:,:,4,kgm,kwm)-res.WM_M_s(:,:,4,kgm,kwm));
                h34Ms(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMMs_WMMs_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                %%%%%%%%%% ABSG
                
                DATA1 = squeeze(res.GM_A_md(:,:,1,kgm,kwm)-res.WM_A_md(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_A_md(:,:,2,kgm,kwm)-res.WM_A_md(:,:,2,kgm,kwm));
                h12Amd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMAmed_WMAmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_me(:,:,1,kgm,kwm)-res.WM_A_me(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_A_me(:,:,2,kgm,kwm)-res.WM_A_me(:,:,2,kgm,kwm));
                h12Ame(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMAme_WMAme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_s(:,:,1,kgm,kwm)-res.WM_A_s(:,:,1,kgm,kwm));
                DATA2 = squeeze(res.GM_A_s(:,:,2,kgm,kwm)-res.WM_A_s(:,:,2,kgm,kwm));
                h12As(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_1vs2_GMAs_WMAs_' 'kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_md(:,:,2,kgm,kwm)-res.WM_A_md(:,:,2,kgm,kwm));
                DATA2 = squeeze(res.GM_A_md(:,:,4,kgm,kwm)-res.WM_A_md(:,:,4,kgm,kwm));
                h24Amd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMAmed_WMAmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_me(:,:,2,kgm,kwm)-res.WM_A_me(:,:,2,kgm,kwm));
                DATA2 = squeeze(res.GM_A_me(:,:,4,kgm,kwm)-res.WM_A_me(:,:,4,kgm,kwm));
                h24Ame(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMAme_WMAme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_s(:,:,2,kgm,kwm)-res.WM_A_s(:,:,2,kgm,kwm));
                DATA2 = squeeze(res.GM_A_s(:,:,4,kgm,kwm)-res.WM_A_s(:,:,4,kgm,kwm));
                h24As(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_2vs4_GMAs_WMAs_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                
                
                DATA1 = squeeze(res.GM_A_md(:,:,3,kgm,kwm)-res.WM_A_md(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_A_md(:,:,4,kgm,kwm)-res.WM_A_md(:,:,4,kgm,kwm));
                h34Amd(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMAmed_WMAmed_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_me(:,:,3,kgm,kwm)-res.WM_A_me(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_A_me(:,:,4,kgm,kwm)-res.WM_A_me(:,:,4,kgm,kwm));
                h34Ame(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMAme_WMAme_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
                
                DATA1 = squeeze(res.GM_A_s(:,:,3,kgm,kwm)-res.WM_A_s(:,:,3,kgm,kwm));
                DATA2 = squeeze(res.GM_A_s(:,:,4,kgm,kwm)-res.WM_A_s(:,:,4,kgm,kwm));
                h34As(:,kgm,kwm) = plotmseb(DATA1,DATA2,plotfig,fullfile(PIC_DIR,['pic_diff_3vs4_GMAs_WMAs_kgm' int2str(kgm) '_kwm' int2str(kwm) '.png']));
              
                save(fullfile(PROJ_DIR,['res_WMGM_kgm' int2str(kgm) '_kwm' int2str(kwm) '.mat']),...
                    'h34Mme','h34Mmd','h12Mme','h12Mmd',...
                    'h34Ame','h34Amd','h12Ame','h12Amd',...                    
                    'h34Ms','h24Ms','h14Ms',...
                    'h34As','h24As','h14As');
                
                end
            end
            
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

