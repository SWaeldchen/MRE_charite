PROJ_DIR_7T = '/store01_analysis/realtime/edin7T/';
cd(PROJ_DIR_7T);
load mFD.mat
load DATA_GMWM_MNI_sb_7T_GM60_WM60_equal.mat

block = 1; % ???
[r21,p21] = corrcoef(mFD,squeeze(res.tstat_A(block,2,:)-res.tstat_A(block,1,:)));
[r34,p34] = corrcoef(mFD,squeeze(res.tstat_A(block,4,:)-res.tstat_A(block,3,:)));

figure; plot(mFD,squeeze(res.tstat_A(block,2,:)-res.tstat_A(block,1,:)),'*');
figure; plot(mFD,squeeze(res.tstat_A(block,4,:)-res.tstat_A(block,3,:)),'*');
close

disp('----------------------------------');
disp('7T');
disp('ABSG');
disp('r-Werte');
disp([r21(2,1) r34(2,1)]);
disp('p-Werte');
disp([p21(2,1) p34(2,1)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[r21,p21] = corrcoef(mFD,squeeze(res.tstat_M(block,2,:)-res.tstat_M(block,1,:)));
[r34,p34] = corrcoef(mFD,squeeze(res.tstat_M(block,4,:)-res.tstat_M(block,3,:)));

figure; plot(mFD,squeeze(res.tstat_M(block,2,:)-res.tstat_M(block,1,:)),'*');
figure; plot(mFD,squeeze(res.tstat_M(block,4,:)-res.tstat_M(block,3,:)),'*');
close

disp('MAG');
disp('r-Werte');
disp([r21(2,1) r34(2,1)]);
disp('p-Werte');
disp([p21(2,1) p34(2,1)]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55


%%%%%%%%% p/r-Werte PV

clear all
cd /store01_analysis/realtime/PERF3T/
load('DATA_GMWM_MNI_sb_3T_GM60_WM60_equal.mat');
load mFD.mat

figure;

block = 4; 
%[h,p] = ttest(squeeze(res.tstat_A(block,4,:)-res.tstat_A(block,3,:)))
[r21,p21] = corrcoef(mFD,squeeze(res.tstat_A(block,2,:)-res.tstat_A(block,1,:)));
[r34,p34] = corrcoef(mFD,squeeze(res.tstat_A(block,4,:)-res.tstat_A(block,3,:)));

figure; plot(mFD,squeeze(res.tstat_A(block,2,:)-res.tstat_A(block,1,:)),'*');
figure; plot(mFD,squeeze(res.tstat_A(block,4,:)-res.tstat_A(block,3,:)),'*');
close all

disp('----------------------------------');
disp('PERF3T');
disp('ABSG');
disp('r-Werte');
disp([r21(2,1) r34(2,1)]);
disp('p-Werte');
disp([p21(2,1) p34(2,1)]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[r21,p21] = corrcoef(mFD,squeeze(res.tstat_M(block,2,:)-res.tstat_M(block,1,:)));
[r43,p43] = corrcoef(mFD,squeeze(res.tstat_M(block,4,:)-res.tstat_M(block,3,:)));

figure; plot(mFD,squeeze(res.tstat_M(block,2,:)-res.tstat_M(block,1,:)),'*');
figure; plot(mFD,squeeze(res.tstat_M(block,4,:)-res.tstat_M(block,3,:)),'*');
close all

disp('MAG');
disp('r-Werte 21 43');
disp([r21(2,1) r43(2,1)]);
disp('p-Werte: 21 43');
disp([p21(2,1) p43(2,1)]);
