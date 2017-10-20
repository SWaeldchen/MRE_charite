clear all
cd('/store01_analysis/realtime/PERF3T/');
PROJ_DIR = '/store01_analysis/realtime/PERF3T/';

load DATA_GMWM_MNI_sb_3T_GM60_WM60_equal.mat;
% 
% %load DATA_GMWM_MNI_sb_3T_GM50_WM50_equal.mat;
% %load DATA_GMWM_MNI_sb_3T_GM65_WM65_equal.mat;
% 
% for k=1:65
for k= 1:65
     [hA(k) pA(k) ciA Astats] = ttest(squeeze(res.tstat_A(k,4,:)-res.tstat_A(k,2,:)));
     
     [hA_R(k) pA_R(k) ciA_R Astats_R] = ttest(squeeze(res.tstat_A(k,4,:)),squeeze(res.tstat_A(k,2,:)),'Tail','right');
     [hA_L(k) pA_L(k) ciA_L Astats_L] = ttest(squeeze(res.tstat_A(k,4,:)),squeeze(res.tstat_A(k,2,:)),'Tail','left');
     
%     [pAs(k) hAs(k)] = signrank(squeeze(res.tstat_A(k,4,:)-res.tstat_A(k,2,:)));
%      
%      [pAs_L(k) hAs_L(k) stats_L(k)] = signtest(squeeze(res.tstat_A(k,4,:)),squeeze(res.tstat_A(k,2,:)),'tail','left');
%      [pAs_R(k) hAs_R(k) stats_R(k)] = signtest(squeeze(res.tstat_A(k,4,:)),squeeze(res.tstat_A(k,2,:)),'tail','right');
%      singlebox(squeeze(res.tstat_A(k,4,:)-res.tstat_A(k,2,:)));
end

for k= 3:4
     [hA(k) pA(k)] = ttest(squeeze(res.tstat_A(k,3,:)-res.tstat_A(k,1,:)));
     [pAs(k) hAs(k)] = signrank(squeeze(res.tstat_A(k,3,:)-res.tstat_A(k,1,:)));
     singlebox(squeeze(res.tstat_A(k,3,:)-res.tstat_A(k,1,:)));
end
     
     
%     [hM(k) pM(k)] = ttest(squeeze(res.tstat_M(k,4,:)-res.tstat_M(k,2,:)));
% end
% 
% figure;
% hold on;
% plot(pA);
% plot(pM);
% legend('pA','pM');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kgm = 0;
for kthres_gm = 0.5:0.05:0.70 %0.5:0.05:0.8 %0.5:0.05:0.8
    kgm = kgm + 1;
    kwm = 0;
    for kthres_wm = 0.5:0.05:0.70 %0.5:0.05:0.7
        kwm = kwm + 1;
        disp([int2str(kgm) '_' int2str(kwm)]);
        
        load(fullfile(PROJ_DIR,['DATA_GMWM_MNI_sb_3T_GM' int2str(kthres_gm*100) '_WM' int2str(kthres_wm*100) '_equal.mat']),'res');
        iwm = kthres_wm *100;
        igm = kthres_gm *100;
        
        for k=1:65
            [hA24(kwm,kgm,k) pA24(kwm,kgm,k)] = ttest(squeeze(res.tstat_A(k,4,:)-res.tstat_A(k,2,:)));
            [hM24(kwm,kgm,k) pM24(kwm,kgm,k)] = ttest(squeeze(res.tstat_M(k,4,:)-res.tstat_M(k,2,:)));
            
            [hA13(kwm,kgm,k) pA13(kwm,kgm,k)] = ttest(squeeze(res.tstat_A(k,3,:)-res.tstat_A(k,1,:)));
            [hM13(kwm,kgm,k) pM13(kwm,kgm,k)] = ttest(squeeze(res.tstat_M(k,3,:)-res.tstat_M(k,1,:)));
        end
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp([pA13(3,3,9) pA24(3,3,9)]);
disp([pM13(3,3,9) pM24(3,3,9)]);
    
% disp(squeeze(mean(res.GM_A_me(9,:,:),3))); disp(squeeze(mean(res.GM_A_s(9,:,:),3)))
% 
% 
% %size(COMP_STAT_Ah)     5     5    65     7
% 
% cd /home/realtime
% load COMP_STAT_equal.mat
% plot2dwaves(squeeze(COMP_STAT_Ah(:,:,9,2)+COMP_STAT_Mh(:,:,9,:)))
% 
% plot2dwaves(squeeze(COMP_STAT_Ap(:,:,9,2)))